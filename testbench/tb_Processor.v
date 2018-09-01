`timescale 1ns / 1ps
`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"

module tb_Processor();

    parameter cycle = 5;
    reg oscp;
    reg oscn;
    reg resetIn;
    wire [7:0] led;

    initial
    begin
        oscp = 1;
        oscn = 0;
        #20
        forever
        begin
            #(cycle / 2)
            oscp = ~oscp;
            oscn = ~oscn;
        end
    end
    initial
    begin
        resetIn = 0;
        #100
        resetIn = 1;
        #20
        resetIn = 0;
    end
    Processor proc(
        .oscp(oscp),
        .oscn(oscn),
        .resetIn(resetIn),
        .GPIOOut(led)
    );
endmodule