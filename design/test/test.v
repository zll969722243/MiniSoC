module test(
input wire clk,
input wire a_i,
input wire b_i,
input wire c_i,
output reg d_o 
);

always @(posedge clk)
begin
    if(a_i)
        d_o = b_i+c_i;
    else
        d_o = b_i-c_i;

     $display("test");
end

endmodule