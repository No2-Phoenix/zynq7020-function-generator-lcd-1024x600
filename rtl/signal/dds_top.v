module dds_top(
    input sys_clk,
    input rst_n,
    input [31:0] frequency,
    input wave_form_key,
    input [10:0] x_pos,
    input [9:0] y_pos,
    input freq_down_trigger_i,
    input freq_up_trigger_i,

    output [7:0] data
);


wire signed [7:0] dds_wave;
wire [31:0] dds_phase;
wire dds_wave_valid;
wire [7:0] wave_data;
wire wave_data_valid;
wire wave_form_trigger;
wire db_wave_form_key;
wire [10:0] wr_addr;
wire wr_en;
wire [7:0] sample_data;
wire ram_sel;

SwitchDebounce SwitchDebounce_inst (
    .clk(sys_clk),
    .rst_n(rst_n),
    .sw(wave_form_key),
    .db_sw(db_wave_form_key)
  );

edge_detect  edge_detect_inst (
    .clk(sys_clk),
    .rst_n(rst_n),
    .level(db_wave_form_key),
    .type(1'b0),   // 1 = RISING, 0 = FALLING

    .tick(wave_form_trigger)
);

dds_core  dds_core_inst (
    .clk_i(sys_clk),
    .rst_n_i(rst_n),
    .frequency_i(frequency),
    .freq_down_trigger_i(freq_down_trigger_i),
    .freq_up_trigger_i(freq_up_trigger_i),
    .dds_wave(dds_wave),
    .dds_phase(dds_phase),
    .dds_wave_valid(dds_wave_valid)
  );

wave_sel wave_sel_inst (
    .clk_i(sys_clk),
    .rst_n_i(rst_n),
    .wave_form_trigger_i(wave_form_trigger),
    .dds_wave(dds_wave),
    .dds_wave_valid(dds_wave_valid),
    .dds_phase_i(dds_phase),
    .wave_data(wave_data),
    .wave_data_valid(wave_data_valid)
  );

dds_downsample #(
    .DIS_Y_END(255),
    .WR_ADDR_MAX(1023)
  )
  u_dds_down_sample(
    .clk(sys_clk),
    .rst_n(rst_n),
    .y_pos(y_pos),
    .wave_data(wave_data),
    .data_valid(wave_data_valid),

    .wr_addr(wr_addr),
    .wr_en(wr_en),
    .sample_data(sample_data),
    .ram_sel(ram_sel)          // 0: Write Ram1 | 1: Write Ram2

);

wave_frame_buffer # (
    .DIS_X_START(0),
    .DIS_X_END(1023)
  )
  wave_frame_buffer_inst (
    .clk(sys_clk),
    .wr_addr(wr_addr),
    .sample_data(sample_data),
    .wr_en(wr_en),
    .ram_sel(ram_sel),
    .x_pos(x_pos),
    .data(data)
  );
endmodule