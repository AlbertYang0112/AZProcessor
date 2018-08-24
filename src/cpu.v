`include "nettype.vh"
`include "global_config.vh"
`include "stddef.vh"
`include "cpu.vh"
`include "isa.vh"

module cpu(
    input  wire                     clk,
    input  wire                     reset_,
    input  wire [`WORD_DATA_BUS]    M0BusRdData,
    input  wire                     M0BusRdy_,
    input  wire                     M0BusGrnt_,
    output wire                     M0BusReq_,
    output wire [`WORD_ADDR_BUS]    M0BusAddr,
    output wire                     M0BusAs_,
    output wire                     M0BusRW,
    output wire [`WORD_DATA_BUS]    M0BusWrData,
    input  wire [`WORD_DATA_BUS]    M1BusRdData,
    input  wire                     M1BusRdy_,
    input  wire                     M1BusGrnt_,
    output wire                     M1BusReq_,
    output wire [`WORD_ADDR_BUS]    M1BusAddr,
    output wire                     M1BusAs_,
    output wire                     M1BusRW,
    output wire [`WORD_DATA_BUS]    M1BusWrData,
    input  wire [`CPU_IRQ_BUS]      IRQ
);

    wire IFStall;
    wire IFFlush;
    wire [`WORD_ADDR_BUS]   NewPC;
    wire                    BrTaken;
    wire [`WORD_ADDR_BUS]   BrAddr;

    wire [`WORD_ADDR_BUS]   IFPC;
    wire [`WORD_DATA_BUS]   IFInsn;
    wire                    IFEn;

    wire                    IFBusy;

    wire [`WORD_DATA_BUS]   IFSPMRdData;
    wire [`WORD_ADDR_BUS]   IFSPMAddr;
    wire                    IFSPMAs_;
    wire                    IFSPMRW;
    wire [`WORD_DATA_BUS]   IFSPMWrData;

    if_stage IFStage(
        .clk(clk),
        .reset_(reset_),

        .Stall(IFStall),
        .Flush(IFFlush),
        .NewPC(NewPC),
        .BrTaken(BrTaken),
        .BrAddr(BrAddr),

        .IFPC(IFPC),
        .IFInsn(IFInsn),
        .IFEn(IFEn),

        .Busy(IFBusy),

        .SPMRdData(IFSPMRdData),
        .SPMAddr(IFSPMAddr),
        .SPMAs_(IFSPMAs_),
        .SPMRW(IFSPMRW),
        .SPMWrData(IFSPMWrData),

        .BusRdData(M0BusAddr),
        .BusRdy_(M0BusRdy_),
        .BusGrnt_(M0BusGrnt_),
        .BusReq_(M0BusReq_),
        .BusAddr(M0BusAddr),
        .BusAs_(M0BusAs_),
        .BusRW(M0BusRW),
        .BusWrData(M0BusWrData)
    );

    wire                     IDStall;
    wire                     IDFlush;
    wire [`WORD_ADDR_BUS]    IDPC;
    wire                     IDEn;
    wire [`ALU_OP_BUS]       IDALUOp;
    wire [`WORD_DATA_BUS]    IDALUIn0;
    wire [`WORD_DATA_BUS]    IDALUIn1;
    wire                     IDBrFlag;
    wire [`MEM_OP_BUS]       IDMemOp;
    wire [`WORD_DATA_BUS]    IDMemWrData;
    wire [`CTRL_OP_BUS]      IDCtrlOp;
    wire [`REG_ADDR_BUS]     IDDstAddr;
    wire                     IDGPRWE_;
    wire [`ISA_EXP_BUS]      IDExpCode;
    wire [`WORD_DATA_BUS]    GPRRdData0;
    wire [`WORD_DATA_BUS]    GPRRdData1;
    wire [`WORD_ADDR_BUS]    GPRRdAddr0;
    wire [`WORD_ADDR_BUS]    GPRRdAddr1;
    wire [`CPU_EXE_MODE_BUS] ExeMode;
    wire [`WORD_DATA_BUS]    CRegRdData;
    wire [`REG_ADDR_BUS]     CRegRdAddr;
    wire                     EXEn;
    wire [`WORD_DATA_BUS]    EXFwdData;
    wire [`REG_ADDR_BUS]     EXDstAddr;
    wire                     EXGPRWE_;
    wire [`WORD_DATA_BUS]    MemFwdData;
    //wire [`WORD_ADDR_BUS]    BrAddr;
    //wire                     BrTaken;
    wire                     LDHazard;

    id_stage IDStage(
        .clk(clk),
        .reset_(reset_),

        .Stall(IDStall),
        .Flush(IDFlush),

        .IDPC(IDPC),
        .IDEn(IDEn),
        .IDALUOp(IDALUOp),
        .IDALUIn0(IDALUIn0),
        .IDALUIn1(IDALUIn1),
        .IDBrFlag(IDBrFlag),
        .IDMemOp(IDMemOp),
        .IDMemWrData(IDMemWrData),
        .IDCtrlOp(IDCtrlOp),
        .IDDstAddr(IDDstAddr),
        .IDGPRWE_(IDGPRWE_),
        .IDExpCode(IDExpCode),

        .IFEn(IFEn),
        .IFPC(IFPC),
        .IFInsn(IFInsn),

        .GPRRdData0(GPRRdData0),
        .GPRRdData1(GPRRdData1),
        .GPRRdAddr0(GPRRdAddr0),
        .GPRRdAddr1(GPRRdAddr1),

        .ExeMode(ExeMode),
        .CRegRdData(CRegRdData),
        .CRegRdAddr(CRegRdAddr),

        .EXEn(EXEn),
        .EXFwdData(EXFwdData),
        .EXDstAddr(EXDstAddr),
        .EXGPRWE_(EXGPRWE_),
        .MemFwdData(MemFwdData),

        .BrAddr(BrAddr),
        .BrTaken(BrTaken),
        .LDHazard(LDHazard)
    );

    wire                     IntDetect;

    wire                     EXStall;
    wire                     EXFlush;

    wire [`WORD_ADDR_BUS]    EXPC;
    //wire                     EXEn;
    wire                     EXBrFlag;
    wire [`MEM_OP_BUS]       EXMemOp;
    wire [`WORD_DATA_BUS]    EXMemWrData;
    wire [`CTRL_OP_BUS]      EXCtrlOp;
    //wire                     EXGPRWE_;
    wire [`ISA_EXP_BUS]      EXExpCode;
    wire [`WORD_DATA_BUS]    EXOut;
    //wire [`WORD_DATA_BUS]    EXFwdData;
    ex_stage EXStage(
        .clk(clk),
        .reset_(reset_),

        .IntDetect(IntDetect),

        .Stall(EXStall),
        .Flush(EXFlush),

        .EXPC(EXPC),
        .EXEn(EXEn),
        .EXBrFlag(EXBrFlag),
        .EXMemOp(EXMemOp),
        .EXMemWrData(EXMemWrData),
        .EXCtrlOp(EXCtrlOp),
        .EXDstAddr(EXDstAddr),
        .EXGPRWE_(EXGPRWE_),
        .EXExpCode(EXExpCode),
        .EXOut(EXOut),
        .EXFwdData(EXFwdData),
        .IDPC(IDPC),
        .IDEn(IDEn),
        .IDALUOp(IDALUOp),
        .IDALUIn0(IDALUIn0),
        .IDALUIn1(IDALUIn1),
        .IDBrFlag(IDBrFlag),
        .IDMemOp(IDMemOp),
        .IDMemWrData(IDMemWrData),
        .IDCtrlOp(IDCtrlOp),
        .IDDstAddr(IDDstAddr),
        .IDGPRWE_(IDGPRWE_),
        .IDExpCode(IDExpCode)
    );

    wire                     MemStall;
    wire                     MemFlush;

    //wire [`WORD_DATA_BUS]    MemFwdData;
    wire [`WORD_ADDR_BUS]    MemPC;
    wire                     MemEn;
    wire                     MemBrFlag;
    wire [`CTRL_OP_BUS]      MemCtrlOp;
    wire [`REG_ADDR_BUS]     MemDstAddr;
    wire                     MemGPRWE_;
    wire [`ISA_EXP_BUS]      MemExpCode;
    wire [`WORD_DATA_BUS]    MemOut;
    wire                     MemBusy;
    wire [`WORD_DATA_BUS]    MemSPMRdData;
    wire [`WORD_ADDR_BUS]    MemSPMAddr;
    wire                     MemSPMAs_;
    wire                     MemSPMRW;
    wire [`WORD_DATA_BUS]    MemSPMWrData;
    mem_stage MemStage(
        .clk(clk),
        .reset_(reset_),

        .Stall(MemStall),
        .Flush(MemFlush),

        .MemFwdData(MemFwdData),
        .MemPC(MemPC),
        .MemEn(MemEn),
        .MemBrFlag(MemBrFlag),
        .MemCtrlOp(MemCtrlOp),
        .MemDstAddr(MemDstAddr),
        .MemGPRWE_(MemGPRWE_),
        .MemExpCode(MemExpCode),
        .MemOut(MemOut),

        .Busy(MemBusy),

        .SPMRdData(MemSPMRdData),
        .SPMAddr(MemSPMAddr),
        .SPMAs_(MemSPMAs_),
        .SPMRW(MemSPMRW),
        .SPMWrData(MemSPMWrData),

        .BusRdData(M1BusRdData),
        .BusRdy_(M1BusRdy_),
        .BusGrnt_(M1BusGrnt_),
        .BusReq_(M1BusReq_),
        .BusAddr(M1BusAddr),
        .BusAs_(M1BusAs_),
        .BusRW(M1BusRW),
        .BusWrData(M1BusWrData),

        .EXEn(EXEn),
        .EXMemOp(EXMemOp),
        .EXMemWrData(EXMemWrData),
        .EXOut(EXOut),
        .EXPC(EXPC),
        .EXBrFlag(EXBrFlag),
        .EXCtrlOp(EXCtrlOp),
        .EXDstAddr(EXDstAddr),
        .EXGPRWE_(EXGPRWE_),
        .EXExpCode(EXExpCode)
    );

    ctrl CtrlModule(
        .clk(clk),
        .reset_(reset_),

        .CRegRdAddr(CRegRdAddr),
        .CRegRdData(CRegRdData),
        .ExeMode(ExeMode),

        .IRQ(IRQ),
        .IntDetect(IntDetect),

        .IDPC(IDPC),

        .MemPC(MemPC),
        .MemEn(MemEn),
        .MemBrFlag(MemBrFlag),
        .MemCtrlOp(MemCtrlOp),
        .MemDstAddr(MemDstAddr),
        .MemGPRWE_(MemGPRWE_),
        .MemExpCode(MemExpCode),
        .MemOut(MemOut),

        .IFBusy(IFBusy),
        .LDHazard(LDHazard),
        .MemBusy(MemBusy),

        .IFStall(IFStall),
        .IDStall(IDStall),
        .EXStall(EXStall),
        .MemStall(MemStall),

        .IFFlush (IFFlush),
        .IDFlush(IDFlush),
        .EXFlush(EXFlush),
        .MemFlush(MemFlush),
        .NewPC(NewPC)
    );

    spm SPM(
        .clk(clk),
        .IFSPMAddr(IFSPMAddr),
        .IFSPMAs_(IFSPMAs_),
        .IFSPMRW(IFSPMRW),
        .IFSPMWrData(IFSPMWrData),
        .IFSPMRdData(IFSPMRdData),
        .MemSPMAddr(MemSPMAddr),
        .MemSPMAs_(MemSPMAs_),
        .MemSPMRW(MemSPMRW),
        .MemSPMWrData(MemSPMWrData),
        .MemSPMRdData(MemSPMRdData)
    );

    gpr GPR(
        .clk(clk),
        .reset_(reset_),
        .RdAddr0(GPRRdAddr0),
        .RdData0(GPRRdData0),
        .RdAddr1(GPRRdAddr1),
        .RdData1(GPRRdData1),
        .WE_(MemGPRWE_),
        .WrAddr(MemDstAddr),
        .WrData(MemOut)
    );

endmodule
