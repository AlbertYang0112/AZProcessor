`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "isa.vh"
`include "cpu.vh"

module alu(
    input wire [`WORD_DATA_BUS] In0,
    input wire [`WORD_DATA_BUS] In1,
    input wire [`ALU_OP_BUS]    Op,

    output reg [`WORD_DATA_BUS] Out,
    output reg                  OF
);

    wire signed [`WORD_DATA_BUS] SIn0 = $signed(In0);
    wire signed [`WORD_DATA_BUS] SIn1 = $signed(In1);
    wire signed [`WORD_DATA_BUS] SOut = $signed(Out);
    
    always@(*)
    begin
        case (Op)
            `ALU_OP_AND :
            begin
                Out = In0 & In1;
            end
            `ALU_OP_OR :
            begin
                Out = In0 | In1;
            end
            `ALU_OP_XOR :
            begin
                Out = In0 ^ In1;
            end
            `ALU_OP_ADDS :
            begin
                Out = In0 + In1;
            end
            `ALU_OP_ADDU :
            begin
                Out = In0 + In1;
            end
            `ALU_OP_SUBS :
            begin
                Out = In0 - In1;
            end
            `ALU_OP_SUBU :
            begin
                Out = In0 - In1;
            end
            `ALU_OP_SHRL :
            begin
                Out = In0 >> In1;
            end
            `ALU_OP_SHLL :
            begin
                Out = In0 << In1;
            end
            default:
            begin
                Out = In0;
            end
        endcase
    end

    always@(*)
    begin
        case(Op)
            `ALU_OP_ADDS:
            begin
                if(((SIn0 > 0) && (SIn1 > 0) && (SOut < 0)) || 
                    ((SIn0 < 0) && (SIn1 < 0) && (SOut > 0)))
                begin
                    OF = `ENABLE;
                end
                else
                begin
                    OF = `DISABLE;
                end
            end
            `ALU_OP_SUBS:
            begin
                if(((SIn0 < 0) && (SIn1 > 0) && (SOut > 0)) || 
                    ((SIn0 > 0) && (SIn1 < 0) && (SOut < 0)))
                begin
                    OF = `ENABLE;
                end
                else
                begin
                    OF = `DISABLE;
                end
            end
        endcase
    end

endmodule