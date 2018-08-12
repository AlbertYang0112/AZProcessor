`ifnedf __BUS_VH
`define __BUS_VH

BUS_MASTER_CH 4         // The number of master's channels
BUS_MASTER_INDEX_W 2    // The index's width
BUS_OWNER_BUS 1:0       // The bus for indicating bus's owner
BUS_OWNER_MASTER_0 2'h0 // No.0 master
BUS_OWNER_MASTER_1 2'h1 // No.0 master
BUS_OWNER_MASTER_2 2'h2 // No.0 master
BUS_OWNER_MASTER_3 2'h3 // No.0 master
BUS_SLAVE_CH 8          // The number of slave's channels
BUS_SLAVE_INDEX_W 3     // The index's width
BUS_SLAVE_INDEX_BUS 2:0 
BUS_SLAVE_INDEX_LOC 29:27
BUS_SLAVE_0 0
BUS_SLAVE_1 1 
BUS_SLAVE_2 2
BUS_SLAVE_3 3
BUS_SLAVE_4 4
BUS_SLAVE_5 5
BUS_SLAVE_6 6
BUS_SLAVE_7 7

`endif