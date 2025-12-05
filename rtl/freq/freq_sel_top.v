module freq_sel_top (
    input clk_i,
    input rst_n_i,
    input freq_up_key_i,
    input freq_down_key_i,

    output [31:0] frequency_o,
    output freq_up_trigger_i,
    output freq_down_trigger_i,
    output [6:0] freq_num
);

//===========Internal Signal Declaration============//
wire db_freq_down_key_i;
wire db_freq_up_key_i;
wire freq_up_trigger;
wire freq_down_trigger;
wire [6:0] freq_num_o;

//===========Frequency Byte Enable Signal============//
assign freq_up_trigger_i = freq_up_trigger;
assign freq_down_trigger_i = freq_down_trigger;
assign freq_num = freq_num_o;
// DUT
SwitchDebounce SwitchDebounce_inst_down (
    .clk(clk_i),
    .rst_n(rst_n_i),
    .sw(freq_down_key_i),
    .db_sw(db_freq_down_key_i)
  );

SwitchDebounce SwitchDebounce_inst_up (
    .clk(clk_i),
    .rst_n(rst_n_i),
    .sw(freq_up_key_i),
    .db_sw(db_freq_up_key_i)
  );

edge_detect  edge_detect_inst_down (
    .clk(clk_i),
    .rst_n(rst_n_i),
    .level(db_freq_down_key_i),
    .type(1'b0),        //Falling Edge
    .tick(freq_down_trigger)
  );

edge_detect  edge_detect_inst_up (
    .clk(clk_i),
    .rst_n(rst_n_i),
    .level(db_freq_up_key_i),
    .type(1'b0),        //Falling Edge
    .tick(freq_up_trigger)
  );
freq_sel  freq_sel_inst (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .freq_up_trigger_i(freq_up_trigger),
    .freq_down_trigger_i(freq_down_trigger),
    .frequency_o(frequency_o),
    .freq_num(freq_num_o)
  );
endmodule