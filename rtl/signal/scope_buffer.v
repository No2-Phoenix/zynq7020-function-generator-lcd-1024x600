module wave_frame_buffer #(
    parameter DIS_X_START = 0,
    parameter DIS_X_END   = 1023
)(
    input         clk,
    input  [9:0]  wr_addr,      
    input  [7:0]  sample_data,  
    input         wr_en,    
    input         ram_sel,      

    input  [10:0] x_pos,        

    output [7:0]  data          
);

//=============Internal Signal Declaration============//
wire [9:0] rd_addr;
wire [9:0] ram_addr1;
wire [9:0] ram_addr2;
wire       ram_we1;
wire       ram_we2;
wire [7:0] ram_out1;
wire [7:0] ram_out2;


//==========RAM Siganal Assignment===========//
assign rd_addr = (x_pos >= DIS_X_START && x_pos <= DIS_X_END) ? x_pos[9:0] : 10'd0;

assign ram_addr1 = (ram_sel == 1'b0) ? rd_addr : wr_addr;
assign ram_addr2 = (ram_sel == 1'b0) ? wr_addr : rd_addr;

assign ram_we1   = (ram_sel == 1'b0) ? 1'b0      : wr_en;
assign ram_we2   = (ram_sel == 1'b0) ? wr_en : 1'b0;

// DUT
blk_mem_gen_0 u_ram_1 (
  .clka (clk),
  .ena  (1'b1),
  .wea  (ram_we1),
  .addra(ram_addr1),
  .dina (sample_data),
  .douta(ram_out1)
);

blk_mem_gen_0 u_ram_2 (
  .clka (clk),
  .ena  (1'b1),
  .wea  (ram_we2),
  .addra(ram_addr2),
  .dina (sample_data),
  .douta(ram_out2)
);

//=============Data Output=============//
assign data = (ram_sel == 1'b0) ? ram_out1 : ram_out2;

endmodule
