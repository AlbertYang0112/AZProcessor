`include "nettype.vh"
`include "bus.vh"
`include "stddef.vh"

module bus_addr_dec(
    (* KEEP = "{TRUE|FALSE |SOFT}" *)input  wire [`WORD_ADDR_BUS]    sAddr,
    output reg                      s0CS_,
    output reg                      s1CS_,
    output reg                      s2CS_,
    output reg                      s3CS_,
    output reg                      s4CS_,
    output reg                      s5CS_,
    output reg                      s6CS_,
    output reg                      s7CS_
);

    wire [`BUS_SLAVE_INDEX_BUS] s_index = sAddr[`BUS_SLAVE_INDEX_LOC];
    
    always @(*)
    begin
        s0CS_ = `DISABLE_;
        s1CS_ = `DISABLE_;
        s2CS_ = `DISABLE_;
        s3CS_ = `DISABLE_;
        s4CS_ = `DISABLE_;
        s5CS_ = `DISABLE_;
        s6CS_ = `DISABLE_;
        s7CS_ = `DISABLE_;
    
        case (s_index)
            `BUS_SLAVE_0 :
            begin
                s0CS_ = `ENABLE;
            end
            `BUS_SLAVE_1 :
            begin
                s1CS_ = `ENABLE;
            end
            `BUS_SLAVE_2 :
            begin
                s2CS_ = `ENABLE;
            end
            `BUS_SLAVE_3 :
            begin
                s3CS_ = `ENABLE;
            end
            `BUS_SLAVE_4 :
            begin
                s4CS_ = `ENABLE;
            end
            `BUS_SLAVE_5 :
            begin
                s5CS_ = `ENABLE;
            end
            `BUS_SLAVE_6 :
            begin
                s6CS_ = `ENABLE;
            end
            `BUS_SLAVE_7 :
            begin
                s7CS_ = `ENABLE;
            end
        endcase
    end

endmodule