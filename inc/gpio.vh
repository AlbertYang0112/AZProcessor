`ifndef __GPIO_VH
`define __GPIO_VH

`define GPIO_IN_CH          3
`define GPIO_IN_BUS         2:0
`define GPIO_OUT_CH         4
`define GPIO_OUT_BUS        3:0
`define GPIO_IO_CH          4
`define GPIO_IO_BUS         3:0
`define GPIO_ADDR_BUS       1:0
`define GPIO_ADDR_W         2
`define GPIO_ADDR_LOC       1:0
`define GPIO_ADDR_IN_DATA   2'h0
`define GPIO_ADDR_OUT_DATA  2'h1
`define GPIO_ADDR_IO_DATA   2'h2
`define GPIO_ADDR_IO_DIR    2'h3
`define GPIO_DIR_IN         1'b0
`define GPIO_DIR_OUT        1'b1

`endif