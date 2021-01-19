`timescale 1ns/1ns

module ahb_slave_calc_tb;
reg           hclk = 1'b0;
reg           hresetn;
reg           hsel;
reg[31:0]     haddr;
reg           hwrite;
reg[1:0]      htrans;
reg[2:0]      hsize;
reg[2:0]      hburst;
reg[31:0]     hwdata;
reg[3:0]      hmaster;
reg           hmastlock;
wire[31:0]    hrdata;
wire          hready;
wire[1:0]     hresp;
wire[15:0]    hsplit;

wire[31:0]    operate_res;


//参数定义-HTRANS
parameter IDLE     = 2'b00; 
parameter BUSY     = 2'b01;
parameter NONSEQ   = 2'b10;
parameter SEQ      = 2'b11;

//参数定义-HRESP
parameter OKAY     = 2'b00;
parameter ERROR    = 2'b01;
parameter RETRY    = 2'b10;
parameter SPLIT    = 2'b11;

//参数定义-HBUSRT
parameter SINGLE    = 3'b000;
parameter INCR      = 3'b001;
parameter WRAP4     = 3'b010;
parameter INCR4     = 3'b011;
parameter WRAP8     = 3'b100;
parameter INCR8     = 3'b101;

parameter WRAP16    = 3'b110;
parameter INCR16    = 3'b111;

//local
reg[31:0] read_data=32'h00;

//task
task ahb_write(input [31:0] addr,input [31:0] data);
  begin
    @(posedge hclk);
    #1 
    hresetn   = 1'b1;
    hsel      = 1'b1;
    haddr     = addr;
    hwrite    = 1'b1;
    htrans    = NONSEQ;
    hsize     = 3'b010; //32bits
    hburst    = SINGLE;

    @(posedge hclk);
    #1
    hwdata    = data;
  end 

endtask

task ahb_read(input [31:0] addr,output reg [31:0] data);
  begin
    @(posedge hclk);
    #1 
    hresetn   = 1'b1;
    hsel      = 1'b1;
    haddr     = addr;
    hwrite    = 1'b0;
    htrans    = NONSEQ;
    hsize     = 3'b010; //32bits
    hburst    = SINGLE;

    @(posedge hclk);
    #1
    @(posedge hclk);
    #1
    data      = hrdata;

  end 

endtask

//生成输入激励
//clk generate
always #10 hclk = ~hclk;

initial 
  begin
	  $dumpfile("wave.vcd");  // 指定VCD文件的名字为wave.vcd,仿真信息将记录到此文件
	  $dumpvars(0, ahb_slave_calc_tb );  // 指定层次数为0,则tb_code模块及其下面各层次的所有信号将被记录
  end

//初始化
initial
  begin
    hresetn   = 1'b0;
    hsel      = 1'b0;
    haddr     = 32'b0;
    hwrite    = 1'b0;
    htrans    = IDLE;
    hsize     = 3'b010;//32bits
    hburst    = SINGLE;
    hwdata    = 32'b0;
    hmaster   = 4'b0010;
    hmastlock = 1'b1;
  end

initial
  begin
    //ENABLE_ADDR
    ahb_write(32'b00,32'b1);

    //OPCODE_ADDR,OPCODE_MUL
    ahb_write(32'h04,32'b10);
   
    //OPA_ADDR
    ahb_write(32'h08,32'h3);

    //OPB_ADDR
    ahb_write(32'h0C,32'h4);

    @(posedge hclk);
    #1
    $display("%h * %h = %h\n",3,4,operate_res);

    //OPA_ADDR
    ahb_read(32'h08,read_data);
  
    @(posedge hclk);
    #1
    $display("opa:%h\n",read_data);
    $finish();

  end

ahb_calc_top ahb_calc_top_u1
                        (
                        .hclk_i(hclk),
                        .hresetn_i(hresetn),
                        .hsel_i(hsel),
                        .haddr_i(haddr),
                        .hwrite_i(hwrite),
                        .htrans_i(htrans),
                        .hsize_i(hsize),
                        .hburst_i(hburst),
                        .hwdata_i(hwdata),
                        .hmaster_i(hmaster),
                        .hmastlock_i(hmastlock),
                        .hrdata_o(hrdata),
                        .hready_o(hready),
                        .hresp_o(hresp),
                        .hsplit_o(hsplit),
                        .operate_res(operate_res)
                        );

endmodule //ahb_slave_calc_tb