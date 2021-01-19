module ahb_arbiter
(
    output wire hgrant_o 
);

assign hgrant_o = 1'b1;//只有一个master,就简化处理了.

endmodule