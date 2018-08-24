`include "nettype.vh"
`include "global_config.vh"
`include "isa.vh"
`include "cpu.vh"
`include "stddef.vh"

module ex_reg(
    input wire                  clk,
    input wire                  reset_,

    input wire [`WORD_DATA_BUS] ALUOut,
    input wire                  ALUOF,

    input wire                  Stall,
    input wire                  Flush,
    input wire                  IntDetect,

    input wire [`WORD_ADDR_BUS] IDPC,
    input wire                  IDEn,
    input wire                  IDBrFlag,
    input wire [`MEM_OP_BUS]    IDMemOp,
    input wire [`WORD_DATA_BUS] IDMemWrData,
    input wire [`CTRL_OP_BUS]   IDCtrlOp,
    input wire [`REG_ADDR_BUS]  IDDstAddr,
    input wire                  IDGPRWE_,
    input wire [`ISA_EXP_BUS]   IDExpCode,

    output reg [`WORD_ADDR_BUS] EXPC,
    output reg                  EXEn,
    output reg                  EXBrFlag,
    output reg [`MEM_OP_BUS]    EXMemOp,
    output reg [`WORD_DATA_BUS] EXMemWrData,
    output reg [`CTRL_OP_BUS]   EXCtrlOp,
    output reg [`REG_ADDR_BUS]  EXDstAddr,
    output reg                  EXGPRWE_,
    output reg [`ISA_EXP_BUS]   EXExpCode,
    output reg [`WORD_DATA_BUS] EXOut
);

    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            EXPC        <= #1 `WORD_ADDR_W'h0;
            EXEn        <= #1 `DISABLE;
            EXBrFlag    <= #1 `DISABLE;
            EXMemOp     <= #1 `MEM_OP_NOP;
            EXMemWrData <= #1 `WORD_DATA_W'h0;
            EXCtrlOp    <= #1 `CTRL_OP_NOP;
            EXDstAddr   <= #1 `REG_ADDR_W'd0;
            EXGPRWE_    <= #1 `DISABLE_;
            EXExpCode   <= #1 `ISA_EXP_NO_EXP;
            EXOut       <= #1 `WORD_DATA_W'h0;
        end 
        else
        begin
            if(Stall == `DISABLE)
            begin
                if(Flush == `ENABLE)
                begin
                    EXPC        <= #1 `WORD_ADDR_W'h0;
                    EXEn        <= #1 `DISABLE;
                    EXBrFlag    <= #1 `DISABLE;
                    EXMemOp     <= #1 `MEM_OP_NOP;
                    EXMemWrData <= #1 `WORD_DATA_W'h0;
                    EXCtrlOp    <= #1 `CTRL_OP_NOP;
                    EXDstAddr   <= #1 `REG_ADDR_W'd0;
                    EXGPRWE_    <= #1 `DISABLE_;
                    EXExpCode   <= #1 `ISA_EXP_NO_EXP;
                    EXOut       <= #1 `WORD_DATA_W'h0;
                end
                else if(IntDetect == `ENABLE)
                begin
                    EXPC        <= #1 IDPC;
                    EXEn        <= #1 IDEn;
                    EXBrFlag    <= #1 IDBrFlag;
                    EXMemOp     <= #1 `MEM_OP_NOP;
                    EXMemWrData <= #1 `WORD_DATA_W'h0;
                    EXCtrlOp    <= #1 `CTRL_OP_NOP;
                    EXDstAddr   <= #1 `REG_ADDR_W'd0;
                    EXGPRWE_    <= #1 `DISABLE_;
                    EXExpCode   <= #1 `ISA_EXP_EXT_INT;
                    EXOut       <= #1 `WORD_DATA_W'h0;
                end
                else if(ALUOF == `ENABLE)
                begin
                    EXPC        <= #1 IDPC;
                    EXEn        <= #1 IDEn;
                    EXBrFlag    <= #1 IDBrFlag;
                    EXMemOp     <= #1 `MEM_OP_NOP;
                    EXMemWrData <= #1 `WORD_DATA_W'h0;
                    EXCtrlOp    <= #1 `CTRL_OP_NOP;
                    EXDstAddr   <= #1 `REG_ADDR_W'd0;
                    EXGPRWE_    <= #1 `DISABLE_;
                    EXExpCode   <= #1 `ISA_EXP_OVERFLOW;
                    EXOut       <= #1 `WORD_DATA_W'h0;
                end
                else
                begin
                    EXPC        <= #1 IDPC;
                    EXEn        <= #1 IDEn;
                    EXBrFlag    <= #1 IDBrFlag;
                    EXMemOp     <= #1 IDMemOp;
                    EXMemWrData <= #1 IDMemWrData;
                    EXCtrlOp    <= #1 IDCtrlOp;
                    EXDstAddr   <= #1 IDDstAddr;
                    EXGPRWE_    <= #1 IDGPRWE_;
                    EXExpCode   <= #1 IDExpCode;
                    EXOut       <= #1 ALUOut;
                end
            end


        end
    end

endmodule