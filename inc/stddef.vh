`ifndef __STDDEF_VH
`define __STDDEF_VH

`define HIGH 1'b1       
`define LOW 1'b0
`define DISABLE 1'b0        // Positive logic
`define ENABLE 1'b1
`define DISABLE_ 1'b1       // Negative logic
`define ENABLE_ 1'b0
`define READ 1'b1           // Read signal
`define WRITE 1'b0          // Write signal
`define LSB 0
`define BYTE_DATA_W 8
`define BYTE_MSB 7
`define BYTE_DATA_BUS 7:0
`define WORD_DATA_W 32
`define WORD_DATA_BUS 31:0
`define WORD_ADDR_W 30
`define WORD_ADDR_MSB 29
`define WORD_ADDR_BUS 29:0
`define BYTE_OFFSET_W 2
`define BYTE_OFFSET_BUS 1:0
`define WORD_ADDR_LOC 31:2
`define BYTE_OFFSET_LOC 1:0
`define BYTE_OFFSET_WORD 2'b00

`endif