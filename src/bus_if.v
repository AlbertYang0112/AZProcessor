`include "inc/nettype.vh"
`include "inc/global_config.vh"
`include "inc/cpu.vh"
`include "inc/bus.vh"

module bus_if(
    input wire clk,
    input wire reset_,

    input wire Stall,
    input wire Flush,
    output reg Busy,

    input wire [`WORD_ADDR_BUS] Addr,
    input wire As_,
    input wire RW,
    input wire [`WORD_DATA_BUS] WrData,
    output reg [`WORD_DATA_BUS] RdData,

    input wire [`WORD_DATA_BUS] SPMRdData,
    output reg [`WORD_ADDR_BUS] SPMAddr,
    output reg SPMAs_,
    output wire SPMRW,
    output wire [`WORD_DATA_BUS] SPMWrData,

    input wire [`WORD_DATA_BUS] BusRdData,
    input wire BusRdy_,
    input wire BusGrnt_,
    output reg BusReq_,
    output wire [`WORD_ADDR_BUS] BusAddr,
    output reg BusAs_,
    output wire BusRW,
    output wire [`WORD_DATA_BUS] BusWrData,
)

    reg [`BUS_IF_STATE_BUS] state;
    reg [`WORD_DATA_BUS] RdBuf;
    reg [`BUS_SLAVE_INDEX_BUS] sIndex;

    assign sIndex = Addr[`BUS_SLAVE_INDEX_LOC];
    assign SPMRW = RW;
    assign SPMWrData = WrData;

    always @(*)
    begin
        RdData = `WORD_DATA_W'h0;
        SPMAS_ = `DISABLE_;
        Busy = `DISABLE;

        case(state)
            `BUS_IF_STATE_IDLE:
            begin 
                if((Flush == `DISABLE) && (As_ == `ENABLE))
                begin
                    if(sIndex == `BUS_SLAVE_1)
                    begin
                        if(Stall == `DISABLE)
                        begin
                            SPMAs_ = `ENABLE;
                            if(RW == `READ)
                            begin
                                RdData = SPMRdData;
                            end
                        end
                        else
                        begin
                            Busy = `ENABLE;
                        end
                    end
                end
            end
            `BUS_IF_STATE_REQ:
            begin 
                Busy = `ENABLE;
            end
            `BUS_IF_STATE_ACCESS:
            begin 
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
        if(reset == `RESET_ENABLE)
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
                        BusReq_ <= `DISABLE_;
                        BusAddr <= `WORD_ADDR_W'h0;
                        BusRW <= `READ;
                        BusWrData <= `WORD_DATA_W'h0;
                        if(BusRW == `READ)
                        begin
                            RdBuf <= BusRdData;
                        end
                        if(stall == `ENABLE)
                        begin
                            state <= `BUS_IF_STATE_STALL;
                        end
                        else
                        begin
                            state <= `BUS_IF_STATE_IDLE;
                        end
                    end
                end
                `BUS_IF_STATE_STALL:
                begin
                    if(stall == `DISABLE)
                    begin
                        state <= #1 `BUS_IF_STATE_IDLE;
                    end
                end
            endcase
        end
    end

endmodule
