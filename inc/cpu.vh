`ifndef __CPU_VH
`define __CPU_VH

`define REG_NUM                 32
`define REG_ADDR_W              5
`define REG_ADDR_BUS            4:0
`define CPU_IRQ_CH              8
`define CPU_IRQ_BUS             7:0
 
`define ALU_OP_W                4
`define ALU_OP_BUS              3:0
`define ALU_OP_NOP              4'h0
`define ALU_OP_AND              4'h1
`define ALU_OP_OR               4'h2
`define ALU_OP_XOR              4'h3
`define ALU_OP_ADDS             4'h4
`define ALU_OP_ADDU             4'h5
`define ALU_OP_SUBS             4'h6
`define ALU_OP_SUBU             4'h7
`define ALU_OP_SHRL             4'h8
`define ALU_OP_SHLL             4'h9
 
`define MEM_OP_W                2
`define MEM_OP_BUS              1:0
`define MEM_OP_NOP              2'h0
`define MEM_OP_LDW              2'h1
`define MEM_OP_STW              2'h2
 
`define CTRL_OP_W               2
`define CTRL_OP_BUS             1:0
`define CTRL_OP_NOP             2'h0
`define CTRL_OP_WRCR            2'h1
`define CTRL_OP_EXRT            2'h2
 
`define CPU_EXE_MODE_W          1
`define CPU_EXE_MODE_BUS        0:0
`define CPU_KERNEL_MODE         1'b0
`define CPU_USER_MODE           1'b1
 
`define CREG_ADDR_STATUS        5'h0
`define CREG_ADDR_PRE_STATUS    5'h1
`define CREG_ADDR_PC            5'h2
`define CREG_ADDR_EPC           5'h3
`define CREG_ADDR_EXP_VECTOR    5'h4
`define CREG_ADDR_CAUSE         5'h5
`define CREG_ADDR_INT_MASK      5'h6
`define CREG_ADDR_IRQ           5'h7
`define CREG_ADDR_ROM_SIZE      5'h1d
`define CREG_ADDR_SPM_SIZE      5'h1e
`define CREG_ADR_CPU_INFO       5'h1f
`define CREG_EXE_MODE_LOC       0
`define CREG_INT_ENABLE_LOC     1
`define CREG_EXP_CODE_LOC       2:0
`define CREG_DLY_FLAG_LOC       3

`define BUS_IF_STATE_BUS        1:0
`define BUS_IF_STATE_IDLE       2'h0
`define BUS_IF_STATE_REQ        2'h1
`define BUS_IF_STATE_ACCESS     2'h2
`define BUS_IF_STATE_STALL      2'h3
`define RESET_VECTOR            30'h0
`define SH_AMOUNT_BUS           4:0
`define SH_AMOUNT_LOC           4:0
`define RELEASE_YEAR            8'd18
`define RELEASE_MONTH           8'd8
`define RELEASE_VERSION         8'd1
`define RELEASE_REVISION        8'd0

`endif