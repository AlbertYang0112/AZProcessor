`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "gpio.vh"

module gpio(
    input wire clk,
    input wire reset_,
    
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire CS_,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire As_,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire RW,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire [`WORD_ADDR_BUS] Addr,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire [`WORD_DATA_BUS] WrData,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)output reg [`WORD_DATA_BUS] RdData,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)output reg Rdy_,

    (* KEEP = "{TRUE|FALSE |SOFT}" *)input wire [`GPIO_IN_BUS] GPIOIn,
    (* KEEP = "{TRUE|FALSE |SOFT}" *)output reg [`GPIO_OUT_BUS] GPIOOut
    // inout wire [`GPIO_IO_BUS] GPIOIO
);

    wire [`GPIO_ADDR_BUS] GPIORegAddr = Addr[`GPIO_ADDR_LOC];
    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            RdData  <= #1 `WORD_DATA_W'h0;
            Rdy_    <= #1 `DISABLE_;
//`ifdef GPIO_OUT_CH
            GPIOOut <= #1 {`GPIO_OUT_CH{`HIGH}};
//`endif
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
                case(GPIORegAddr)
//`ifdef GPIO_IN_CH
                    `GPIO_ADDR_IN_DATA:
                    begin
                        RdData <= #1 {{`WORD_DATA_W - `GPIO_IN_CH{1'b0}}, GPIOIn};
                    end
//`endif
//`ifdef GPIO_OUT_CH
                    `GPIO_ADDR_OUT_DATA:
                    begin
                        RdData <= #1 {{`WORD_DATA_W - `GPIO_OUT_CH{1'b0}}, GPIOOut};
                    end
//`endif
                endcase
            end
            else
            begin
                RdData <= #1 `WORD_DATA_W'h0;
            end

            if((CS_ == `ENABLE_) && (As_ == `ENABLE_) && (RW == `WRITE))
            begin
                case(GPIORegAddr)
//`ifdef GPIO_OUT_CH
                    `GPIO_ADDR_OUT_DATA:
                    begin
                        GPIOOut <= #1 WrData[`GPIO_OUT_BUS];
                    end
//`endif
                endcase
            end 
        end
    end

endmodule
