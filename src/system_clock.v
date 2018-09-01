`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "clock.vh"

module system_clock(
    input wire oscp,
    input wire oscn,
    input wire reset,
    output wire clk,
    output wire locked
);

    assign clk_ = ~clk;
    clk_manager ClkManager(
        .clk_out1(clk),     // output clk_out1
        // Status and control signals
       // Clock in ports
       //.reset(reset),
        .clk_in1_p(oscp),    // input clk_in1_p
        .locked(locked)
    );

endmodule
