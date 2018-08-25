`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "gpio.vh"

module gpio(
    input wire clk,
    input wire reset_,
    
    input wire CS_,
    input wire As_,
    input wire RW,
    input wire [`WORD_ADDR_BUS] Addr,
    input wire [`WORD_DATA_BUS] WrData,
    output reg [`WORD_DATA_BUS] RdData,
    output reg Rdy_,

    input wire [`GPIO_IN_BUS] GPIOIn,
    output reg [`GPIO_OUT_BUS] GPIOOut
    // inout wire [`GPIO_IO_BUS] GPIOIO
);

    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            RdData  <= #1 `WORD_DATA_W'h0;
            Rdy_    <= #1 `DISABLE_;
`ifdef GPIO_OUT_CH
            GPIOOut <= #1 {`GPIO_OUT_CH{`HIGH}};
`endif
        end
        else
        begin
            if((CS_ == `ENABLE_) && (As_ == `ENABLE_))
            begin
                Rdy_ <= #1 `ENABLE_;
            end
            else
            begin
                Rdy_ <= #1 `DISABLE_;
            end

            if((CS_ == `ENABLE_) && (As_ == `ENABLE_) && (RW == `READ))
            begin
                case(Addr)
`ifdef GPIO_IN_CH
                    `GPIO_ADDR_IN_DATA:
                    begin
                        RdData <= #1 {{`WORD_DATA_W - `GPIO_IN_CH{1'b0}}, GPIOIn};
                    end
`endif
`ifdef GPIO_OUT_CH
                    `GPIO_ADDR_OUT_DATA:
                    begin
                        RdData <= #1 {{`WORD_DATA_W - `GPIO_OUT_CH{1'b0}}, GPIOOut};
                    end
`endif
                endcase
            end
            else
            begin
                RdData <= #1 `WORD_DATA_W'h0;
            end

            if((CS_ == `ENABLE_) && (As_ == `ENABLE_) && (RW == `WRITE))
            begin
                case(Addr)
`ifdef GPIO_OUT_CH
                    `GPIO_ADDR_OUT_DATA:
                    begin
                        GPIOOut <= #1 WrData[`GPIO_OUT_BUS];
                    end
`endif
                endcase
            end 
        end
    end

endmodule
