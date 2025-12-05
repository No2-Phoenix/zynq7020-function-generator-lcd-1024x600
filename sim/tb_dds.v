`timescale 1ns/1ns
module dds_core_tb;




  //Ports
  reg clk_i;
  reg rst_n_i;
  reg [31:0] frequency_i;
  wire signed [7:0] dds_wave;
  wire [31:0] dds_phase;
  wire dds_wave_valid;

initial begin
clk_i = 1'b0;
rst_n_i = 1'b0;
frequency_i = 32'h00000;
#100
rst_n_i = 1'b1;

end


  dds_core  dds_core_inst (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .frequency_i(frequency_i),
    .dds_wave(dds_wave),
    .dds_phase(dds_phase),
    .dds_wave_valid(dds_wave_valid)
  );

//always #5  clk = ! clk ;

endmodule