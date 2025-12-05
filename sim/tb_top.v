`timescale 1ns/1ns

module function_generator_top_tb;

  // Parameters

  //Ports
  reg sys_clk;
  reg rst_n;
  reg freq_up_key;
  reg freq_down_key;
  reg wave_form_key;
  wire lcd_de;
  wire lcd_clk;
  wire [23:0] lcd_rgb;
  wire lcd_bl;
  wire lcd_hs;
  wire lcd_vs;
  wire lcd_rst;

always #10 sys_clk = ~sys_clk;


initial begin
sys_clk = 1'b0;
rst_n = 1'b0;
freq_up_key = 1'b1;
freq_down_key = 1'b1;
wave_form_key = 1'b1;
#100
rst_n = 1'b1;

end



  function_generator_top  function_generator_top_inst (
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .freq_up_key(freq_up_key),
    .freq_down_key(freq_down_key),
    .wave_form_key(wave_form_key),
    .lcd_de(lcd_de),
    .lcd_clk(lcd_clk),
    .lcd_rgb(lcd_rgb),
    .lcd_bl(lcd_bl),
    .lcd_hs(lcd_hs),
    .lcd_vs(lcd_vs),
    .lcd_rst(lcd_rst)
  );

//always #5  clk = ! clk ;

endmodule