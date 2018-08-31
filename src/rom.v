`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "rom.vh"

module rom(
    input wire clk,
    input wire reset_,

    input wire CS_,
    input wire As_,
    input wire [`ROM_ADDR_LOC] Addr,
    output wire [`WORD_DATA_BUS] RdData,
    output reg Rdy_
);

    blk_mem_rom BlkMemROM(
        .clka(clk),
        .addra(Addr),
        .douta(RdData)
    );

    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            Rdy_ <= #1 `DISABLE_;
        end
        else
        begin
            if((CS_ == `ENABLE) && (As_ == `ENABLE_))
            begin
                Rdy_ <= #1 `ENABLE_;
            end
            else
            begin
                Rdy_ <= #1 `DISABLE_;
            end
        end
    end

endmodule