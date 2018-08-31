`timescale 1ns / 1ps

module tb_Processor();

    parameter cycle = 5;
    reg oscp;
    reg oscn;
    reg reset_;
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
        reset_ = 1;
        #100
        reset_ = 0;
        #20
        reset_ = 1;
    end
    Processor proc(
        .oscp(oscp),
        .oscn(oscn),
        .reset_(reset_),
        .GPIOOut(led)
    );
endmodule