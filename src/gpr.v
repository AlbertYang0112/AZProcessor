`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "cpu.vh"

module gpr(
    input  wire                     clk,
    input  wire                     reset_,
    input  wire [`REG_ADDR_BUS]     RdAddr0,
    output wire [`WORD_DATA_BUS]    RdData0,
    input  wire [`REG_ADDR_BUS]     RdAddr1,
    output wire [`WORD_DATA_BUS]    RdData1,
    input  wire                     WE_,
    input  wire [`REG_ADDR_BUS]     WrAddr,
    input  wire [`WORD_DATA_BUS]    WrData
);

    reg [`WORD_DATA_BUS] GPR[0 : `REG_NUM];
    integer i;
    
    // Read access
    assign RdData0 = ((WE_ == `ENABLE_) && (WrAddr == RdAddr0)) ? WrData : GPR[RdAddr0];
    assign RdData1 = ((WE_ == `ENABLE_) && (WrAddr == RdAddr1)) ? WrData : GPR[RdAddr1];

    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            for(i = 0; i < `REG_NUM; i = i + 1)
            begin
                GPR[i] <= #1 `WORD_DATA_W'h0;
            end
        end
        else
        begin
            if(WE_ == `ENABLE_)
            begin
                GPR[WrAddr] <= #1 WrData;
            end
        end
    end


endmodule