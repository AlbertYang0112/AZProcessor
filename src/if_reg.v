`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "cpu.vh"

module if_reg(
    input wire                  clk,
    input wire                  reset_,

    input wire [`WORD_DATA_BUS] Insn,

    input wire                  Stall,
    input wire                  Flush,
    input wire [`WORD_ADDR_BUS] NewPC,
    input wire                  BrTaken,
    input wire [`WORD_ADDR_BUS] BrAddr,

    output reg [`WORD_ADDR_BUS] IFPC,
    output reg [`WORD_DATA_BUS] IFInsn,
    output reg                  IFEn
);

    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            IFPC    <= #1 `RESET_VECTOR;
            IFInsn  <= #1 `ISA_NOP;
            IFEn    <= #1 `DISABLE;
        end
        else
        begin
            if(Stall == `DISABLE)
            begin
                if(Flush == `ENABLE)
                begin
                    IFPC    <= #1 NewPC;
                    IFInsn  <= #1 `ISA_NOP;
                    IFEn    <= #1 `DISABLE;
                end
                else if (BrTaken == `ENABLE)
                begin
                    IFPC    <= #1 BrAddr;
                    IFInsn  <= #1 Insn;
                    IFEn    <= #1 `ENABLE;
                end
                else
                begin
                    IFPC    <=  IFPC + 1'd1;
                    IFInsn  <= #1 Insn;
                    IFEn    <= #1 `ENABLE;
                end
            end
        end
    end

endmodule
