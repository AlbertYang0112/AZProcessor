`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "clock.vh"

module system_clock(
    input wire osc,
    input wire reset_,
    output reg clk,
    output wire clk_
);

    integer clkDiv;
    assign clk_ = ~clk;
    always @(posedge osc or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            clk = #1 `LOW;
        end
        else
        begin
            if(clkDiv >= `CLOCK_DIV)
            begin
                clk = #1 ~clk;
                clkDiv = #1 0;
            end
            else
            begin
                clkDiv = #1 clkDiv + 1;
            end
        end
    end

endmodule
