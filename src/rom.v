`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "rom.vh"

module rom(
    input wire clk,
    input wire reset_,

    input wire CS_,
    input wire As_,
    input wire [`WORD_ADDR_BUS] Addr,
    output wire [`WORD_DATA_BUS] RdData,
    output reg Rdy_
);

    wire [`ROM_ADDR_BUS] RomAddr = Addr[`ROM_ADDR_LOC];

    blk_mem_rom BlkMemROM(
        .clka(clk),
        .addra(RomAddr),
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