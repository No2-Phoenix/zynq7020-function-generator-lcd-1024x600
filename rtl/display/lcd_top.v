module lcd_top(
    input sys_clk,
    input rst_n,
    input [7:0] dds_wave_data,
    input [6:0] freq_num,

    output  lcd_de,
    output lcd_clk,
    output [23:0] lcd_rgb,
    output lcd_bl,
    output lcd_hs,
    output lcd_vs,
    output lcd_rst,
    output [10:0] x_pos,
    output [9:0] y_pos
);

wire [23:0] pixel_data;
wire [10:0] pixel_xpos;
wire [9:0] pixel_ypos;

assign lcd_clk = sys_clk;
assign lcd_rst = rst_n;
assign x_pos = pixel_xpos;
assign y_pos = pixel_ypos;


lcd_driver u_lcd_driver(
    .lcd_pclk(sys_clk),
    .rst_n(rst_n),
    .pixel_data(pixel_data),
    
    .lcd_de(lcd_de),
    .lcd_rgb(lcd_rgb),
    .lcd_bl(lcd_bl),
    .lcd_hs(lcd_hs),
    .lcd_vs(lcd_vs),
    .pixel_xpos(pixel_xpos),
    .pixel_ypos(pixel_ypos)
);

lcd_display  lcd_display_inst (
    .lcd_pclk(sys_clk),
    .rst_n(rst_n),
    .freq_num(freq_num),
    .pixel_xpos(pixel_xpos),
    .pixel_ypos(pixel_ypos),
    .dds_wave_data(dds_wave_data),
    .pixel_data(pixel_data)
  );



endmodule