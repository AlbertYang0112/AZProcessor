`include "nettype.vh"
`include "global_config.vh"
`include "cpu.vh"

module id_decoder(
    input  wire [`WORD_ADDR_BUS]    IFPC,
    input  wire [`WORD_DATA_BUS]    IFInsn,
    input  wire                     IFEn,

    input  wire [`WORD_DATA_BUS]    GPRRdData0,
    output wire [`REG_ADDR_BUS]     GPRRdAddr0,
    input  wire [`WORD_DATA_BUS]    GPRRdData1,
    output wire [`REG_ADDR_BUS]     GPRRdAddr1,

    input  wire                     IDEn,
    input  wire [`REG_ADDR_BUS]     IDDstAddr,
    input  wire                     IDGPRWE_,
    input  wire [`MEM_OP_BUS]       IDMemOp,

    input  wire                     EXEn,
    input  wire [`REG_ADDR_BUS]     EXDstAddr,
    input  wire                     EXGPRWE_,
    input  wire [`WORD_DATA_BUS]    EXFwdData,

    input  wire [`WORD_DATA_BUS]    MemFwdData,

    input  wire [`CPU_EXE_MODE_BUS] ExeMode,
    input  wire [`WORD_DATA_BUS]    CRegRdData,
    output wire [`REG_ADDR_BUS]     CRegRdAddr,

    output reg  [`ALU_OP_BUS]       ALUOp,
    output reg  [`WORD_DATA_BUS]    ALUIn0,
    output reg  [`WORD_DATA_BUS]    ALUIn1,
    output reg  [`WORD_ADDR_BUS]    BrAddr,
    output reg                      BrTaken,
    output reg                      BrFlag,
    output reg  [`MEM_OP_BUS]       MemOp,
    output wire [`WORD_DATA_BUS]    MemWrData,
    output reg  [`CTRL_OP_BUS]      CtrlOp,
    output reg  [`REG_ADDR_BUS]     DstAddr,
    output reg                      GPRWE_,
    output reg  [`ISA_EXP_BUS]      ExpCode,
    output reg                      LDHazard
);

    wire [`ISA_OP_BUS] Op = IFInsn[`ISA_OP_LOC];
    wire [`REG_ADDR_BUS] RaAddr = IFInsn[`ISA_RA_ADDR_LOC];
    wire [`REG_ADDR_BUS] RbAddr = IFInsn[`ISA_RB_ADDR_LOC];
    wire [`REG_ADDR_BUS] RcAddr = IFInsn[`ISA_RC_ADDR_LOC];
    wire [`ISA_IMM_BUS] Imm = IFInsn[`ISA_IMM_LOC];

    wire [`WORD_DATA_BUS] ImmS = {{`ISA_EXT_W{Imm[`ISA_IMM_MSB]}}, Imm};
    wire [`WORD_DATA_BUS] ImmU = {{`ISA_EXT_W{1'b0}}, Imm};

    assign GPRRdAddr0 = RaAddr;
    assign GPRRdAddr1 = RbAddr;
    assign CRegRdAddr = RaAddr;

    reg [`WORD_DATA_BUS] RaData;
    wire signed [`WORD_DATA_BUS] SRaData = $signed(RaData);
    reg [`WORD_DATA_BUS] RbData;
    wire signed [`WORD_DATA_BUS] SRbData = $signed(RaData);

    wire [`WORD_ADDR_BUS] RetAddr = IFPC + 1'b1;
    wire [`WORD_ADDR_BUS] BrTarget = IFPC + ImmS[`WORD_ADDR_MSB:0];
    wire [`WORD_ADDR_BUS] JrTarget = RaData[`WORD_ADDR_LOC];

    always @(*)
    begin
        if((IDEn == `ENABLE) && (IDGPRWE_ == `ENABLE_) && 
            (IDDstAddr == RaAddr))
        begin
            RaData = EXFwdData;     // EX->ID
        end
        else if((EXEn == `ENABLE) && (EXGPRWE_ == `ENABLE_) && 
                (IDDstAddr == RaAddr))
        begin
            RaData = MemFwdData;    // MEM->ID
        end
        else
        begin
            RaData = GPRRdData0;
        end
        if((IDEn == `ENABLE) && (IDGPRWE_ == `ENABLE_) && 
            (IDDstAddr == RbAddr))
        begin
            RbData = EXFwdData;     // EX->ID
        end
        else if((EXEn == `ENABLE) && (EXGPRWE_ == `ENABLE_) && 
                (IDDstAddr == RbAddr))
        begin
            RbData = MemFwdData;    // MEM->ID
        end
        else
        begin
            RbData = GPRRdData1;
        end
    end

    always @(*)
    begin
        if((IDEn == `ENABLE) && (IDMemOp == `MEM_OP_LDW) && 
            ((IDDstAddr == RaAddr) || (IDDstAddr == RbAddr)))
        begin
            LDHazard = `ENABLE;
        end
        else
        begin
            LDHazard = `DISABLE;
        end
    end

    always @(*)
    begin
        ALUOp = `ALU_OP_NOP;
        ALUIn0 = RaData;
        ALUIn1 = RbData;
        BrTaken = `DISABLE;
        BrFlag = `DISABLE;
        BrAddr = {`WORD_ADDR_W{1'b0}};
        MemOp = `MEM_OP_NOP;
        CtrlOp = `CTRL_OP_NOP;
        DstAddr = RbAddr;
        GPRWE_ = `DISABLE_;
        ExpCode = `ISA_EXP_NO_EXP;
        case (Op)
            `ISA_OP_ANDR:
            begin
                ALUOp = `ALU_OP_AND;
                DstAddr = RcAddr;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_ANDI  :
            begin
                ALUOp = `ALU_OP_AND;
                ALUIn1 = ImmU;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_ORR   :
            begin
                ALUOp = `ALU_OP_OR;
                DstAddr = RcAddr;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_ORI   :
            begin
                ALUOp = `ALU_OP_OR;
                ALUIn1 = ImmU;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_XORR  :
            begin
                ALUOp = `ALU_OP_XOR;
                DstAddr = RcAddr;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_XORI  :
            begin
                ALUOp = `ALU_OP_XOR;
                ALUIn1 = ImmU;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_ADDSR :
            begin
                ALUOp = `ALU_OP_ADDS;
                DstAddr = RcAddr;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_ADDSI :
            begin
                ALUOp = `ALU_OP_ADDS;
                ALUIn1 = ImmS;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_ADDUR :
            begin
                ALUOp = `ALU_OP_ADDU;
                DstAddr = RcAddr;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_ADDUI :
            begin
                ALUOp = `ALU_OP_ADDU;
                ALUIn1 = ImmS;              // Question: Why not ImmU
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_SUBSR :
            begin
                ALUOp = `ALU_OP_SUBS;
                DstAddr = RcAddr;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_SUBUR :
            begin
                ALUOp = `ALU_OP_SUBU;
                DstAddr = RcAddr;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_SHRLR :
            begin
                ALUOp = `ALU_OP_SHRL;
                DstAddr = RcAddr;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_SHRLI :
            begin
                ALUOp = `ALU_OP_SHRL;
                ALUIn1 = ImmU;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_SHLLR :
            begin
                ALUOp = `ALU_OP_SHLL;
                DstAddr = RcAddr;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_SHLLI :
            begin
                ALUOp = `ALU_OP_SHLL;
                ALUIn1 = ImmU;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_BE    :
            begin
                BrAddr = BrTarget;
                BrTaken = (RaData == RbData) ? `ENABLE : `DISABLE;
                BrFlag = `ENABLE;
            end
            `ISA_OP_BNE   :
            begin
                BrAddr = BrTarget;
                BrTaken = (RaData != RbData) ? `ENABLE : `DISABLE;
                BrFlag = `ENABLE;
            end
            `ISA_OP_BSGT  :
            begin
                BrAddr = BrTarget;
                BrTaken = (SRaData < SRbData) ? `ENABLE : `DISABLE;
                BrFlag = `ENABLE;
            end
            `ISA_OP_BUGT  :
            begin
                BrAddr = BrTarget;
                BrTaken = (RaData < RbData) ? `ENABLE : `DISABLE;
                BrFlag = `ENABLE;
            end
            `ISA_OP_JMP   :
            begin
                BrAddr = JrTarget;
                BrTaken = `ENABLE;
                BrFlag = `ENABLE;
            end
            `ISA_OP_CALL  :
            begin
                ALUIn0 = {RetAddr, {`BYTE_OFFSET_W{1'b0}}};
                BrAddr = JrTarget;
                BrTaken = `ENABLE;
                BrFlag = `ENABLE;
                DstAddr = `REG_ADDR_W'd31;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_LDW   :
            begin
                ALUOp = `ALU_OP_ADDU;
                ALUIn1 = ImmS;
                MemOp = `MEM_OP_LDW;
                GPRWE_ = `ENABLE_;
            end
            `ISA_OP_STW   :
            begin
                ALUOp = `ALU_OP_ADDU;
                ALUIn1 = ImmS;
                MemOp = `MEM_OP_STW;
            end
            `ISA_OP_TRAP  :
            begin
                ExpCode = `ISA_EXP_TRAP;
            end
            `ISA_OP_RDCR  :
            begin
                if(ExeMode == `CPU_KERNEL_MODE)
                begin
                    ALUIn0 = CRegRdData;
                    GPRWE_ = `ENABLE_;
                end
                else
                begin
                    ExpCode = `ISA_EXP_PRV_VIO;
                end
            end
            `ISA_OP_WRCR  :
            begin
                if(ExeMode == `CPU_KERNEL_MODE)
                begin
                    CtrlOp = `CTRL_OP_WRCR;
                end
                else
                begin
                    ExpCode = `ISA_EXP_PRV_VIO;
                end
            end
            `ISA_OP_EXRT  :
            begin
                if(ExeMode == `CPU_KERNEL_MODE)
                begin
                    CtrlOp = `CTRL_OP_EXRT;
                end
                else
                begin
                    ExpCode = `ISA_EXP_PRV_VIO;
                end
            end
            default :
            begin
                ExpCode = `ISA_EXP_UNDEF_INSN;
            end

        endcase
    end

endmodule