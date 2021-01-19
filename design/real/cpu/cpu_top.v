module cpu_top
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
output  wire[1:0]           htrans_o,
output  wire[WIDTH-1:0]     haddr_o,
output  wire                hwrite_o,
output  wire[2:0]           hsize_o,
output  wire[2:0]           hburst_o,
output  wire[WIDTH-1:0]     hwdata_o
);

wire            enable;
wire[WIDTH-1:0] opcode;
wire[WIDTH-1:0] opa;
wire[WIDTH-1:0] opb;
wire[WIDTH-1:0] newpc;
wire            isjcc;
wire            fetch_done;
wire            exec_done;

cpu_fetch cpu_fetch_u1(
                //AHB Bus input [master]
                .hclk_i(hclk_i),
                .hresetn_i(hresetn_i),
                .hready_i(hready_i),
                .hresp_i(hresp_i),
                .hgrant_i(hgrant_i),
                .hrdata_i(hrdata_i),

                //AHB Bus output [master]
                .htrans_o(htrans_o),
                .haddr_o(haddr_o),
                .hwrite_o(hwrite_o),
                .hsize_o(hsize_o),
                .hburst_o(hburst_o),
                .hwdata_o(hwdata_o),

                //cpu module 
                .new_fetch_addr_i(newpc),
                .isjcc_i(isjcc),
                .exec_down_i(exec_done),
                .enable_o(enable),
                .opcode_o(opcode),
                .opa_o(opa),
                .opb_o(opb),
                .fetch_done_o(fetch_done)
                );

cpu_decode_exec cpu_decode_exec_u1(
                                  .enable_i(enable),
                                  .opcode_i(opcode),
                                  .opa_i(opa),
                                  .opb_i(opb),
                                  .fetch_done_i(fetch_done),
                                  .newpc_o(newpc),
                                  .isjcc_o(isjcc),
                                  .exec_done_o(exec_done)
                                  //.data_o(data)
                                  );

endmodule