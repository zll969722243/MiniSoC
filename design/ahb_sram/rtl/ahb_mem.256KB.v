module ahb_mem(
    input [31:0]    haddr           ,
    input [2:0]     hburst          ,
    input           hclk            ,
    input           hreadyin        ,
    input           hresetn         ,
    input           hsel            ,
    input [1:0]     hsize           ,
    input [1:0]     htrans          ,
    input [31:0]    hwdata          ,
    input           hwrite          ,

    output [31:0]   hrdata          ,
    output          hreadyout       ,
    output [1:0]    hresp            
);


// Mux logic
wire [15:0]     sram_addr;
wire [31:0]     sram_wdata;
wire            sram_cen;
wire [31:0]     sram_rdata;
wire [3:0]      sram_we;

ismi  sramif(
    // Outputs
    .hrdata         (hrdata[31:0]),
    .hreadyout  (hreadyout),
    .hresp          (hresp[1:0]),
    .maddr          (sram_addr[15:0]),
    .mcen             (sram_cen),
    .mwdata         (sram_wdata[31:0]),
    .mwe              (sram_we[3:0]),
    // Inputs
    .hclk             (hclk),
    .hresetn        (hresetn),
    .hsel             (hsel),
    .haddr          (haddr[31:0]),
    .hwdata         (hwdata[31:0]),
    .htrans         (htrans[1:0]),
    .hburst         (hburst[2:0]),
    .hsize          (hsize[1:0]),
    .hwrite         (hwrite),
    .hreadyin       (hreadyin),
    .mrdata         (sram_rdata[31:0])
);

  wire [31:0] we;
  wire wen;

  assign we[31:24] = {8{sram_we[3]}};
  assign we[23:16] = {8{sram_we[2]}};
  assign we[15:8]  = {8{sram_we[1]}};
  assign we[7:0]   = {8{sram_we[0]}};
  assign wen = ~|sram_we[3:0];

// sram_model u_sram_model(
sp_64kx32m8_mem_wrapper u_sp_64kx32m8_mem_wrapper(
    .Q              (sram_rdata     ),
    .CLK            (hclk           ),
    .CEN            (sram_cen       ),
    .WEN            (~(|sram_we)    ),
    .BWEN           (~sram_we       ),
    .A              (sram_addr      ),
    .D              (sram_wdata     )
);


endmodule
