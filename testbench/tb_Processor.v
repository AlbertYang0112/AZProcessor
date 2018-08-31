`timescale 1ns / 1ps
`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"

module tb_Processor();

    parameter cycle = 5;
    reg oscp;
    reg oscn;
    reg resetIn_;
    wire [7:0] led;
    wire clk;
    wire [`WORD_DATA_BUS] M0BusRdData;
    wire M0BusRdy_;
    wire M0BusGrnt_;
    wire M0BusReq_;
    wire [`WORD_ADDR_BUS] M0BusAddr;
    wire M0BusAs_;
    wire M0BusRW;
    wire [`WORD_DATA_BUS] M0BusWrData;
    wire [`WORD_ADDR_BUS] IFPC;

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
        resetIn_ = 1;
        #100
        resetIn_ = 0;
        #20
        resetIn_ = 1;
    end
    Processor proc(
        .oscp(oscp),
        .oscn(oscn),
        .resetIn_(resetIn_),
        .GPIOOut(led),
        .clk(clk),
        .M0BusRdData(M0BusRdData),
        .M0BusRdy_(M0BusRdy_),
        .M0BusGrnt_(M0BusGrnt_),
        .M0BusReq_(M0BusReq_),
        .M0BusAddr(M0BusAddr),
        .M0BusAs_(M0BusAs_),
        .M0BusRW(M0BusRW),
        .M0BusWrData(M0BusWrData),
        .IFPC(IFPC)
    );
endmodule