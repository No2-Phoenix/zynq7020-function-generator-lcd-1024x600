module dds_core(
    input clk_i,
    input rst_n_i,
    input [31:0] frequency_i,
    input freq_down_trigger_i,
    input freq_up_trigger_i,

    output signed [7:0] dds_wave,
    output [31:0] dds_phase,
    output dds_wave_valid
);
wire dds_phase_valid;
wire freq_config_en = freq_down_trigger_i || freq_up_trigger_i;

dds_compiler_0 u_dds (
  .aclk(clk_i),                                  // input wire aclk
  .s_axis_config_tvalid(freq_config_en),  // input wire s_axis_config_tvalid
  .s_axis_config_tdata(frequency_i),    // input wire [31 : 0] s_axis_config_tdata
  .m_axis_data_tvalid(dds_wave_valid),      // output wire m_axis_data_tvalid
  .m_axis_data_tdata(dds_wave),        // output wire [7 : 0] m_axis_data_tdata
  .m_axis_phase_tvalid(dds_phase_valid),    // output wire m_axis_phase_tvalid
  .m_axis_phase_tdata(dds_phase)      // output wire [31 : 0] m_axis_phase_tdata
);


endmodule