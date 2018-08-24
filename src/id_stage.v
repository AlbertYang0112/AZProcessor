`include "nettype.vh"
`include "global_config.vh"
`include "cpu.vh"
`include "isa.vh"

module id_stage(
    input  wire                     clk,
    input  wire                     reset_,

    input  wire                     Stall,
    input  wire                     Flush,

    output wire [`WORD_ADDR_BUS]    IDPC,
    output wire                     IDEn,
    output wire [`ALU_OP_BUS]       IDALUOp,
    output wire [`WORD_DATA_BUS]    IDALUIn0,
    output wire [`WORD_DATA_BUS]    IDALUIn1,
    output wire                     IDBrFlag,
    output wire [`MEM_OP_BUS]       IDMemOp,
    output wire [`WORD_DATA_BUS]    IDMemWrData,
    output wire [`CTRL_OP_BUS]      IDCtrlOp,
    output wire [`REG_ADDR_BUS]     IDDstAddr,
    output wire                     IDGPRWE_,
    output wire [`ISA_EXP_BUS]      IDExpCode,

    input  wire                     IFEn,
    input  wire [`WORD_ADDR_BUS]    IFPC,
    input  wire [`WORD_DATA_BUS]    IFInsn,
    
    input  wire [`WORD_DATA_BUS]    GPRRdData0,
    input  wire [`WORD_DATA_BUS]    GPRRdData1,
    output wire [`REG_ADDR_BUS]     GPRRdAddr0,
    output wire [`REG_ADDR_BUS]     GPRRdAddr1,

    input  wire [`CPU_EXE_MODE_BUS] ExeMode,
    input  wire [`WORD_DATA_BUS]    CRegRdData,
    output wire [`REG_ADDR_BUS]     CRegRdAddr,
    
    input  wire                     EXEn,
    input  wire [`WORD_DATA_BUS]    EXFwdData,
    input  wire [`REG_ADDR_BUS]     EXDstAddr,
    input  wire                     EXGPRWE_,
    input  wire [`WORD_DATA_BUS]    MemFwdData,

    output wire [`WORD_ADDR_BUS]    BrAddr,
    output wire                     BrTaken,
    output wire                     LDHazard
);
    wire [`ALU_OP_BUS] ALUOp;
    wire [`WORD_DATA_BUS] ALUIn0;
    wire [`WORD_DATA_BUS] ALUIn1;
    wire BrFlag;
    wire [`MEM_OP_BUS] MemOp;
    wire [`WORD_DATA_BUS] MemWrData;
    wire [`CTRL_OP_BUS] CtrlOp;
    wire [`REG_ADDR_BUS] DstAddr;
    wire GPRWE_;
    wire [`ISA_EXP_BUS] ExpCode;
    

    id_decoder IDDecoder(
        .IFPC          (IFPC),
        .IFInsn        (IFInsn),
        .IFEn          (IFEn),

        .GPRRdData0    (GPRRdData0),
        .GPRRdAddr0    (GPRRdAddr0),
        .GPRRdData1    (GPRRdData1),
        .GPRRdAddr1    (GPRRdAddr1),

        .IDEn          (IDEn),
        .IDDstAddr     (IDDstAddr),
        .IDGPRWE_      (IDGPRWE_),
        .IDMemOp       (IDMemOp),

        .EXEn          (EXEn),
        .EXDstAddr     (EXDstAddr),
        .EXGPRWE_      (EXGPRWE_),
        .EXFwdData     (EXFwdData),

        .MemFwdData    (MemFwdData),

        .ExeMode       (ExeMode),
        .CRegRdData    (CRegRdData),
        .CRegRdAddr    (CRegRdAddr),

        .ALUOp         (ALUOp),
        .ALUIn0        (ALUIn0),
        .ALUIn1        (ALUIn1),
        .BrAddr        (BrAddr),
        .BrTaken       (BrTaken),
        .BrFlag        (BrFlag),
        .MemOp         (MemOp),
        .MemWrData     (MemWrData),
        .CtrlOp        (CtrlOp),
        .DstAddr       (DstAddr),
        .GPRWE_        (GPRWE_),
        .ExpCode       (ExpCode),
        .LDHazard      (LDHazard)
    );

    id_reg IDReg(
        .clk           (clk),
        .reset_        (reset_),

        .ALUOp         (ALUOp),
        .ALUIn0        (ALUIn0),
        .ALUIn1        (ALUIn1),
        .BrFlag        (BrFlag),
        .MemOp         (MemOp),
        .MemWrData     (MemWrData),
        .CtrlOp        (CtrlOp),
        .DstAddr       (DstAddr),
        .GPRWE_        (GPRWE_),
        .ExpCode       (ExpCode),

        .Stall         (Stall),
        .Flush         (Flush),

        .IFPC          (IFPC),
        .IFEn          (IFEn),

        .IDPC          (IDPC),
        .IDEn          (IDEn),
        .IDALUOp       (IDALUOp),
        .IDALUIn0      (IDALUIn0),
        .IDALUIn1      (IDALUIn1),
        .IDBrFlag      (IDBrFlag),
        .IDMemOp       (IDMemOp),
        .IDMemWrData   (IDMemWrData),
        .IDCtrlOp      (IDCtrlOp),
        .IDDstAddr     (IDDstAddr),
        .IDGPRWE_      (IDGPRWE_),
        .IDExpCode     (IDExpCode)
    );

endmodule