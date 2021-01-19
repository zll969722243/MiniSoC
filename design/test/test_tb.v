`timescale 1ns/1ns

module test_tb;

reg clk;
wire a;
wire b;
wire c;
wire d;

always #50 clk = ~clk;

always  
  begin
    $display("always-1");
    wait(a);
  end

initial
  begin
      $display("initial-1");
      $stop();
  end

initial
  begin
      $display("initial-2");
  end

always  
  begin
    $display("always-2");
    wait(a);
  end

test test_u1(
            .clk(clk),
            .a_i(a),
            .b_i(b),
            .c_i(c),
            .d_o(d) 
            );


endmodule