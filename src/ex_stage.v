`include "inc/nettype.vh"
`include "inc/golbal_config.vh"
`include "inc/isa.vh"
`include "inc/cpu.vh"

module ex_stage(
    input  wire clk,
    input  wire reset_,

    input  wire IntDetect,

    input  wire Stall,
    input  wire Flush,

    output wire [`WORD_ADDR_BUS] EXPC,
    output wire EXEn,
    output wire EXBrFlag,
    output wire [`MEM_OP_BUS] EXMemOp,
    output wire [`WORD_DATA_BUS] EXMemWrData,
    output wire [`CTRL_OP_BUS] EXCtrlOp,
    output wire EXGPRWE_,
    output wire [`ISA_EXP_BUS] EXExpCode,
    output wire [`WORD_DATA_BUS] EXOut,
    output wire [`WORD_DATA_BUS] EXFwdData,
    input  wire [`WORD_ADDR_BUS] IDPC,
    input  wire IDEn,
    input  wire [`ALU_OP_BUS] IDALUOp,
    input  wire [`WORD_DATA_BUS] IDALUIn0,
    input  wire [`WORD_DATA_BUS] IDALUIn1,
    input  wire IDBrFlag,
    input  wire [`MEM_OP_BUS] IDMemOp,
    input  wire [`WORD_DATA_BUS] IDMemWrData,
    input  wire [`CTRL_OP_BUS] IDCtrlOp,
    input  wire [`WORD_ADDR_BUS] IDDstAddr,
    input  wire IDGPRWE_,
    input  wire [`ISA_EXP_BUS] IDExpCode,
)

    wire [`WORD_DATA_BUS] ALUOut;
    wire ALUOF;
    alu ALU(
        .In0 = IDALUIn0,
        .In1 = IDALUIn1,
        .Op  = IDALUOp,

        .Out = ALUOut,
        .OF  = ALUOF
    );

    ex_reg EXReg(
        .clk            = clk,
        .reset_         = reset_,
    
        .ALUOut         = ALUOut,
        .ALUOF          = ALUOF,
    
        .Stall          = Stall,
        .Flush          = Flush,
        .IntDetect      = IntDetect,
    
        .IDPC           = IDPC,
        .IDEn           = IDEn,
        .IDBrFlag       = IDBrFlag,
        .IDMemOp        = IDMemOp,
        .IDMemWrData    = IDMemWrData,
        .IDCtrlOp       = IDCtrlOp,
        .IDDstAddr      = IDDstAddr,
        .IDGPRWE_       = IDGPRWE_,
        .IDExpCode      = IDExpCode,
    
        .EXPC           = EXPC,
        .EXEn           = EXEn,
        .EXBrFlag       = EXBrFlag,
        .EXMemOp        = EXMemOp,
        .EXMemWrData    = EXMemWrData,
        .EXCtrlOp       = EXCtrlOp,
        .EXDstAddr      = EXDstAddr,
        .EXGPRWE_       = EXGPRWE_,
        .EXExpCode      = EXExpCode,
        .EXOut          = EXOut
    );

endmodule