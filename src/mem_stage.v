`include "nettype.vh"
`include "stddef.vh"
`include "global_config.vh"
`include "cpu.vh"

module mem_stage(
    input  wire                     clk,
    input  wire                     reset_,

    input  wire                     Stall,
    input  wire                     Flush,

    output wire [`WORD_DATA_BUS]    MemFwdData,
    output wire [`WORD_ADDR_BUS]    MemPC,
    output wire                     MemEn,
    output wire                     MemBrFlag,
    output wire [`CTRL_OP_BUS]      MemCtrlOp,
    output wire [`REG_ADDR_BUS]     MemDstAddr,
    output wire                     MemGPRWE_,
    output wire [`ISA_EXP_BUS]      MemExpCode,
    output wire [`WORD_DATA_BUS]    MemOut,

    output wire                     Busy,

    input  wire [`WORD_DATA_BUS]    SPMRdData,
    output wire [`WORD_ADDR_BUS]    SPMAddr,
    output wire                     SPMAs_,
    output wire                     SPMRW,
    output wire [`WORD_DATA_BUS]    SPMWrData,

    input  wire [`WORD_DATA_BUS]    BusRdData,
    input  wire                     BusRdy_,
    input  wire                     BusGrnt_,
    output wire                     BusReq_,
    output wire [`WORD_ADDR_BUS]    BusAddr,
    output wire                     BusAs_,
    output wire                     BusRW,
    output wire [`WORD_DATA_BUS]    BusWrData,

    input  wire                     EXEn,
    input  wire [`MEM_OP_BUS]       EXMemOp,
    input  wire [`WORD_DATA_BUS]    EXMemWrData,
    input  wire [`WORD_DATA_BUS]    EXOut,
    input  wire [`WORD_ADDR_BUS]    EXPC,
    input  wire                     EXBrFlag,
    input  wire [`CTRL_OP_BUS]      EXCtrlOp,
    input  wire [`WORD_ADDR_BUS]    EXDstAddr,
    input  wire                     EXGPRWE_,
    input  wire [`ISA_EXP_BUS]      EXExpCode
);

    wire [`WORD_ADDR_BUS] Addr;
    wire As_;
    wire RW;
    wire WrData;
    wire RdData;
    wire MissAlign;

    bus_if BusIf(
        .clk(c),
        .reset_(reset_),

        .Stall(Stall),
        .Flush(Flush),
        .Busy(Busy),

        .Addr(Addr),
        .As_(As_),
        .RW(RW),
        .WrData(WrData),
        .RdData(RdData),

        .SPMRdData(SPMRdData),
        .SPMAddr(SPMAddr),
        .SPMAs_(SPMAs_),
        .SPMRW(SPMRW),
        .SPMWrData(SPMWrData),

        .BusRdData(BusRdData),
        .BusRdy_(BusRdy_),
        .BusGrnt_(BusGrnt_),
        .BusReq_(BusReq_),
        .BusAddr(BusAddr),
        .BusAs_(BusAs_),
        .BusRW(BusRW),
        .BusWrData(BusWrData)
    );

    mem_ctrl MemCtrl(
        .EXEn(EXEn),
        .EXMemOp(EXMemOp),
        .EXMemWrData(EXMemWrData),
        .EXOut(EXOut),

        .RdData(RdData),
        .Addr(Addr),
        .As_(As_),
        .RW(RW),
        .WrData(WrData),
        .Out(MemFwdData),
        .MissAlign(MissAlign)
    );

    mem_reg MemReg(
        .clk(clk),
        .reset_(reset_),

        .Out(MemFwdData),
        .MissAlign(MissAlign),

        .Stall(Stall),
        .Flush(Flush),

        .EXPC(EXPC),
        .EXEn(EXEn),
        .EXBrFlag(EXBrFlag),
        .EXCtrlOp(EXCtrlOp),
        .EXDstAddr(EXDstAddr),
        .EXGPRWE_(EXGPRWE_),
        .EXExpCode(EXExpCode),

        .MemPC(MemPC),
        .MemEn(MemEn),
        .MemBrFlag(MemBrFlag),
        .MemCtrlOp(MemCtrlOp),
        .MemDstAddr(MemDstAddr),
        .MemGPRWE_(MemGPRWE_),
        .MemExpCode(MemExpCode),
        .MemOut(MemOut)
    );

endmodule
