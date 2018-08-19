`include "inc/nettype.vh"
`include "inc/bus.vh"
`include "inc/stddef.vh"

module bus_arbiter(
    input wire clk,
    input wire reset_,
    input wire m0Req_,
    output reg m0Grnt_,
    input wire m1Req_,
    output reg m1Grnt_,
    input wire m2Req_,
    output reg m2Grnt_,
    input wire m3Req_,
    output reg m3Grnt_
)
    reg [`BUS_OWNER_BUS]owner = `BUS_OWNER_MASTER_0;
    always @(*)
    begin
        m0Grnt_ = `DISABLE;
        m1Grnt_ = `DISABLE;
        m2Grnt_ = `DISABLE;
        m3Grnt_ = `DISABLE;

        case(owner)
            `BUS_OWNER_MASTER_0 :
            begin
                m0Grnt_ = `ENABLE;
            end
            `BUS_OWNER_MASTER_1 :
            begin
                m1Grnt_ = `ENABLE;
            end
            `BUS_OWNER_MASTER_2 :
            begin
                m2Grnt_ = `ENABLE;
            end
            `BUS_OWNER_MASTER_3 :
            begin
                m3Grnt_ = `ENABLE;
            end
        endcase
    end

    always @(posedge clk or `RESET_EDGE reset_)
    begin
        if(reset_ == `RESET_ENABLE)
        begin
            owner <= `BUS_OWNER_MASTER_0;
        end 
        else
        begin
            case(owner)
                `BUS_OWNER_MASTER_0:
                begin
                    if(m0Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_0;
                    else if(m1Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_1;
                    else if(m2Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_2;
                    else if(m3Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_3;
                end
                `BUS_OWNER_MASTER_1:
                begin
                    if(m1Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_1;
                    else if(m2Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_2;
                    else if(m3Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_3;
                    else if(m0Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_0;
                end
                `BUS_OWNER_MASTER_2:
                begin
                    if(m2Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_2;
                    else if(m3Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_3;
                    else if(m0Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_0;
                    else if(m1Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_1;
                end
                `BUS_OWNER_MASTER_3:
                begin
                    if(m3Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_3;
                    else if(m0Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_0;
                    else if(m1Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_1;
                    else if(m2Req_ == `ENABLE)
                        owner <= #1 `BUS_OWNER_MASTER_2;
                end
            endcase
        end
    end
endmodule
