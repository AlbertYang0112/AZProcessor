`include "nettype.vh"
`include "bus.vh"
`include "stddef.vh"

module bus_master_mux(
    input wire [`WORD_ADDR_BUS] m0Addr,
    input wire                  m0As_,
    input wire                  m0RW,
    input wire [`WORD_DATA_BUS] m0Data,
    input wire                  m0Grnt_,
    input wire [`WORD_ADDR_BUS] m1Addr,
    input wire                  m1As_,
    input wire                  m1RW,
    input wire [`WORD_DATA_BUS] m1Data,
    input wire                  m1Grnt_,
    input wire [`WORD_ADDR_BUS] m2Addr,
    input wire                  m2As_,
    input wire                  m2RW,
    input wire [`WORD_DATA_BUS] m2Data,
    input wire                  m2Grnt_,
    input wire [`WORD_ADDR_BUS] m3Addr,
    input wire                  m3As_,
    input wire                  m3RW,
    input wire [`WORD_DATA_BUS] m3Data,
    input wire                  m3Grnt_,
    output reg [`WORD_ADDR_BUS] sAddr,
    output reg                  sAs_,
    output reg                  sRW,
    output reg [`WORD_DATA_BUS] sData
);
    always @(*)
    begin
        if(m0Grnt_ == `ENABLE_)
        begin
            sAddr = m0Addr;
            sAs_ = m0As_;
            sRW = m0RW;
            sData = m0Data;
        end
        else if(m1Grnt_ == `ENABLE_)
        begin
            sAddr = m1Addr;
            sAs_ = m1As_;
            sRW = m1RW;
            sData = m1Data;
        end
        else if(m2Grnt_ == `ENABLE_)
        begin
            sAddr = m2Addr;
            sAs_ = m2As_;
            sRW = m2RW;
            sData = m2Data;
        end
        else if(m3Grnt_ == `ENABLE_)
        begin
            sAddr = m3Addr;
            sAs_ = m3As_;
            sRW = m3RW;
            sData = m3Data;
        end
        else
        begin
            sAddr = `WORD_ADDR_W'h0;
            sAs_ = `DISABLE_;
            sRW = `READ;
            sData = `WORD_DATA_W'h0;
        end
    end
endmodule