`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "clock.vh"

module system_clock(
    input wire oscp,
    input wire oscn,
    //input wire reset,
    output wire clk,
    output wire clk_,
    output wire dbgclk,
    output wire locked
);

    clk_manager ClkManager(
        .clk_out1(clk),     // output clk_out1
        .clk_out2(dbgclk),
        .clk_out3(clk_),
        // Status and control signals
       // Clock in ports
       //.reset(reset),
        .clk_in1_p(oscp),    // input clk_in1_p
        .clk_in1_n(oscn),    // input clk_in1_n
        .locked(locked)
    );

endmodule
