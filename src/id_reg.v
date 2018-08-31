`include "nettype.vh"
`include "global_config.vh"
`include "cpu.vh"

module id_reg(
    input  wire                     clk,
    input  wire                     reset_,

    input  wire [`ALU_OP_BUS]       ALUOp,
    input  wire [`WORD_DATA_BUS]    ALUIn0,
    input  wire [`WORD_DATA_BUS]    ALUIn1,
    input  wire                     BrFlag,
    input  wire [`MEM_OP_BUS]       MemOp,
    input  wire [`WORD_DATA_BUS]    MemWrData,
    input  wire [`CTRL_OP_BUS]      CtrlOp,
    input  wire [`REG_ADDR_BUS]     DstAddr,
    input  wire                     GPRWE_,
    input  wire [`ISA_EXP_BUS]      ExpCode,

    input  wire                     Stall,
    input  wire                     Flush,

    input  wire [`WORD_ADDR_BUS]    IFPC,
    input  wire                     IFEn,

    output reg  [`WORD_ADDR_BUS]    IDPC,
    output reg                      IDEn,
    output reg  [`ALU_OP_BUS]       IDALUOp,
    output reg  [`WORD_DATA_BUS]    IDALUIn0,
    output reg  [`WORD_DATA_BUS]    IDALUIn1,
    output reg                      IDBrFlag,
    output reg  [`MEM_OP_BUS]       IDMemOp,
    output reg  [`WORD_DATA_BUS]    IDMemWrData,
    output reg  [`CTRL_OP_BUS]      IDCtrlOp,
    output reg  [`REG_ADDR_BUS]     IDDstAddr,
    output reg                      IDGPRWE_,
    output reg  [`ISA_EXP_BUS]      IDExpCode
);

    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            IDPC        <= #1 `WORD_ADDR_W'h0;
            IDEn        <= #1 `DISABLE;
            IDALUOp     <= #1 `ALU_OP_NOP;
            IDALUIn0    <= #1 `WORD_DATA_W'h0;
            IDALUIn1    <= #1 `WORD_DATA_W'h0;
            IDBrFlag    <= #1 `DISABLE;
            IDMemOp     <= #1 `MEM_OP_NOP;
            IDMemWrData <= #1 `WORD_DATA_W'h0;
            IDCtrlOp    <= #1 `CTRL_OP_NOP;
            IDDstAddr   <= #1 `REG_ADDR_W'h0;
            IDGPRWE_    <= #1 `DISABLE_;
            IDExpCode   <= #1 `ISA_EXP_NO_EXP;
        end
        else
        begin
            if(Stall == `DISABLE)
            begin
                if(Flush == `ENABLE)
                begin
                    IDPC        <= #1 `WORD_ADDR_W'h0;
                    IDEn        <= #1 `DISABLE;
                    IDALUOp     <= #1 `ALU_OP_NOP;
                    IDALUIn0    <= #1 `WORD_DATA_W'h0;
                    IDALUIn1    <= #1 `WORD_DATA_W'h0;
                    IDBrFlag    <= #1 `DISABLE;
                    IDMemOp     <= #1 `MEM_OP_NOP;
                    IDMemWrData <= #1 `WORD_DATA_W'h0;
                    IDCtrlOp    <= #1 `CTRL_OP_NOP;
                    IDDstAddr   <= #1 `REG_ADDR_W'h0;
                    IDGPRWE_    <= #1 `DISABLE_;
                    IDExpCode   <= #1 `ISA_EXP_NO_EXP;
                end
                else
                begin
                    IDPC        <= #1 IFPC;
                    IDEn        <= #1 IFEn;
                    IDALUOp     <= #1 ALUOp;
                    IDALUIn0    <= #1 ALUIn0;
                    IDALUIn1    <= #1 ALUIn1;
                    IDBrFlag    <= #1 BrFlag;
                    IDMemOp     <= #1 MemOp;
                    IDMemWrData <= #1 MemWrData;
                    IDCtrlOp    <= #1 CtrlOp;
                    IDDstAddr   <= #1 DstAddr;
                    IDGPRWE_    <= #1 GPRWE_;
                    IDExpCode   <= #1 ExpCode;
                end
            end
        end
    end
endmodule
