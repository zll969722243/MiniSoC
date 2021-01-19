module ahb_slave_calc 
#(parameter WIDTH=32)
(
    input   wire            enable_i,
    input   wire[1:0]       opcode_i,
    input   wire[15:0]      operate_a_i,
    input   wire[15:0]      operate_b_i,
    output  reg[WIDTH-1:0]  operate_res_o
); 

parameter OPCODE_ADD = 2'b00;
parameter OPCODE_SUB = 2'b01;
parameter OPCODE_MUL = 2'b10;
parameter OPCODE_DIV = 2'b11;

always @(*)
begin
  if(enable_i)
    begin
      case(opcode_i)
          OPCODE_ADD:operate_res_o = operate_a_i + operate_b_i;
          OPCODE_SUB:operate_res_o = operate_a_i - operate_b_i;
          OPCODE_MUL:operate_res_o = operate_a_i * operate_b_i;
          OPCODE_DIV:operate_res_o = operate_a_i / operate_b_i;
      endcase
    end
  else
    begin
      operate_res_o = 32'b0;
    end
end 


endmodule


