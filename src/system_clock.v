`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "clock.vh"

module system_clock(
    input wire oscp,
    input wire oscn,
    input wire reset,
    output wire clk,
    output wire clk_
);

    assign clk_ = ~clk;
    clk_manager ClkManager(
        .clk_out1(clk),     // output clk_out1
        // Status and control signals
        .resetn(reset_), // input resetn
       // Clock in ports
        .clk_in1_p(oscp),    // input clk_in1_p
        .clk_in1_n(oscn)    // input clk_in1_n
    );

endmodule
