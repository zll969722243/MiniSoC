`timescale 1ns/1ns

module chip_top_tb;

reg clk = 1'b0;
reg resetn = 1'b0;

// reg[31:0]   memory[99:0];
// reg[31:0]   index = 32'h00;

always #10 clk = !clk;

initial 
  begin
	$dumpfile("wave.vcd");  // 指定VCD文件的名字为wave.vcd,仿真信息将记录到此文件
	$dumpvars(0, chip_top_tb);  // 指定层次数为0,则tb_code模块及其下面各层次的所有信号将被记录
  end

initial
  begin
    // $readmemh("./top/code.zll",memory);//16进制为存储器赋值,相对路径的起点是执行vvp.exe的当前目录.
    // for(index = 0; index <= 10; index = index+1)
    //     $display("%h-%h",index,memory[index]);
    #20
    resetn = 1'b1;
    #100000000000000;
    $finish();

  end

chip_top chip_top_u1(
                      .hclk_i(clk),
                      .hresetn_i(resetn)
                    );

endmodule