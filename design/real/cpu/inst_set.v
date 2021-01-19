//instruct set
`define OPCODE_ADD         8'h00
`define OPCODE_SUB         8'h01
`define OPCODE_MUL         8'h02
`define OPCODE_DIV         8'h03
`define OPCODE_DISPLAY     8'h04
`define OPCODE_JMP         8'h05
`define OPCODE_ID          8'h06
`define OPCODE_PAUSE       8'h07
`define OPCODE_DISPLAY_D   8'h08


//add any other instruct here!
`define OPCODE_SHUTDOWN    8'hfe
`define OPCODE_INIT        8'hff



//定义起始取指地址
`define FETCH_START_ADDR   32'h6c       


//我这里自定义的指令集为:
//opcode:opa:opb
//固定为3个32bit的数据,诸如id这类指令,opa,opb为reserved;,jcc这类指令,opb为reserved.
`define FETCH_STEP_SIZE    32'h0c