module ahb_decoder
#(parameter WIDTH=32)
(
input  wire[WIDTH-1:0]  haddr_i,
output reg              hsel_sram,
output reg              hsel_ahb2apb_bridge
);

// memory map table
/*
0x00000000 - 0x0003ffff   //sram            256kb
0x00040000 - 0x0007ffff   //ahb2apb bridge  256kb
*/

always @(*) 
  begin
    if(haddr_i[19:16] == 4'h0)
      begin
        hsel_sram = 1'b1;
        hsel_ahb2apb_bridge = 1'b0;
      end
    else if(haddr_i[19:16] == 4'h4)
      begin
        hsel_sram = 1'b0;
        hsel_ahb2apb_bridge = 1'b1;
      end
    else
      begin
        hsel_sram = 1'b0;
        hsel_ahb2apb_bridge = 1'b0;
      end 
  end

endmodule