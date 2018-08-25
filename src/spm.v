`include "nettype.vh"
`include "global_config.vh"
`include "cpu.vh"
`include "spm.vh"

module spm(
    input wire                      clk,
    input wire                      reset_,
    input wire [`SPM_ADDR_BUS]      IFSPMAddr,
    input wire                      IFSPMAs_,
    input wire                      IFSPMRW,
    input wire [`WORD_DATA_BUS]     IFSPMWrData,
    output wire [`WORD_DATA_BUS]    IFSPMRdData,
    input wire [`SPM_ADDR_BUS]      MemSPMAddr,
    input wire                      MemSPMAs_,
    input wire                      MemSPMRW,
    input wire [`WORD_DATA_BUS]     MemSPMWrData,
    output wire [`WORD_DATA_BUS]    MemSPMRdData
);

    reg wea;
    reg web;

    always @(*)
    begin
        if((IFSPMAs_ == `ENABLE) && (IFSPMRW == `WRITE))
        begin
            wea = `MEM_ENABLE;
        end
        else
        begin
            wea = `MEM_DISABLE;
        end
        if((MemSPMAs_ == `ENABLE) && (MemSPMRW == `WRITE))
        begin
            web = `MEM_ENABLE;
        end
        else
        begin
            web = `MEM_DISABLE;
        end
    end

    blk_mem_spm BlkMemSPM(
        .clka(clk),
        .rsta(reset_),
        .wea(wea),
        .addra(IFSPMAddr),
        .dina(IFSPMWrData),
        .douta(IFSPMRdData),
        .clkb(clk),
        .rstb(reset_),
        .web(web),
        .addrb(MemSPMAddr),
        .dinb(MemSPMWrData),
        .doutb(MemSPMRdData)
    );

endmodule