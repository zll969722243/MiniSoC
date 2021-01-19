module sp_64kx32m8_mem_wrapper(
    output  reg     [ 31: 0]   Q             ,
    input   wire    [ 15: 0]   A             ,
    input   wire    [ 31: 0]   D             ,
    input   wire               CEN           ,
    input   wire               CLK           ,
    input   wire               WEN           ,
    input   wire    [  3: 0]   BWEN          
);
wire    [31:0]  u0_q_out ;
wire    [31:0]  u1_q_out ;
wire    [31:0]  u2_q_out ;
wire    [31:0]  u3_q_out ;
wire            u0_cs_n  ;
wire            u1_cs_n  ;
wire            u2_cs_n  ;
wire            u3_cs_n  ;
reg             u0_cs_n_dly ;
reg             u1_cs_n_dly ;
reg             u2_cs_n_dly ;
reg             u3_cs_n_dly ;

wire            u0_wen      ;
wire            u1_wen      ;
wire            u2_wen      ;
wire            u3_wen      ;

wire [31:0]     u_bwen     ;

assign u0_wen  = ~( (WEN==1'b0)&(A[15:14]==2'b00));
assign u1_wen  = ~( (WEN==1'b0)&(A[15:14]==2'b01));
assign u2_wen  = ~( (WEN==1'b0)&(A[15:14]==2'b10));
assign u3_wen  = ~( (WEN==1'b0)&(A[15:14]==2'b11));

assign u_bwen = { {8{BWEN[3]}}, {8{BWEN[2]}}, {8{BWEN[1]}}, {8{BWEN[0]}} };

assign u0_cs_n = ~( (CEN==1'b0)&(A[15:14]==2'b00));
assign u1_cs_n = ~( (CEN==1'b0)&(A[15:14]==2'b01));
assign u2_cs_n = ~( (CEN==1'b0)&(A[15:14]==2'b10));
assign u3_cs_n = ~( (CEN==1'b0)&(A[15:14]==2'b11));

always @(posedge CLK)begin
  u0_cs_n_dly <= u0_cs_n ; 
  u1_cs_n_dly <= u1_cs_n ; 
  u2_cs_n_dly <= u2_cs_n ; 
  u3_cs_n_dly <= u3_cs_n ; 
end

always @(*)begin
    case({u3_cs_n_dly, u2_cs_n_dly, u1_cs_n_dly, u0_cs_n_dly})
    4'b1110 : Q = u0_q_out ;
    4'b1101 : Q = u1_q_out ;
    4'b1011 : Q = u2_q_out ;
    4'b0111 : Q = u3_q_out ;
    default: Q = 32'h0000_0000 ;
    endcase
end

S55NLLGSPH_X512Y32D32 u0_S55NLLGSPH_X512Y32D32(
    .Q                          (           u0_q_out[31:0]          ),
    .CLK                        (           CLK                     ),
    .CEN                        (           u0_cs_n                 ),
    .WEN                        (           u0_wen                  ),
    .BWEN                       (           u_bwen                  ),
    .A                          (           A[13:0]                 ),
    .D                          (           D[31:0]                 )
);

S55NLLGSPH_X512Y32D32 u1_S55NLLGSPH_X512Y32D32(
    .Q                          (           u1_q_out[31:0]          ),
    .CLK                        (           CLK                     ),
    .CEN                        (           u1_cs_n                 ),
    .WEN                        (           u1_wen                  ),
    .BWEN                       (           u_bwen                  ),
    .A                          (           A[13:0]                 ),
    .D                          (           D[31:0]                 )
);

S55NLLGSPH_X512Y32D32 u2_S55NLLGSPH_X512Y32D32(
    .Q                          (           u2_q_out[31:0]          ),
    .CLK                        (           CLK                     ),
    .CEN                        (           u2_cs_n                 ),
    .WEN                        (           u2_wen                  ),
    .BWEN                       (           u_bwen                  ),
    .A                          (           A[13:0]                 ),
    .D                          (           D[31:0]                 )
);

S55NLLGSPH_X512Y32D32 u3_S55NLLGSPH_X512Y32D32(
    .Q                          (           u3_q_out[31:0]          ),
    .CLK                        (           CLK                     ),
    .CEN                        (           u3_cs_n                 ),
    .WEN                        (           u3_wen                  ),
    .BWEN                       (           u_bwen                  ),
    .A                          (           A[13:0]                 ),
    .D                          (           D[31:0]                 )
);


endmodule
