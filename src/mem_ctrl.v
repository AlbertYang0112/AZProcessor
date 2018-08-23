`include "inc/nettype.vh"
`include "inc/stddef.vh"
`include "inc/global_config.vh"
`include "inc/cpu.vh"
`include "inc/isa.vh"

module mem_ctrl(
    input  wire                     EXEn,
    input  wire [`MEM_OP_BUS]       EXMemOp,
    input  wire [`WORD_DATA_BUS]    EXMemWrData,
    input  wire [`WORD_DATA_BUS]    EXOut,

    input  wire [`WORD_DATA_BUS]    RdData,
    output reg  [`WORD_ADDR_BUS]    Addr,
    output reg                      As_,
    output reg                      RW,
    output wire [`WORD_DATA_BUS]    WrData,
    output reg  [`WORD_DATA_BUS]    Out,
    output reg                      MissAlign,
)

    wire [`BYTE_OFFSET_BUS] Offset;
    assign WrData = EXMemWrData;
    assign Addr = EXOut[`WORD_ADDR_LOC];
    assign Offset = EXOut[`BYTE_OFFSET_LOC];

    always@(*)
    begin
        MissAlign = `DISABLE;
        Out = `WORD_DATA_BUS'h0;
        As_ = `DISABLE_;
        RW = `READ;

        if(EXEn == `ENABLE)
        begin
            case (EXMemOp)
                `MEM_OP_LDW:
                begin
                    if(Offset == `BYTE_OFFSET_WORD)
                    begin
                        Out = RdData;
                        As_ = `ENABLE_;
                    end
                    else
                    begin
                        MissAlign = `ENABLE;
                    end
                end
                `MEM_OP_STW:
                begin
                    if(Offset == `BYTE_OFFSET_WORD)
                    begin
                        RW = `WRITE;
                        As_ = `ENABLE_;
                    end
                    else
                    begin
                        MissAlign = `ENABLE;
                    end
                end
                default:
                begin
                    Out = EXOut;
                end
            endcase
        end
    end

endmodule