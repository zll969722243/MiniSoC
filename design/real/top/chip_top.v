module chip_top
#(parameter WIDTH=32)
(
input   wire     hclk_i,
input   wire     hresetn_i
);

wire                 hgrant;
wire[1:0]            htrans;
wire[WIDTH-1:0]      haddr;
wire                 hwrite;
wire[2:0]            hsize;
wire[2:0]            hburst;
wire[WIDTH-1:0]      hwdata;

wire[WIDTH-1:0]      hrdata;
wire[1:0]            hresp;
wire                 hready;

wire                 hsel_sram;
wire                 hsel_ahb2apb_bridge;

cpu_top cpu_top_u1(
                    //AHB Bus input [master]
                    .hclk_i(hclk_i),
                    .hresetn_i(hresetn_i),
                    .hready_i(hready),
                    .hresp_i(hresp),
                    .hgrant_i(hgrant),
                    .hrdata_i(hrdata),

                    //AHB Bus output [master]
                    .htrans_o(htrans),
                    .haddr_o(haddr),
                    .hwrite_o(hwrite),
                    .hsize_o(hsize),
                    .hburst_o(hburst),
                    .hwdata_o(hwdata)
                  );

ahb_arbiter ahb_arbiter_u1(.hgrant_o(hgrant));

ahb_decoder ahb_decoder_u1(
                            .haddr_i(haddr),
                            .hsel_sram(hsel_sram),
                            .hsel_ahb2apb_bridge(hsel_ahb2apb_bridge)
                          );

ahb_mem ahb_mem_u1(
                    .haddr(haddr) ,           //input
                    .hburst(hburst) ,         //input
                    .hclk(hclk_i) ,             //input
                    .hreadyin(1'b1) ,           //input
                    .hresetn(hresetn_i) ,       //input
                    .hsel(hsel_sram) ,        //input
                    .hsize(hsize[1:0]) ,           //input
                    .htrans(htrans) ,         //input
                    .hwdata(hwdata) ,         //input
                    .hwrite(hwrite) ,         //input

                    .hrdata(hrdata) ,         //output
                    .hreadyout(hready) ,      //output
                    .hresp(hresp)             //output
                  );    

endmodule