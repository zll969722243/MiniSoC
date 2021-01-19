`ifdef IVERILOG_CC    //为了解决iverilog编译目录与vscode包含路劲的起始位置不同的问题
  `include "./cpu/inst_set.v"
  `include "./cpu/debug_cfg.v"
`else
  `include "./real/cpu/inst_set.v"
  `include "./real/cpu/debug_cfg.v"
`endif

module  cpu_decode_exec
#(parameter WIDTH=32)
(
    input  wire             enable_i,
    input  wire[WIDTH-1:0]  opcode_i,
    input  wire[WIDTH-1:0]  opa_i,
    input  wire[WIDTH-1:0]  opb_i,
    input  wire             fetch_done_i,
    output wire[WIDTH-1:0]  newpc_o,
    output wire             isjcc_o,
    output wire[WIDTH-1:0]  data_o,
    output wire             exec_done_o
);

//macro define
// localparam OPCODE_ADD        = 8'h00;
// localparam OPCODE_SUB        = 8'h01;
// localparam OPCODE_MUL        = 8'h02;
// localparam OPCODE_DIV        = 8'h03;
// localparam OPCODE_DISPLAY    = 8'h04;
// localparam OPCODE_JMP        = 8'h05;
// localparam OPCODE_ID         = 8'h06;

//instruct set
// `define OPCODE_ADD         8'h00
// `define OPCODE_SUB         8'h01
// `define OPCODE_MUL         8'h02
// `define OPCODE_DIV         8'h03
// `define OPCODE_DISPLAY     8'h04
// `define OPCODE_JMP         8'h05
// `define OPCODE_ID          8'h06

//add any other instruct here!

//`define OPCODE_INIT         8'hff

localparam OPCODE_SIZE       = 32'h4;
localparam OPA_SIZE          = 32'h4;
localparam OPB_SIZE          = 32'h4;
localparam CPUID             = 32'h19920308;


//variables declared
reg[WIDTH-1:0] result_r      = 32'b00;
reg[WIDTH-1:0] step_r        = 32'b00;
reg[WIDTH-1:0] pc_r          = 32'b00;//The appropriate initial value needs to be set.
reg isjcc_r                  = 1'b0;
reg[WIDTH-1:0] data_r        = 32'b00;

wire bexec;

reg exec_done_r              = 1'b1;//标识是否能够取下一条指令,即当前指令执行完即可取下一条指令

//logic
assign step_o    = step_r;
assign newpc_o   = pc_r;
assign isjcc_o   = isjcc_r;
assign data_o    = data_r;

assign bexec = enable_i && fetch_done_i;

assign exec_done_o = exec_done_r;

always @(fetch_done_i)
begin `CPU_DECODE_EXEC_LOG_3("[cpu_decode_exec]fetch_done_i:%b bexec:%b\n",fetch_done_i,bexec);
  if(bexec)
  //if(enable_i && fetch_done_i)
    begin
      exec_done_r = 1'b0;
      `CPU_DECODE_EXEC_LOG_2("[cpu_decode_exec]exec_done_r:%b\n",exec_done_r);
      case(opcode_i[7:0])
        `OPCODE_INIT:
          begin
            step_r = `FETCH_STEP_SIZE;
            `CPU_DECODE_EXEC_LOG_1("[cpu_decode_exec]exec cpu initialize\n");
          end
        `OPCODE_ADD:
          begin
            result_r = opa_i + opb_i;
            //step_r = OPCODE_SIZE + OPA_SIZE + OPB_SIZE;
            step_r = `FETCH_STEP_SIZE;
            pc_r = pc_r + step_r;
            isjcc_r = 1'b0;

            `CPU_DECODE_EXEC_LOG_4("[cpu_decode_exec]exec add,opa+opb=>:%h+%h=%h \n",opa_i,opb_i,result_r);
          end
        `OPCODE_SUB:
          begin
            result_r = opa_i - opb_i;
            //step_r = OPCODE_SIZE + OPA_SIZE + OPB_SIZE;
            step_r = `FETCH_STEP_SIZE;
            pc_r = pc_r + step_r;
            isjcc_r = 1'b0;

            `CPU_DECODE_EXEC_LOG_4("[cpu_decode_exec]exec sub,opa-opb=>:%h-%h=%h \n",opa_i,opb_i,result_r);
          end
        `OPCODE_MUL:            
          begin
            result_r = opa_i * opb_i;
            //step_r = OPCODE_SIZE + OPA_SIZE + OPB_SIZE;
            step_r = `FETCH_STEP_SIZE;
            pc_r = pc_r + step_r;
            isjcc_r = 1'b0;

            `CPU_DECODE_EXEC_LOG_4("[cpu_decode_exec]exec mul,opa*opb=>:%h*%h=%h \n",opa_i,opb_i,result_r);
          end
        `OPCODE_DIV:            
          begin
            result_r = opa_i / opb_i;
            //step_r = OPCODE_SIZE + OPA_SIZE + OPB_SIZE;
            step_r = `FETCH_STEP_SIZE;
            pc_r = pc_r + step_r;
            isjcc_r = 1'b0;

            `CPU_DECODE_EXEC_LOG_4("[cpu_decode_exec]exec div,opa\\opb=>:%h\\%h=%h \n",opa_i,opb_i,result_r);
          end
        `OPCODE_DISPLAY:
          begin
            //opa_i is the size of string. opb_i is the addr of the string.
            //step_r = OPCODE_SIZE + OPA_SIZE + OPB_SIZE;
            step_r = `FETCH_STEP_SIZE;
            pc_r = pc_r + step_r;
            isjcc_r = 1'b0;

            `CPU_DECODE_EXEC_LOG_1("[cpu_decode_exec]exec display \n");
          end        
        `OPCODE_JMP:
          begin
            //step_r = OPCODE_SIZE + OPA_SIZE;
            step_r = `FETCH_STEP_SIZE;
            pc_r = opa_i;// opa_i is the new target addr.     
            isjcc_r = 1'b1;

            `CPU_DECODE_EXEC_LOG_2("[cpu_decode_exec]exec jcc target addr:%h\n",opa_i);
          end
        `OPCODE_ID:
          begin
            data_r = CPUID;
            step_r = `FETCH_STEP_SIZE;
            pc_r = pc_r + step_r;
            isjcc_r = 1'b0;

            `CPU_DECODE_EXEC_LOG_1("[cpu_decode_exec]exec id \n");
            
          end
        default:
            `CPU_DECODE_EXEC_LOG_1("[cpu_decode_exec]invalid instruct\n");

      endcase

      exec_done_r = 1'b1;
      `CPU_DECODE_EXEC_LOG_2("[cpu_decode_exec]exec_done_r:%b\n",exec_done_r);
    end
  else
    begin
      `CPU_DECODE_EXEC_LOG_3("[cpu_decode_exec]hello mini soc ,opcode:%h,fetch_done:%b\n",opcode_i[7:0],fetch_done_i);
    end
end 


endmodule