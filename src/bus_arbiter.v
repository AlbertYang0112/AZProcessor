`include "inc/bus.vh"
`include "inc/nettype.vh"
`include "inc/stddef.vh"

module BusArbiter(
    wire input clk,
    wire input reset,
    wire input req\_[BUS_OWNER_BUS],
    reg output grnt\_[BUS_OWNER_BUS],
)
    reg owner[BUS_OWNER_BUS] = `BUS_OWNER_MASTER_0;
    always @(posedge clk or `RESET_EDGE reset) 
    begin
        if(reset == `RESET_ENABLE)
        begin
            owner <= #1 `BUS_OWNER_MASTER_0;   
        end else
        begin
            
        end
    end
endmodule
