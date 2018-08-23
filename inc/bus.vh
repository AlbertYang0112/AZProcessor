`ifnedf __BUS_VH
`define __BUS_VH

`define BUS_MASTER_CH       4         // The number of master's channels
`define BUS_MASTER_INDEX_W  2    // The index's width
`define BUS_OWNER_BUS       1:0       // The bus for indicating bus's owner
`define BUS_OWNER_MASTER_0  2'h0 // No.0 master
`define BUS_OWNER_MASTER_1  2'h1 // No.0 master
`define BUS_OWNER_MASTER_2  2'h2 // No.0 master
`define BUS_OWNER_MASTER_3  2'h3 // No.0 master
`define BUS_SLAVE_CH        8          // The number of slave's channels
`define BUS_SLAVE_INDEX_W   3     // The index's width
`define BUS_SLAVE_INDEX_BUS 2:0 
`define BUS_SLAVE_INDEX_LOC 29:27
`define BUS_SLAVE_0         0
`define BUS_SLAVE_1         1 
`define BUS_SLAVE_2         2
`define BUS_SLAVE_3         3
`define BUS_SLAVE_4         4
`define BUS_SLAVE_5         5
`define BUS_SLAVE_6         6
`define BUS_SLAVE_7         7

`endif