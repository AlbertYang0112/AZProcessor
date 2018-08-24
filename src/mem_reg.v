`include "nettype.vh"
`include "stddef.vh"
`include "global_config.vh"
`include "cpu.vh"
`include "isa.vh"

module mem_reg(
    input  wire                     clk,
    input  wire                     reset_,

    input  wire                     Out,
    input  wire                     MissAlign,

    input  wire                     Stall,
    input  wire                     Flush,

    input  wire [`WORD_ADDR_BUS]    EXPC,
    input  wire                     EXEn,
    input  wire                     EXBrFlag,
    input  wire [`CTRL_OP_BUS]      EXCtrlOp,
    input  wire [`REG_ADDR_BUS]     EXDstAddr,
    input  wire                     EXGPRWE_,
    input  wire [`ISA_EXP_BUS]      EXExpCode,

    output reg  [`WORD_ADDR_BUS]    MemPC,
    output reg                      MemEn,
    output reg                      MemBrFlag,
    output reg  [`CTRL_OP_BUS]      MemCtrlOp,
    output reg  [`REG_ADDR_BUS]     MemDstAddr,
    output reg                      MemGPRWE_,
    output reg  [`ISA_EXP_BUS]      MemExpCode,
    output reg  [`WORD_DATA_BUS]    MemOut
);

    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            MemPC       <= #1 `WORD_ADDR_W'h0;
            MemEn       <= #1 `DISABLE;
            MemBrFlag   <= #1 `DISABLE;
            MemCtrlOp   <= #1 `CTRL_OP_NOP;
            MemDstAddr  <= #1 `REG_ADDR_W'h0;
            MemGPRWE_   <= #1 `DISABLE_;
            MemExpCode  <= #1 `ISA_EXP_NO_EXP;
            MemOut      <= #1 `WORD_DATA_W'h0;
        end
        else
        begin
            if(Stall == `DISABLE)
            begin
                if(Flush == `ENABLE)
                begin
                    MemPC       <= #1 `WORD_ADDR_W'h0;
                    MemEn       <= #1 `DISABLE;
                    MemBrFlag   <= #1 `DISABLE;
                    MemCtrlOp   <= #1 `CTRL_OP_NOP;
                    MemDstAddr  <= #1 `REG_ADDR_W'h0;
                    MemGPRWE_   <= #1 `DISABLE_;
                    MemExpCode  <= #1 `ISA_EXP_NO_EXP;
                    MemOut      <= #1 `WORD_DATA_W'h0;
                end
                else if(MissAlign == `ENABLE)
                begin
                    MemPC       <= #1 EXPC;
                    MemEn       <= #1 EXEn;
                    MemBrFlag   <= #1 EXBrFlag;
                    MemCtrlOp   <= #1 `CTRL_OP_NOP;
                    MemDstAddr  <= #1 `REG_ADDR_W'h0;
                    MemGPRWE_   <= #1 `DISABLE_;
                    MemExpCode  <= #1 `ISA_EXP_MISS_ALIGN;
                    MemOut      <= #1 `WORD_DATA_W'h0;
                end
                else
                begin
                    MemPC       <= #1 EXPC;
                    MemEn       <= #1 EXEn;
                    MemBrFlag   <= #1 EXBrFlag;
                    MemCtrlOp   <= #1 EXCtrlOp;
                    MemDstAddr  <= #1 EXDstAddr;
                    MemGPRWE_   <= #1 EXGPRWE_; 
                    MemExpCode  <= #1 EXExpCode;
                    MemOut      <= #1 Out;
                end
            end
        end
    end

endmodule
