`timescale 1ns / 1ps
`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "cpu.vh"
`include "gpio.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2018 03:47:48 PM
// Design Name: 
// Module Name: Processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Processor(
    (* KEEP = "{TRUE|FALSE |SOFT}" *) input wire oscp,
    (* KEEP = "{TRUE|FALSE |SOFT}" *) input wire oscn,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire reset_,
    /*(* KEEP = "{TRUE|FALSE |SOFT}" *)output reg UartTX,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire UartRX,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)output wire LED0,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)output wire LED1,
   (* KEEP = "{TRUE|FALSE |SOFT}" *) output wire LED2,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)output wire LED3,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire Button0,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire Button1,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire Button2
    */
    input wire [`GPIO_IN_BUS] GPIOIn,
    output wire [`GPIO_OUT_BUS] GPIOOut
    );

    wire clk; 

    system_clock SystemClock(
        .oscp(oscp),
        .oscn(oscn),
        .reset_(reset_),
        .clk(clk)
    );
    /*
    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            UartTX  <= #1 `HIGH;

        end
    end
*/
    wire [`WORD_DATA_BUS]    MasterSharedBusRdData;
    wire                     MasterSharedBusRdy_;
    wire [`WORD_ADDR_BUS]    SlaveSharedBusAddr;
    wire                     SlaveSharedBusAs_;
    wire                     SlaveSharedBusRW;
    wire [`WORD_DATA_BUS]    SlaveSharedBusWrData;

    wire [`WORD_DATA_BUS]    M0BusRdData;
    wire                     M0BusRdy_;
    wire                     M0BusGrnt_;
    wire                     M0BusReq_;
    wire [`WORD_ADDR_BUS]    M0BusAddr;
    wire                     M0BusAs_;
    wire                     M0BusRW;
    wire [`WORD_DATA_BUS]    M0BusWrData;
    wire [`WORD_DATA_BUS]    M1BusRdData;
    wire                     M1BusRdy_;
    wire                     M1BusGrnt_;
    wire                     M1BusReq_;
    wire [`WORD_ADDR_BUS]    M1BusAddr;
    wire                     M1BusAs_;
    wire                     M1BusRW;
    wire [`WORD_DATA_BUS]    M1BusWrData;
    wire [`WORD_DATA_BUS]    M2BusRdData;
    wire                     M2BusRdy_;
    wire                     M2BusGrnt_;
    wire                     M2BusReq_;
    wire [`WORD_ADDR_BUS]    M2BusAddr;
    wire                     M2BusAs_;
    wire                     M2BusRW;
    wire [`WORD_DATA_BUS]    M2BusWrData;
    wire [`WORD_DATA_BUS]    M3BusRdData;
    wire                     M3BusRdy_;
    wire                     M3BusGrnt_;
    wire                     M3BusReq_;
    wire [`WORD_ADDR_BUS]    M3BusAddr;
    wire                     M3BusAs_;
    wire                     M3BusRW;
    wire [`WORD_DATA_BUS]    M3BusWrData;

    wire                     S0BusCS_;
    wire [`WORD_DATA_BUS]    S0BusRdData;
    wire                     S0BusRdy_;
    wire [`WORD_ADDR_BUS]    S0BusAddr;
    wire                     S0BusAs_;
    wire                     S0BusRW;
    wire [`WORD_DATA_BUS]    S0BusWrData;
    wire                     S1BusCS_;
    wire [`WORD_DATA_BUS]    S1BusRdData;
    wire                     S1BusRdy_;
    wire [`WORD_ADDR_BUS]    S1BusAddr;
    wire                     S1BusAs_;
    wire                     S1BusRW;
    wire [`WORD_DATA_BUS]    S1BusWrData;
    wire                     S2BusCS_;
    wire [`WORD_DATA_BUS]    S2BusRdData;
    wire                     S2BusRdy_;
    wire [`WORD_ADDR_BUS]    S2BusAddr;
    wire                     S2BusAs_;
    wire                     S2BusRW;
    wire [`WORD_DATA_BUS]    S2BusWrData;
    wire                     S3BusCS_;
    wire [`WORD_DATA_BUS]    S3BusRdData;
    wire                     S3BusRdy_;
    wire [`WORD_ADDR_BUS]    S3BusAddr;
    wire                     S3BusAs_;
    wire                     S3BusRW;
    wire [`WORD_DATA_BUS]    S3BusWrData;
    wire                     S4BusCS_;
    wire [`WORD_DATA_BUS]    S4BusRdData;
    wire                     S4BusRdy_;
    wire [`WORD_ADDR_BUS]    S4BusAddr;
    wire                     S4BusAs_;
    wire                     S4BusRW;
    wire [`WORD_DATA_BUS]    S4BusWrData;
    wire                     S5BusCS_;
    wire [`WORD_DATA_BUS]    S5BusRdData;
    wire                     S5BusRdy_;
    wire [`WORD_ADDR_BUS]    S5BusAddr;
    wire                     S5BusAs_;
    wire                     S5BusRW;
    wire [`WORD_DATA_BUS]    S5BusWrData;
    wire                     S6BusCS_;
    wire [`WORD_DATA_BUS]    S6BusRdData;
    wire                     S6BusRdy_;
    wire [`WORD_ADDR_BUS]    S6BusAddr;
    wire                     S6BusAs_;
    wire                     S6BusRW;
    wire [`WORD_DATA_BUS]    S6BusWrData;
    wire                     S7BusCS_;
    wire [`WORD_DATA_BUS]    S7BusRdData;
    wire                     S7BusRdy_;
    wire [`WORD_ADDR_BUS]    S7BusAddr;
    wire                     S7BusAs_;
    wire                     S7BusRW;
    wire [`WORD_DATA_BUS]    S7BusWrData;

    assign M0BusRdData = MasterSharedBusRdData;
    assign M1BusRdData = MasterSharedBusRdData;
    assign M2BusRdData = MasterSharedBusRdData;
    assign M3BusRdData = MasterSharedBusRdData;
    assign M0BusRdy_ = MasterSharedBusRdy_;
    assign M1BusRdy_ = MasterSharedBusRdy_;
    assign M2BusRdy_ = MasterSharedBusRdy_;
    assign M3BusRdy_ = MasterSharedBusRdy_;
    assign S0BusAddr = SlaveSharedBusAddr;
    assign S1BusAddr = SlaveSharedBusAddr;
    assign S2BusAddr = SlaveSharedBusAddr;
    assign S3BusAddr = SlaveSharedBusAddr;
    assign S4BusAddr = SlaveSharedBusAddr;
    assign S5BusAddr = SlaveSharedBusAddr;
    assign S6BusAddr = SlaveSharedBusAddr;
    assign S7BusAddr = SlaveSharedBusAddr;
    assign S0BusAs_ = SlaveSharedBusAs_;
    assign S1BusAs_ = SlaveSharedBusAs_;
    assign S2BusAs_ = SlaveSharedBusAs_;
    assign S3BusAs_ = SlaveSharedBusAs_;
    assign S4BusAs_ = SlaveSharedBusAs_;
    assign S5BusAs_ = SlaveSharedBusAs_;
    assign S6BusAs_ = SlaveSharedBusAs_;
    assign S7BusAs_ = SlaveSharedBusAs_;
    assign S0BusRW = SlaveSharedBusRW;
    assign S1BusRW = SlaveSharedBusRW;
    assign S2BusRW = SlaveSharedBusRW;
    assign S3BusRW = SlaveSharedBusRW;
    assign S4BusRW = SlaveSharedBusRW;
    assign S5BusRW = SlaveSharedBusRW;
    assign S6BusRW = SlaveSharedBusRW;
    assign S7BusRW = SlaveSharedBusRW;
    assign S0BusWrData = SlaveSharedBusWrData;
    assign S1BusWrData = SlaveSharedBusWrData;
    assign S2BusWrData = SlaveSharedBusWrData;
    assign S3BusWrData = SlaveSharedBusWrData;
    assign S4BusWrData = SlaveSharedBusWrData;
    assign S5BusWrData = SlaveSharedBusWrData;
    assign S6BusWrData = SlaveSharedBusWrData;
    assign S7BusWrData = SlaveSharedBusWrData;

    wire [`CPU_IRQ_BUS] IRQ;
/*
    wire [`GPIO_IN_BUS] GPIOIn;
    wire [`GPIO_OUT_BUS]  GPIOOut;

    assign GPIOIn[0] = Button0;
    assign GPIOIn[1] = Button1;
    assign GPIOIn[2] = Button2;
    assign LED0 = GPIOOut[0];
    assign LED1 = GPIOOut[1];
    assign LED2 = GPIOOut[2];
    assign LED3 = GPIOOut[3];
    */

    
    cpu CPU(
        .clk(clk),
        .reset_(reset_),
        .M0BusRdData(M0BusRdData),
        .M0BusRdy_(M0BusRdy_),
        .M0BusGrnt_(M0BusGrnt_),
        .M0BusReq_(M0BusReq_),
        .M0BusAddr(M0BusAddr),
        .M0BusAs_(M0BusAs_),
        .M0BusRW(M0BusRW),
        .M0BusWrData(M0BusWrData),
        .M1BusRdData(M1BusRdData),
        .M1BusRdy_(M1BusRdy_),
        .M1BusGrnt_(M1BusGrnt_),
        .M1BusReq_(M1BusReq_),
        .M1BusAddr(M1BusAddr),
        .M1BusAs_(M1BusAs_),
        .M1BusRW(M1BusRW),
        .M1BusWrData(M1BusWrData),
        .IRQ(IRQ)
    );

    rom ROMModule(
        .clk(clk),
        .reset_(reset_),

        .CS_(S0BusCS_),
        .As_(S0BusAs_),
        .Addr(S0BusAddr),
        .RdData(S0BusRdData),
        .Rdy_(S0BusRdy_)
    );

    gpio GPIOModule(
        .clk(clk),
        .reset_(reset_),
    
        .CS_(S4BusCS_),
        .As_(S4BusAs_),
        .RW(S4BusRW),
        .Addr(S4BusAddr),
        .WrData(S4BusWrData),
        .RdData(S4BusRdData),
        .Rdy_(S4BusRdy_),

        .GPIOIn(GPIOIn),
        .GPIOOut(GPIOOut)
    );
    
    bus Bus(
        .clk(clk),
        .reset_(reset_),
        .m0Req_(M0BusReq_),
        .m1Req_(M1BusReq_),
        .m2Req_(M2BusReq_),
        .m3Req_(M3BusReq_),
        .m0Grnt_(M0BusGrnt_),
        .m1Grnt_(M1BusGrnt_),
        .m2Grnt_(M2BusGrnt_),
        .m3Grnt_(M3BusGrnt_),
        .m0Addr(M0BusAddr),
        .m1Addr(M1BusAddr),
        .m2Addr(M2BusAddr),
        .m3Addr(M3BusAddr),
        .m0As_(M0BusAs_),
        .m1As_(M1BusAs_),
        .m2As_(M2BusAs_),
        .m3As_(M3BusAs_),
        .m0RW(M0BusRW),
        .m1RW(M1BusRW),
        .m2RW(M2BusRW),
        .m3RW(M3BusRW),
        .m0Data(M0BusWrData),
        .m1Data(M1BusWrData),
        .m2Data(M2BusWrData),
        .m3Data(M3BusWrData),
        .sAddr(SlaveSharedBusAddr),
        .sAs_(SlaveSharedBusAs_),
        .sRW(SlaveSharedBusRW),
        .sData(SlaveSharedBusWrData),
        .s0CS_(S0BusCS_),
        .s1CS_(S1BusCS_),
        .s2CS_(S2BusCS_),
        .s3CS_(S3BusCS_),
        .s4CS_(S4BusCS_),
        .s5CS_(S5BusCS_),
        .s6CS_(S6BusCS_),
        .s7CS_(S7BusCS_),
        .s0RdData(S0BusRdData),
        .s1RdData(S1BusRdData),
        .s2RdData(S2BusRdData),
        .s3RdData(S3BusRdData),
        .s4RdData(S4BusRdData),
        .s5RdData(S5BusRdData),
        .s6RdData(S6BusRdData),
        .s7RdData(S7BusRdData),
        .s0Rdy_(S0BusRdy_),
        .s1Rdy_(S1BusRdy_),
        .s2Rdy_(S2BusRdy_),
        .s3Rdy_(S3BusRdy_),
        .s4Rdy_(S4BusRdy_),
        .s5Rdy_(S5BusRdy_),
        .s6Rdy_(S6BusRdy_),
        .s7Rdy_(S7BusRdy_),
        .mRdData(MasterSharedBusRdData),
        .mRdy_(MasterSharedBusRdy_)
    );
endmodule
