// `include "ahb_slave_if.v"
// `include "ahb_slave_calc.v"

module ahb_calc_top 
(
    //input
    input   wire           hclk_i,
    input   wire           hresetn_i,
    input   wire           hsel_i,
    input   wire[31:0]     haddr_i,
    input   wire           hwrite_i,
    input   wire[1:0]      htrans_i,
    input   wire[2:0]      hsize_i,
    input   wire[2:0]      hburst_i,
    input   wire[31:0]     hwdata_i,

    input   wire[3:0]      hmaster_i,
    input   wire           hmastlock_i,

    //output 
    output  wire[31:0]     hrdata_o,
    output  wire           hready_o,
    output  wire[1:0]      hresp_o,
    output  wire[15:0]     hsplit_o,
    
    output  wire[31:0]     operate_res
);

//declare
wire            enable;
wire[1:0]       opcode;
wire[15:0]      operate_a;
wire[15:0]      operate_b;


//inst module
ahb_slave_if ahb_slave_if_u1
                            (
                            //input
                            .hclk_i(hclk_i),
                            .hresetn_i(hresetn_i),
                            .hsel_i(hsel_i),
                            .haddr_i(haddr_i),
                            .hwrite_i(hwrite_i),
                            .htrans_i(htrans_i),
                            .hsize_i(hsize_i),
                            .hburst_i(hburst_i),
                            .hwdata_i(hwdata_i),
                            .hmaster_i(hmaster_i),
                            .hmastlock_i(hmastlock_i),
                            .hrdata_o(hrdata_o),
                            .hready_o(hready_o),
                            .hresp_o(hresp_o),
                            .hsplit_o(hsplit_o),
                            .enable_o(enable),
                            .opcode_o(opcode),
                            .operate_a_o(operate_a),
                            .operate_b_o(operate_b)
                            );

ahb_slave_calc ahb_slave_calc_u1
                            (
                            .enable_i(enable),
                            .opcode_i(opcode),
                            .operate_a_i(operate_a),
                            .operate_b_i(operate_b),
                            .operate_res_o(operate_res)
                            );

endmodule //ahb_calc_top