module ahb_slave_if
#(parameter WIDTH=32)
(
    //input
    input   wire                hclk_i,
    input   wire                hresetn_i,
    input   wire                hsel_i,
    input   wire[WIDTH-1:0]     haddr_i,
    input   wire                hwrite_i,
    input   wire[1:0]           htrans_i,
    input   wire[2:0]           hsize_i,
    input   wire[2:0]           hburst_i,
    input   wire[WIDTH-1:0]     hwdata_i,

    input   wire[3:0]           hmaster_i,
    input   wire                hmastlock_i,

    //output 
    output  reg[WIDTH-1:0]      hrdata_o,
    output  wire                hready_o,
    output  wire[1:0]           hresp_o,
    output  wire[15:0]          hsplit_o,

    output   wire               enable_o,
    output   wire[1:0]          opcode_o,
    output   wire[15:0]         operate_a_o,
    output   wire[15:0]         operate_b_o
);

//htrans
parameter IDLE   = 2'b00;
parameter BUSY   = 2'b01;
parameter NONSEQ = 2'b10;
parameter SEQ    = 2'b11;

//addr
`define ENABLE_ADDR     32'h00
`define OPCODE_ADDR     32'h04
`define OPA_ADDR        32'h08
`define OPB_ADDR        32'h0C
`define RES_ADDR        32'h10

//hresp
`define OKAY            2'b00
`define ERROR           2'b01

//local
wire hwrite;
wire hread ;

reg             enable_r;
reg[1:0]        opcode_r;
reg[15:0]       operate_a_r = 16'b0;
reg[15:0]       operate_b_r = 16'b0;
reg[WIDTH-1:0]  res_r;

reg             hwrite_r;
reg[1:0]        htrans_r;
reg[2:0]        hsize_r;
reg[2:0]        hburst_r;
reg[WIDTH-1:0]  haddr_r;

//===========================================================================================
//logic
assign hready_o = 1'b1;
assign hresp_o = `OKAY;

assign hwrite = (hsel_i && hwrite_i && (htrans_i==NONSEQ) || (htrans_i==SEQ));
assign hread  = hsel_i && !hwrite_i && (htrans_i==NONSEQ || htrans_i==SEQ);

assign enable_o = enable_r;
assign opcode_o = opcode_r;
assign operate_a_o = operate_a_r;
assign operate_b_o = operate_b_r;

//sample the master control singles
always @(posedge hclk_i or negedge hresetn_i) 
  begin
    if(!hresetn_i)
      begin
        hwrite_r    <= 1'b0;
        htrans_r    <= 2'b0;
        hsize_r     <= 3'b0;
        hburst_r    <= 3'b0;
        haddr_r     <= 32'b0;
      end
    else if(hsel_i)
      begin
        hwrite_r    <= hwrite_i;
        htrans_r    <= htrans_i;
        hsize_r     <= hsize_i ;
        hburst_r    <= hburst_i;
        haddr_r     <= haddr_i ;
      end
    else
      begin
        hwrite_r    <= 1'b0;
        htrans_r    <= 2'b0;
        hsize_r     <= 3'b0;
        hburst_r    <= 3'b0;
      end
  end

//write or read data
always @(posedge hclk_i or negedge hresetn_i) 
  begin
    if(!hresetn_i)
      begin
            enable_r <= 1'b0;        
            opcode_r <= 2'b00;
            operate_a_r <= 16'b00;
            operate_a_r <= 16'b00;
      end
    else if(hwrite)
      begin
        case(haddr_r) 
          `ENABLE_ADDR:   enable_r    <= hwdata_i[0];
          `OPCODE_ADDR:   opcode_r    <= hwdata_i[1:0];
          `OPA_ADDR:      operate_a_r <= hwdata_i[15:0];
          `OPB_ADDR:      operate_b_r <= hwdata_i[15:0];
        endcase
      end
    else if(hread)
      begin
        case(haddr_r) 
          `ENABLE_ADDR:   hrdata_o  <= {31'b0,enable_r};
          `OPCODE_ADDR:   hrdata_o  <= {30'b0,opcode_r};
          `OPA_ADDR:      hrdata_o  <= {16'b0,operate_a_r};
          `OPB_ADDR:      hrdata_o  <= {16'b0,operate_b_r}; 
        endcase
      end
    else
      begin
        hrdata_o = 32'b0;
      end  

      //$display("%b,%b,%b,%b\n",hwrite, hsel_i, hwrite_i, htrans_i);
  end

endmodule