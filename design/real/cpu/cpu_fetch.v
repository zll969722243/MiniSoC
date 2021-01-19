`ifdef IVERILOG_CC    //为了解决iverilog编译目录与vscode包含路劲的起始位置不同的问题
  `include "./cpu/inst_set.v"
  `include "./cpu/debug_cfg.v"
`else
  `include "./real/cpu/inst_set.v"
  `include "./real/cpu/debug_cfg.v"
`endif



module cpu_fetch
#(parameter WIDTH=32)
(
    //AHB Bus input [master]
    input   wire                hclk_i,
    input   wire                hresetn_i,
    input   wire                hready_i,
    input   wire[1:0]           hresp_i,
    input   wire                hgrant_i,
    input   wire[WIDTH-1:0]     hrdata_i,

    //AHB Bus output [master]
    //output  wire                hbusreq,//因为只有一个master,故无需Arbiter
    //output  wire                hlock, 
    //output wire[3:0]            hprot,//无需保护属性
    output  wire[1:0]           htrans_o,
    output  wire[WIDTH-1:0]     haddr_o,
    output  wire                hwrite_o,
    output  wire[2:0]           hsize_o,
    output  wire[2:0]           hburst_o,
    output  wire[WIDTH-1:0]     hwdata_o,

    //cpu module 
    input   wire[WIDTH-1:0]     new_fetch_addr_i,
    input   wire                isjcc_i,
    input   wire                exec_down_i,
    output  wire                enable_o,
    output  wire[WIDTH-1:0]     opcode_o,
    output  wire[WIDTH-1:0]     opa_o,
    output  wire[WIDTH-1:0]     opb_o,
    output  wire                fetch_done_o
);

//macro define
localparam OPCODE_SIZE       = 32'h4;
localparam OPA_SIZE          = 32'h4;
localparam OPB_SIZE          = 32'h4;
localparam CPUID             = 32'h19920308;

//htrans
localparam IDLE              = 2'b00;
localparam BUSY              = 2'b01;
localparam NONSEQ            = 2'b10;
localparam SEQ               = 2'b11;

//hburst
localparam SINGLE 		 = 3'b000; //SINGLE Single transfer
localparam INCR 			 = 3'b001; //INCR Incrementing burst of unspecified length
localparam WRAP4 			 = 3'b010; //WRAP4 4-beat wrapping burst
localparam INCR4 			 = 3'b011; //INCR4 4-beat incrementing burst
localparam WRAP8 			 = 3'b100; //WRAP8 8-beat wrapping burst
localparam INCR8 			 = 3'b101; //INCR8 8-beat incrementing burst
localparam WRAP16 		 = 3'b110; //WRAP16 16-beat wrapping burst
localparam INCR16 		 = 3'b111; //INCR16 16-beat incrementing burst

//hresp
localparam OKAY        = 2'b00;
localparam ERROR       = 2'b01;
localparam RETRY       = 2'b10;
localparam SPLIT       = 2'b11;

//hsize
localparam BYTE 			   = 3'b000; //8 bits Byte
localparam WORD 			   = 3'b001; //16 bits Halfword
localparam DWORD 		  	 = 3'b010; //32 bits Word
localparam QWORD 		  	 = 3'b011; //64 bits -
localparam QQWORD 			 = 3'b100; //128 bits 4-word line
localparam QQQWORD 			 = 3'b101; //256 bits 8-word line
localparam QQQQWORD 		 = 3'b110; //512 bits -
localparam QQQQQWORD 		 = 3'b111; //1024 bits -

//variables declared
reg[1:0]           htrans_r;
reg[WIDTH-1:0]     haddr_r;
reg                hwrite_r;
reg[2:0]           hsize_r;
reg[2:0]           hburst_r;
reg[WIDTH-1:0]     hwdata_r;


reg[WIDTH-1:0]     opcode_r      = `OPCODE_INIT;
reg[WIDTH-1:0]     opa_r         = 32'h0;
reg[WIDTH-1:0]     opb_r         = 32'h0;
reg                fetch_done_r  = 1'b0;//标识当前取指是否完成
reg[WIDTH-1:0]     fetch_addr_r  = `FETCH_START_ADDR;
wire               can_fecth;           //标识当前是否能够取指,需要等当前取的指令执行完才取下一条指令且当前还是arbiter授权

//logic
assign htrans_o	 = htrans_r;
assign haddr_o	 = haddr_r;
assign hwrite_o	 = hwrite_r;
assign hsize_o	 = hsize_r;
assign hburst_o	 = hburst_r;
assign hwdata_o	 = hwdata_r;

assign enable_o	 = hresetn_i && hgrant_i && hready_i;
assign opcode_o  = opcode_r;
assign opa_o     = opa_r;
assign opb_o     = opb_r;
assign fetch_done_o = fetch_done_r;

assign can_fecth = hgrant_i && exec_down_i;

task cpu_read(input [WIDTH-1:0] addr,output reg[WIDTH-1:0] data);
  begin
    @(posedge hclk_i);
    #1
    haddr_r     = addr;
    hwrite_r    = 1'b0;
    htrans_r    = NONSEQ;
    hsize_r     = DWORD; //32bits
    hburst_r    = SINGLE;

    @(posedge hclk_i);
    #1
    @(posedge hready_i);
    #1
    data      = hrdata_i;
  end 

endtask

always @(posedge hclk_i or negedge hresetn_i) 
  begin
    if(!hresetn_i)
      begin
      htrans_r	 = IDLE;
      hburst_r	 = SINGLE;
      hsize_r		 = DWORD;
      hwdata_r	 = 32'h00;	
      haddr_r		 = 32'h00;
      hwrite_r	 = 1'b0;
      end
    else if(can_fecth)
      begin
          if(isjcc_i == 1'b1) begin
            fetch_addr_r = new_fetch_addr_i;
            `CPU_FETCH_LOG_2("[cpu_fetch]fetch_addr_r:%h\n",fetch_addr_r);
          end
          fetch_done_r = 1'b0;
          `CPU_FETCH_LOG_2("[cpu_fetch]fetch_done_r:%b",fetch_done_r);
          cpu_read(fetch_addr_r+0,opcode_r);`CPU_FETCH_LOG_3("[cpu_fetch]addr:%h,opcode_r:%h",fetch_addr_r+0,opcode_r);
          #100 cpu_read(fetch_addr_r+4,opa_r);`CPU_FETCH_LOG_3("[cpu_fetch]addr:%h,opa_r:%h",fetch_addr_r+4,opa_r);
          #100 cpu_read(fetch_addr_r+8,opb_r);`CPU_FETCH_LOG_3("[cpu_fetch]addr:%h,opb_r:%h",fetch_addr_r+8,opb_r);
          fetch_done_r = 1'b1;
          `CPU_FETCH_LOG_2("[cpu_fetch]fetch_done_r:%b",fetch_done_r);
          `CPU_FETCH_LOG_2("[cpu_fetch]exec_down_i:%b",exec_down_i);
          fetch_addr_r = fetch_addr_r + `FETCH_STEP_SIZE;
      end

    else
      `CPU_FETCH_LOG_3("[cpu_fetch]----can_fecth:%b,exec_down_i:%b\n",can_fecth,exec_down_i);
  end

endmodule