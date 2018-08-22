`include "inc/nettype.vh"
`include "inc/global_config.vh"
`include "inc/stddef.vh"
`include "cpu.vh"

module if_stage(
    input wire clk,
    input wire reset_,

    input wire Stall,
    input wire Flush,
    input wire [`WORD_ADDR_BUS] NewPC,
    input wire BrTaken,
    input wire [`WORD_ADDR_BUS] BrAddr,

    output wire [`WORD_ADDR_BUS] IFPC,
    output wire [`WORD_DATA_BUS] IFInsn,
    output wire IFEn,

    output wire Busy,

    input wire [`WORD_DATA_BUS] SPMRdData,
    output wire [`WORD_ADDR_BUS] SPMAddr,
    output wire SPMAs_,
    output wire SPMRW,
    output wire [`WORD_DATA_BUS] SPMWrData,

    input wire [`WORD_DATA_BUS] BusRdData,
    input wire BusRdy_,
    input wire BusGrnt_,
    output wire BusReq_,
    output wire [`WORD_ADDR_BUS] BusAddr,
    output wire BusAs_,
    output wire BusRW,
    output wire [`WORD_DATA_BUS] BusWrData
)

    wire [`WORD_DATA_BUS] Insn;

    bus_if BusIF(
        .clk = clk,
        .reset_ = reset_,

        .Stall = Stall,
        .Flush = Flush,
        .Busy = Busy

        .Addr = IFPC,
        .As_ = `ENABLE_,
        .RW = `READ,
        .WrData = `WORD_DATA_W'h0;
        .RdData = Insn,

        .SPMRdData = SPMPdData,
        .SPMAddr = SPMAddr,
        .SPMAs_ = SPMAs_,
        .SPMRW = SPMRW,
        .SPMWrData = SPMWrData,
        
        .BusRdData = BusRdData,
        .BusRdy_ = BusRdy_,
        .BusGrnt_ = BusGrnt_,
        .BusReq_ = BusReq_,
        .BusAddr = BusAddr,
        .BusAs_ = BusAs_,
        .BusRW = BusRW,
        .BusWrData = BusWrData
    );

    if_reg IFReg(
        .clk = clk,
        .reset = reset_,

        .Insn = Insn,

        .Stall = Stall,
        .Flush = Flush,
        .NewPC = NewPC,
        .BrTaken = BrTaken,
        .BrAddr = BrAddr,

        .IFPC = IFPC,
        .IFInsn = IFInsn,
        .IFEn = IFEn
    );

endmodule