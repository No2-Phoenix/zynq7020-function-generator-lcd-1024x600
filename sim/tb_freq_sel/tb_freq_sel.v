`timescale 1ns/1ns

module freq_sel_top_tb;

    //-------------------------------------------------------------------------
    // DUT Ports
    //-------------------------------------------------------------------------
    reg         clk_i;
    reg         rst_n_i;
    reg         freq_up_key_i;
    reg         freq_down_key_i;
    wire [31:0] frequency_o;

    //-------------------------------------------------------------------------
    // Clock generation : 50 MHz (period 20ns)
    //-------------------------------------------------------------------------
    initial clk_i = 1'b0;
    always #10 clk_i = ~clk_i;

    //-------------------------------------------------------------------------
    // Initial
    //-------------------------------------------------------------------------
    initial begin
        clk_i           = 1'b0;
        rst_n_i         = 1'b0;
        freq_up_key_i   = 1'b1;   // 松开状态 (active-low)
        freq_down_key_i = 1'b1;

        // 复位
        #50;
        rst_n_i = 1'b1;

        // 等一点再按键
        #200;
        // 按下"下降"按键，按住 50us (50000 ns)
        freq_up_key_i = 1'b0;

        #5000;
        // 按下"上升"按键，按住 30us
        freq_up_key_i = 1'b1;

        #2000;
        freq_down_key_i = 1'b0;
        #5000;
        freq_down_key_i = 1'b1;
        #1000;
        $stop;
    end

    //-------------------------------------------------------------------------
    // DUT instance
    //-------------------------------------------------------------------------
    freq_sel_top dut (
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .freq_up_key_i(freq_up_key_i),
        .freq_down_key_i(freq_down_key_i),
        .frequency_o(frequency_o)
    );

endmodule
