`include "inc/nettype.vh"
`include "inc/global_config.vh"
`include "inc/isa.vh"
`include "inc/cpu.vh"
`include "inc/stddef.vh"

module ctrl(
    input  wire clk,
    input  wire reset_,

    input  wire [`REG_ADDR_BUS]     CRegRdAddr,
    output reg  [`WORD_DATA_BUS]    CRegRdData,
    output reg  [`CPU_EXE_MODE_BUS] ExeMode,

    input  wire [`CPU_IRQ_BUS]    IRQ,
    output reg                      IntDetect,

    input  wire [`WORD_ADDR_BUS]    IDPC,

    input  wire [`WORD_ADDR_BUS]    MEMPC,
    input  wire                     MemEn,
    input  wire                     MemBrFlag,
    input  wire [`CTRL_OP_BUS]      MemCtrlOp,
    input  wire [`REG_ADDR_BUS]     MemDstAddr,
    input  wire                     MemGPRWE_,
    input  wire [`ISA_EXP_BUS]      MemExpCode,
    input  wire [`WORD_DATA_BUS]    MemOut,

    input  wire                     IFBusy,
    input  wire                     LDHazard,
    input  wire                     MemBusy,

    output wire                     IFStall,
    output wire                     IDStall,
    output wire                     EXStall,
    output wire                     MemStall,

    output wire                     IFFlush,
    output wire                     IDFlush,
    output wire                     EXFlush,
    output wire                     MemFlush,
    output reg  [`WORD_ADDR_BUS]    NewPC,
)
    reg                     IntEn;
    reg                     PreExeMode;
    reg                     PreIntEn,
    reg [`WORD_ADDR_BUS]    EPC;
    reg [`WORD_ADDR_BUS]    ExpVector;
    reg [`ISA_EXP_BUS]      ExpCode;
    reg                     DlyFlag;
    reg [`BYTE_DATA_BUS]    Mask;
    reg [`WORD_ADDR_BUS]    PrePC;
    reg                     BrFlag;

    wire Stall = IFBusy | MemBusy;
    assign IFStall  = Stall;
    assign IDStall  = Stall;
    assign EXStall  = Stall;
    assign MemStall = Stall;

    reg Flush;
    assign IFFlush  = Flush;
    assign IDFlush  = Flush | LDHazard;
    assign EXFlush  = Flush;
    assign MemFlush = Flush;

    always @(*)
    begin
        NewPC = `WORD_ADDR_W'h0;
        Flush = `DISABLE;
        if(MemEn == `ENABLE)
        begin
            if(MemExpCode != `ISA_EXP_NO_EXP)
            begin
                NewPC = ExpVector;
                Flush = `ENABLE;
            end
            else if(MemCtrlOp == `CTRL_OP_EXRT)
            begin
                NewPC = EPC;
                Flush = `ENABLE;
            end
            else if(MemCtrlOp == `CTRL_OP_WRCR)
            begin
                NewPC = MemPC;
                Flush = `ENABLE;
            end
        end
    end

    always @(*)
    begin
        if((IntEn == `ENABLE) && (|((~mask) & IRQ) == `ENABLE))
        begin
            IntDetect = `ENABLE;
        end
        else 
        begin
            IntDetect = `DISABLE;
        end
    end

    always @(*)
    begin
        case(CRegRdAddr)
            `CREG_ADDR_STATUS     :
            begin
                CRegRdData = {{`WORD_DATA_W - 2{1'b0}}, IntEn, ExeMode};
            end
            `CREG_ADDR_PRE_STATUS :
            begin
                CRegRdData = {{`WORD_DATA_W - 2{1'b0}}, PreIntEn, PreExeMode};
            end
            `CREG_ADDR_PC         :
            begin
                CRegRdData = {IDPC, `BYTE_OFFSET_W'h0};
            end
            `CREG_ADDR_EPC        :
            begin
                CRegRdData = {EPC, `BYTE_OFFSET_W'h0};
            end
            `CREG_ADDR_EXP_VECTOR :
            begin
                CRegRdData = {ExpVector, `BYTE_OFFSET_W'h0};
            end
            `CREG_ADDR_CAUSE      :
            begin
                CRegRdData = {{`WORD_DATA_W - `ISA_EXP_W{1'b0}}, DlyFlag, ExpCode};
            end
            `CREG_ADDR_INT_MASK   :
            begin
                CRegRdData = {{`WORD_DATA_W - `CPU_IRQ_CH{1'b0}}, Mask};
            end
            `CREG_ADDR_IRQ        :
            begin
                CRegRdData = {{`WORD_DATA_W - `CPU_IRQ_CH{1'b0}}, IRQ};
            end
            `CREG_ADDR_ROM_SIZE   :
            begin
                CRegRdData = $unsigned(`ROM_SIZE);
            end
            `CREG_ADDR_SPM_SIZE   :
            begin
                CRegRdData = $unsigned(`SPM_SIZE);
            end
            `CREG_ADR_CPU_INFO    :
            begin
                CRegRdData = {`RELEASE_YEAR, `RELEASE_MONTH, `RELEASE_VERSION, `RELEASE_REVERSION};
            end
            default:
            begin
                CRegRdData = `WORD_DATA_W'h0;
            end
        endcase
    end

    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            ExeMode     <= #1 `CPU_KERNEL_MODE;
            IntEn       <= #1 `DISABLE;
            PreExeMode  <= #1 `CPU_KERNEL_MODE;
            PreIntEn    <= #1 `DISABLE;
            ExpCode     <= #1 `ISA_EXP_NO_EXP;
            Mask        <= #1 {`CPU_IRQ_CH{`ENABLE}};
            DlyFlag     <= #1 `DISABLE;
            EPC         <= #1 `WORD_ADDR_W'h0;
            ExpVector   <= #1 `WORD_ADDR_W'h0;
            PrePC       <= #1 `WORD_ADDR_W'h0;
            BrFlag      <= #1 `DISABLE;
        end
        else
        begin
            if((MemEn == `ENABLE) && (Stall == `DISABLE))
            begin
                PrePC <= #1 MemPC;
                BrFlag <= #1 MemBrFlag;
                if(MemExpCode != `ISA_EXP_NO_EXP)
                begin
                    ExeMode     <= #1 `CPU_KERNEL_MODE;
                    IntEn       <= #1 `DISABLE;
                    PreExeMode  <= #1 ExeMode;
                    PreIntEn    <= #1 IntEn;
                    ExpCode     <= #1 MemExpCode;
                    DlyFlag     <= #1 BrFlag;
                    EPC         <= #1 PrePC;
                end
                else if(MemCtrlOp == `CTRL_OP_EXRT)
                begin
                    ExeMode     <= #1 PreExeMode;
                    IntEn       <= #1 PreIntEn;
                end
                else if(MemCtrlOp == `CTRL_OP_WRCR)
                begin
                    case (MemDstAddr)
                        `CREG_ADDR_STATUS:
                        begin
                            ExeMode     <= #1 MemOut[`CREG_EXE_MODE_LOC];
                            IntEn       <= #1 MemOut[`CREG_INT_ENABLE_LOC];
                        end
                        `CREG_ADDR_PRE_STATUS:
                        begin
                            PreExeMode  <= #1 MemOut[`CREG_EXE_MODE_LOC];
                            PreIntEn    <= #1 MemOut[`CREG_INT_ENABLE_LOC];
                        end
                        `CREG_ADDR_EPC:
                        begin
                            EPC         <= #1 MemOut[`WORD_ADDR_LOC];
                        end
                        `CREG_ADDR_EXP_VECTOR:
                        begin
                            ExpVector   <= #1 MemOut[`WORD_ADDR_LOC];
                        end
                        `CREG_ADDR_CAUSE:
                        begin
                            DlyFlag     <= #1 MemOut[`CREG_DLY_FLAG_LOC];
                            ExpCode     <= #1 MemOut[`CREG_EXP_CODE_LOC];
                        end
                        `CREG_ADDR_INT_MASK:
                        begin
                            Mask        <= #1 MemOut[`CPU_IRQ_BUS];
                        end
                    endcase
                end
            end
        end
    end


endmodule