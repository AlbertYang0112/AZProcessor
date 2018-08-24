`include "nettype.vh"
`include "bus.vh"
`include "stddef.vh"

module bus_slave_mux(
    input wire                  s0CS_,
    input wire [`WORD_DATA_BUS] s0RdData,
    input wire                  s0Rdy_,
    input wire                  s1CS_,
    input wire [`WORD_DATA_BUS] s1RdData,
    input wire                  s1Rdy_,
    input wire                  s2CS_,
    input wire [`WORD_DATA_BUS] s2RdData,
    input wire                  s2Rdy_,
    input wire                  s3CS_,
    input wire [`WORD_DATA_BUS] s3RdData,
    input wire                  s3Rdy_,
    input wire                  s4CS_,
    input wire [`WORD_DATA_BUS] s4RdData,
    input wire                  s4Rdy_,
    input wire                  s5CS_,
    input wire [`WORD_DATA_BUS] s5RdData,
    input wire                  s5Rdy_,
    input wire                  s6CS_,
    input wire [`WORD_DATA_BUS] s6RdData,
    input wire                  s6Rdy_,
    input wire                  s7CS_,
    input wire [`WORD_DATA_BUS] s7RdData,
    input wire                  s7Rdy_,
    output reg [`WORD_DATA_BUS] mRdData,
    output reg                  mRdy_
);

    always @(*)
    begin
        if(s0CS_ == `ENABLE)
        begin
            mRdData = s0RdData;
            mRdy_ = s0Rdy_;
        end
        else if(s1CS_ == `ENABLE)
        begin
            mRdData = s1RdData;
            mRdy_ = s1Rdy_;
        end
        else if(s2CS_ == `ENABLE)
        begin
            mRdData = s2RdData;
            mRdy_ = s2Rdy_;
        end
        else if(s3CS_ == `ENABLE)
        begin
            mRdData = s3RdData;
            mRdy_ = s3Rdy_;
        end
        else if(s4CS_ == `ENABLE)
        begin
            mRdData = s4RdData;
            mRdy_ = s4Rdy_;
        end
        else if(s5CS_ == `ENABLE)
        begin
            mRdData = s5RdData;
            mRdy_ = s5Rdy_;
        end
        else if(s6CS_ == `ENABLE)
        begin
            mRdData = s6RdData;
            mRdy_ = s6Rdy_;
        end
        else if(s7CS_ == `ENABLE)
        begin
            mRdData = s7RdData;
            mRdy_ = s7Rdy_;
        end
        else
        begin
            mRdData = `WORD_DATA_W'h0;
            mRdy_ = `DISABLE;
        end
    
    end

endmodule