`include "nettype.vh"
`include "global_config.vh"
`include "cpu.vh"
`include "bus.vh"
`include "spm.vh"

module bus_if(
    input wire                      clk,
    input wire                      reset_,

    input wire                      Stall,
    input wire                      Flush,
    output reg                      Busy,

    input wire [`WORD_ADDR_BUS]     Addr,
    input wire                      As_,
    input wire                      RW,
    input wire [`WORD_DATA_BUS]     WrData,
    output reg [`WORD_DATA_BUS]     RdData,

    input wire [`WORD_DATA_BUS]     SPMRdData,
    output wire [`SPM_ADDR_BUS]     SPMAddr,
    output reg                      SPMAs_,
    output wire                     SPMRW,
    output wire [`WORD_DATA_BUS]    SPMWrData,

    input wire [`WORD_DATA_BUS]     BusRdData,
    input wire                      BusRdy_,
    input wire                      BusGrnt_,
    output reg                      BusReq_,
    output reg  [`WORD_ADDR_BUS]    BusAddr,
    output reg                      BusAs_,
    output reg                      BusRW,
    output reg  [`WORD_DATA_BUS]    BusWrData
);

    reg  [`BUS_IF_STATE_BUS]    state;
    reg  [`WORD_DATA_BUS]       RdBuf;
    wire [`BUS_SLAVE_INDEX_BUS] sIndex;

    assign sIndex = Addr[`BUS_SLAVE_INDEX_LOC];
    
    assign SPMAddr = Addr;
    assign SPMRW = RW;
    assign SPMWrData = WrData;

    always @(*)
    begin
        RdData = `WORD_DATA_W'h0;
        SPMAs_ = `DISABLE_;
        Busy = `DISABLE;

        case(state)
            `BUS_IF_STATE_IDLE:
            begin 
                if((Flush == `DISABLE) && (As_ == `ENABLE_))
                begin
                    if(sIndex == `BUS_SLAVE_1)
                    begin
                        if(Stall == `DISABLE)
                        begin
                            SPMAs_ = `ENABLE_;
                            if(RW == `READ)
                            begin
                                RdData = SPMRdData;
                            end
                        end
                    end
                    else
                    begin
                        Busy = `ENABLE;
                    end
                end
            end
            `BUS_IF_STATE_REQ:
            begin 
                Busy = `ENABLE;
            end
            `BUS_IF_STATE_ACCESS:
            begin 
                //Busy = `ENABLE;
                if(BusRdy_ == `ENABLE_)
                begin
                    if(RW == `READ)
                    begin
                        RdData = BusRdData;
                    end
                end
                else
                begin
                    Busy = `ENABLE;
                end
            end
            `BUS_IF_STATE_STALL:
            begin 
                if(RW == `READ)
                begin
                    RdData = RdBuf;
                end
            end
        endcase
    end

    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            state       <= #1 `BUS_IF_STATE_IDLE;
            BusReq_     <= #1 `DISABLE_;
            BusAddr     <= #1 `WORD_ADDR_W'h0;
            BusAs_      <= #1 `DISABLE_;
            BusRW       <= #1 `READ;
            BusWrData   <= #1 `WORD_DATA_W'h0;
            RdBuf       <= #1 `WORD_DATA_W'h0;
        end
        else
        begin
            case (state)
                `BUS_IF_STATE_IDLE:
                begin
                    if((Flush == `DISABLE) && (As_ == `ENABLE_))
                    begin
                        state       <= #1 `BUS_IF_STATE_REQ;
                        BusReq_     <= #1 `ENABLE_;
                        BusAddr     <= #1 Addr;
                        BusRW       <= #1 RW;
                        BusWrData   <= #1 WrData;
                    end
                end
                `BUS_IF_STATE_REQ:
                begin
                    if(BusGrnt_ == `ENABLE_)
                    begin
                        state   <= #1 `BUS_IF_STATE_ACCESS;
                        BusAs_  <= #1 `ENABLE_;
                    end
                end
                `BUS_IF_STATE_ACCESS:
                begin
                    BusAs_ <= #1 `DISABLE_;
                    if(BusRdy_ == `ENABLE_)
                    begin
                        BusReq_ <= #1 `DISABLE_;
                        BusAddr <= #1 `WORD_ADDR_W'h0;
                        BusRW <= #1 `READ;
                        BusWrData <= #1 `WORD_DATA_W'h0;
                        if(BusRW == `READ)
                        begin
                            RdBuf <= #1 BusRdData;
                        end
                        //state <= #1 `BUS_IF_STATE_IDLE;
                        if(Stall == `ENABLE)
                        begin
                            state <= #1 `BUS_IF_STATE_STALL;
                        end
                        else
                        begin
                            state <= #1 `BUS_IF_STATE_IDLE;
                            
                        end
                    end
                end
                `BUS_IF_STATE_STALL:
                begin
                    if(Stall == `DISABLE)
                    begin
                        state <= #1 `BUS_IF_STATE_IDLE;
                    end
                end
            endcase
        end
    end

endmodule
