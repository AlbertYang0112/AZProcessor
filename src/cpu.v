`include "inc/nettype.vh"
`include "inc/global_config.vh"
`include "inc/stddef.vh"
`include "inc/cpu.vh"
`include "inc/isa.vh"

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
)

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
        input wire                      clk = clk,
        input wire                      reset_ = reset_,

        input wire                      Stall = IFStall,
        input wire                      Flush = IFFlush,
        input wire [`WORD_ADDR_BUS]     NewPC = NewPC,
        input wire                      BrTaken = BrTaken,
        input wire [`WORD_ADDR_BUS]     BrAddr = BrAddr,

        output wire [`WORD_ADDR_BUS]    IFPC = IFPC,
        output wire [`WORD_DATA_BUS]    IFInsn = IFInsn,
        output wire                     IFEn = IFEn,

        output wire                     Busy = IFBusy,

        input wire [`WORD_DATA_BUS]     SPMRdData = IFSPMRdData,
        output wire [`WORD_ADDR_BUS]    SPMAddr = IFSPMAddr,
        output wire                     SPMAs_ = IFSPMAs_,
        output wire                     SPMRW = IFSPMRW,
        output wire [`WORD_DATA_BUS]    SPMWrData = IFSPMWrData,

        input wire [`WORD_DATA_BUS]     BusRdData = M0BusAddr,
        input wire                      BusRdy_ = M0BusRdy_,
        input wire                      BusGrnt_ = M0BusGrnt_,
        output wire                     BusReq_ = M0BusReq_,
        output wire [`WORD_ADDR_BUS]    BusAddr = M0BusAddr,
        output wire                     BusAs_ = M0BusAs_,
        output wire                     BusRW = M0BusRW,
        output wire [`WORD_DATA_BUS]    BusWrData = M0BusWrData
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
    wire [`WORD_DATA_BUS]    IDMemWrData
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
    wire [`WORD_DATA_BUS]    EXFwdData;
    wire [`REG_ADDR_BUS]     EXDstAddr;
    wire                     EXGPRWE_;
    wire [`WORD_DATA_BUS]    MemFwdData;
    wire [`WORD_ADDR_BUS]    BrAddr;
    wire                     BrTaken;
    wire                     LDHazard;

    id_stage IDStage(
        input  wire                     clk = clk,
        input  wire                     reset_ = reset_,

        input  wire                     Stall = IDStall,
        input  wire                     Flush = IDFlush,

        output wire [`WORD_ADDR_BUS]    IDPC = IDPC,
        output wire                     IDEn = IDEn,
        output wire [`ALU_OP_BUS]       IDALUOp = IDALUOp,
        output wire [`WORD_DATA_BUS]    IDALUIn0 = IDALUIn0,
        output wire [`WORD_DATA_BUS]    IDALUIn1 = IDALUIn1,
        output wire                     IDBrFlag = IDBrFlag,
        output wire [`MEM_OP_BUS]       IDMemOp = IDMemOp,
        output wire [`WORD_DATA_BUS]    IDMemWrData = IDMemWrData,
        output wire [`CTRL_OP_BUS]      IDCtrlOp = IDCtrlOp,
        output wire [`REG_ADDR_BUS]     IDDstAddr = IDDstAddr,
        output wire                     IDGPRWE_ = IDGPRWE_,
        output wire [`ISA_EXP_BUS]      IDExpCode = IDExpCode,

        input  wire                     IFEn = IFEn,
        input  wire [`WORD_ADDR_BUS]    IFPC = IFPC,
        input  wire [`WORD_DATA_BUS]    IFInsn = IFInsn,

        input  wire [`WORD_DATA_BUS]    GPRRdData0 = GPRRdData0,
        input  wire [`WORD_DATA_BUS]    GPRRdData1 = GPRRdData1,
        output wire [`WORD_ADDR_BUS]    GPRRdAddr0 = GPRRdAddr0,
        output wire [`WORD_ADDR_BUS]    GPRRdAddr1 = GPRRdAddr1,

        input  wire [`CPU_EXE_MODE_BUS] ExeMode = ExeMode,
        input  wire [`WORD_DATA_BUS]    CRegRdData = CRegRdData,
        output wire [`REG_ADDR_BUS]     CRegRdAddr = CRegRdAddr,

        input  wire [`WORD_DATA_BUS]    EXFwdData = EXFwdData,
        input  wire [`REG_ADDR_BUS]     EXDstAddr = EXDstAddr,
        input  wire                     EXGPRWE_ = EXGPRWE_,
        input  wire [`WORD_DATA_BUS]    MemFwdData = MemFwdData,

        output wire [`WORD_ADDR_BUS]    BrAddr = BrAddr,
        output wire                     BrTaken = BrTaken,
        output wire                     LDHazard = LDHazard
    );

    wire                     IntDetect,

    wire                     EXStall,
    wire                     EXFlush,

    wire [`WORD_ADDR_BUS]    EXPC,
    wire                     EXEn,
    wire                     EXBrFlag,
    wire [`MEM_OP_BUS]       EXMemOp,
    wire [`WORD_DATA_BUS]    EXMemWrData,
    wire [`CTRL_OP_BUS]      EXCtrlOp,
    wire                     EXGPRWE_,
    wire [`ISA_EXP_BUS]      EXExpCode,
    wire [`WORD_DATA_BUS]    EXOut,
    wire [`WORD_DATA_BUS]    EXFwdData,
    ex_stage EXStage(
        input  wire                     clk = clk,
        input  wire                     reset_ = reset_,

        input  wire                     IntDetect = IntDetect,

        input  wire                     Stall = EXStall,
        input  wire                     Flush = EXFlush,

        output wire [`WORD_ADDR_BUS]    EXPC = EXPC,
        output wire                     EXEn = EXEn,
        output wire                     EXBrFlag = EXBrFlag,
        output wire [`MEM_OP_BUS]       EXMemOp = EXMemOp,
        output wire [`WORD_DATA_BUS]    EXMemWrData = EXMemWrData,
        output wire [`CTRL_OP_BUS]      EXCtrlOp = EXCtrlOp,
        output wire                     EXGPRWE_ = EXGPRWE_,
        output wire [`ISA_EXP_BUS]      EXExpCode = EXExpCode,
        output wire [`WORD_DATA_BUS]    EXOut = EXOut,
        output wire [`WORD_DATA_BUS]    EXFwdData = EXFwdData,
        input  wire [`WORD_ADDR_BUS]    IDPC = IDPC,
        input  wire                     IDEn = IDEn,
        input  wire [`ALU_OP_BUS]       IDALUOp = IDALUOp,
        input  wire [`WORD_DATA_BUS]    IDALUIn0 = IDALUIn0,
        input  wire [`WORD_DATA_BUS]    IDALUIn1 = IDALUIn1,
        input  wire                     IDBrFlag = IDBrFlag,
        input  wire [`MEM_OP_BUS]       IDMemOp = IDMemOp,
        input  wire [`WORD_DATA_BUS]    IDMemWrData = IDMemWrData,
        input  wire [`CTRL_OP_BUS]      IDCtrlOp = IDCtrlOp,
        input  wire [`WORD_ADDR_BUS]    IDDstAddr = IDDstAddr,
        input  wire                     IDGPRWE_ = IDGPRWE_,
        input  wire [`ISA_EXP_BUS]      IDExpCode = IDExpCode
    );

    wire                     MemStall;
    wire                     MemFlush;

    wire [`WORD_DATA_BUS]    MemFwdData;
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
        input  wire                     clk,
        input  wire                     reset_,

        input  wire                     Stall = MemStall,
        input  wire                     Flush = MemFlush,

        output wire [`WORD_DATA_BUS]    MemFwdData = MemFwdData,
        output wire [`WORD_ADDR_BUS]    MemPC = MemPC,
        output wire                     MemEn = MemEn,
        output wire                     MemBrFlag = MemBrFlag,
        output wire [`CTRL_OP_BUS]      MemCtrlOp = MemCtrlOp,
        output wire [`REG_ADDR_BUS]     MemDstAddr = MemDstAddr,
        output wire                     MemGPRWE_ = MemGPRWE_,
        output wire [`ISA_EXP_BUS]      MemExpCode = MemExpCode,
        output wire [`WORD_DATA_BUS]    MemOut = MemOut,

        output wire                     Busy = MemBusy,

        input  wire [`WORD_DATA_BUS]    SPMRdData = MemSPMRdData,
        output wire [`WORD_ADDR_BUS]    SPMAddr = MemSPMAddr,
        output wire                     SPMAs_ = MemSPMAs_,
        output wire                     SPMRW = MemSPMRW,
        output wire [`WORD_DATA_BUS]    SPMWrData = SPMWrData,

        input  wire [`WORD_DATA_BUS]    BusRdData = M1BusRdData,
        input  wire                     BusRdy_ = M1BusRdy_,
        input  wire                     BusGrnt_ = M1BusGrnt_,
        output wire                     BusReq_ = M1BusReq_,
        output wire [`WORD_ADDR_BUS]    BusAddr = M1BusAddr,
        output wire                     BusAs_ = M1BusAs_,
        output wire                     BusRW = M1BusRW,
        output wire [`WORD_DATA_BUS]    BusWrData = M1BusWrData,

        input  wire                     EXEn = EXEn,
        input  wire [`MEM_OP_BUS]       EXMemOp = EXMemOp,
        input  wire [`WORD_DATA_BUS]    EXMemWrData = EXMemWrData,
        input  wire [`WORD_DATA_BUS]    EXOut = EXOut,
        input  wire [`WORD_ADDR_BUS]    EXPC = EXPC,
        input  wire                     EXBrFlag = EXBrFlag,
        input  wire [`CTRL_OP_BUS]      EXCtrlOp = EXCtrlOp,
        input  wire [`WORD_ADDR_BUS]    EXDstAddr = EXDstAddr,
        input  wire                     EXGPRWE_ = EXGPRWE_,
        input  wire [`ISA_EXP_BUS]      EXExpCode = EXExpCode
    );

    ctrl CtrlModule(
        input  wire clk = clk,
        input  wire reset_ = reset_,

        input  wire [`REG_ADDR_BUS]     CRegRdAddr = CRegRdAddr,
        output reg  [`WORD_DATA_BUS]    CRegRdData = CRegRdData,
        output reg  [`CPU_EXE_MODE_BUS] ExeMode = ExeMode,

        input  wire [`CPU_IRQ_BUS]      IRQ = IRQ,
        output reg                      IntDetect = IntDetect,

        input  wire [`WORD_ADDR_BUS]    IDPC = IDPC,

        input  wire [`WORD_ADDR_BUS]    MemPC = MemPC,
        input  wire                     MemEn = MemEn,
        input  wire                     MemBrFlag = MemBrFlag,
        input  wire [`CTRL_OP_BUS]      MemCtrlOp = MemCtrlOp,
        input  wire [`REG_ADDR_BUS]     MemDstAddr = MemDstAddr,
        input  wire                     MemGPRWE_ = MemGPRWE_,
        input  wire [`ISA_EXP_BUS]      MemExpCode = MemExpCode,
        input  wire [`WORD_DATA_BUS]    MemOut = MemOut,

        input  wire                     IFBusy = IFBusy,
        input  wire                     LDHazard = LDHazard,
        input  wire                     MemBusy = MemBusy,

        output wire                     IFStall = IFStall,
        output wire                     IDStall = IDStall,
        output wire                     EXStall = EXStall,
        output wire                     MemStall = MemStall,

        output wire                     IFFlush  = IFFlush,
        output wire                     IDFlush = IDFlush,
        output wire                     EXFlush = EXFlush,
        output wire                     MemFlush = MemFlush,
        output reg  [`WORD_ADDR_BUS]    NewPC = NewPC,
    );

    spm SPM(
        input wire                      clk = clk,
        input wire [`SPM_ADDR_BUS]      IFSPMAddr = IFSPMAddr,
        input wire                      IFSPMAs_ = IFSPMAs_,
        input wire                      IFSPMRW = IFSPMRW,
        input wire [`WORD_DATA_BUS]     IFSPMWrData = IFSPMWrData,
        output wire [`WORD_DATA_BUS]    IFSPMRdData = IFSPMRdData,
        input wire [`SPM_ADDR_BUS]      MemSPMAddr = MemSPMAddr,
        input wire                      MemSPMAs_ = MemSPMAs_,
        input wire                      MemSPMRW = MemSPMRW,
        input wire [`WORD_DATA_BUS]     MemSPMWrData = MemSPMWrData,
        output wire [`WORD_DATA_BUS]    MemSPMRdData = MemSPMRdData,
    );

    gpr GPR(
        input  wire                     clk = clk,
        input  wire                     reset_ = reset_,
        input  wire [`REG_ADDR_BUS]     RdAddr0 = GPRRdAddr0,
        output wire [`WORD_DATA_BUS]    RdData0 = GPRRdData0,
        input  wire [`REG_ADDR_BUS]     RdAddr1 = GPRRdAddr1,
        output wire [`WORD_DATA_BUS]    RdData1 = GPRRdData1,
        input  wire                     WE_ = MemGPRWE_,
        input  wire [`REG_ADDR_BUS]     WrAddr = MemDstAddr,
        input  wire [`WORD_DATA_BUS]    WrData = MemOut
    );

endmodule
