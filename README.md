# AZ Processor

This is an implementation of the AZ processor.

Please refer to the book for futher details.

## Basic Information

- Architecture: RISC
- Bus Width: 32bits
- Max Core Frequency: Untested
- Pipeline: 5-state pipeline *IF->ID->EX->MEM->WB*
- Peripheral Device:
  - GPIO Module
  
## Environment

- Evaluation Board: ZC702 Evaluation Board
- FPGA Zynq-7 XC7Z020CLG484-l
- Vivado 2018.1

## IP Core Dependency

IP cores are out-of-content, **not** included in the repo. Please add the IP core manually.

- Dual Port Block RAM: blk_mem_spm
- Single Port Block ROM: blk_mem_rom
- Clock Generator: clk_manager
