module function_generator_top(
    input sys_clk,
    input rst_n,
    input freq_up_key,
    input freq_down_key,
    input wave_form_key,

    output lcd_de,
    output lcd_clk,
    output [23:0] lcd_rgb,
    output lcd_bl,
    output lcd_hs,
    output lcd_vs,
    output lcd_rst
);

wire [31:0] frequency;
wire [7:0] data;
wire [10:0] x_pos;
wire [9:0] y_pos;
wire freq_down_trigger_i;
wire freq_up_trigger_i;
wire [6:0] freq_num;

dds_top  dds_top_inst (
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .frequency(frequency),
    .freq_down_trigger_i(freq_down_trigger_i),
    .freq_up_trigger_i(freq_up_trigger_i),
    .wave_form_key(wave_form_key),
    .x_pos(x_pos),
    .y_pos(y_pos),
    .data(data)
  );

freq_sel_top  freq_sel_top_inst (
    .clk_i(sys_clk),
    .rst_n_i(rst_n),
    .freq_up_key_i(freq_up_key),
    .freq_down_key_i(freq_down_key),
    .frequency_o(frequency),
    .freq_down_trigger_i(freq_down_trigger_i),
    .freq_up_trigger_i(freq_up_trigger_i),
    .freq_num(freq_num)
  );



lcd_top  lcd_top_inst (
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .dds_wave_data(data),
    .freq_num(freq_num),
    .lcd_de(lcd_de),
    .lcd_clk(lcd_clk),
    .lcd_rgb(lcd_rgb),
    .lcd_bl(lcd_bl),
    .lcd_hs(lcd_hs),
    .lcd_vs(lcd_vs),
    .lcd_rst(lcd_rst),
    .x_pos(x_pos),
    .y_pos(y_pos)
  );




endmodule