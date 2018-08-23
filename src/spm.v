`include "inc/nettype.vh"
`include "inc/global_config.vh"
`include "inc/cpu.vh"
`include "inc/spm.vh"

module spm(
    input wire                      clk,
    input wire [`SPM_ADDR_BUS]      IFSPMAddr,
    input wire                      IFSPMAs_,
    input wire                      IFSPMRW,
    input wire [`WORD_DATA_BUS]     IFSPMWrData,
    output wire [`WORD_DATA_BUS]    IFSPMRdData,
    input wire [`SPM_ADDR_BUS]      MemSPMAddr,
    input wire                      MemSPMAs_,
    input wire                      MemSPMRW,
    input wire [`WORD_DATA_BUS]     MemSPMWrData,
    output wire [`WORD_DATA_BUS]    MemSPMRdData,
)

    reg wea;
    reg web;

    always @(*)
    begin
        if((IFSPMAS_ == `ENABLE) && (IFSPMRW == `WRITE))
        begin
            wea = `MEM_ENABLE;
        end
        else
        begin
            wea = `MEM_DISABLE;
        end
        if((MemSPMAS_ == `ENABLE) && (MemSPMRW == `WRITE))
        begin
            web = `MEM_ENABLE;
        end
        else
        begin
            web = `MEM_DISABLE;
        end
    end

    // Todo: Implement the dual port ram.

endmodule