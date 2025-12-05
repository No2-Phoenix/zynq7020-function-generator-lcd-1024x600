//===========
// Module Name:freq_sel
// Function   :Increase or Decrease Frenquency Byte based on the Input Key
// Author     :No.2
// Date       :2025/12/2
//===========

module freq_sel(
    input clk_i,      //50MHz
    input rst_n_i,
    input freq_up_trigger_i,
    input freq_down_trigger_i,
    
    output [31:0] frequency_o,
    output reg [5:0] freq_num
);

//============Parameter Definition============//
localparam FREQUENCY_MAX = 32'h0040A007;      //50KHz
localparam FREQUENCY_MIN = 32'h001A0803;        //20KHz
localparam FREQUENCY_RESOLUTION = 32'h00029D17;//2KHz

//==========Internal Signal Declaration============//
reg [31:0] freq;

//==========Frequency Calculation=============//
always @(posedge clk_i or negedge rst_n_i)begin
    if(!rst_n_i)begin
        freq <= FREQUENCY_MIN;      //Default Frequency
        freq_num <= 6'd20;
    end
    else begin
        if(freq_up_trigger_i && freq_down_trigger_i)begin
            freq <= freq;
            freq_num <= freq_num;
        end
        else if(freq_up_trigger_i)begin
            if(freq < FREQUENCY_MAX)begin
                freq <= freq + FREQUENCY_RESOLUTION;
                freq_num <= freq_num + 6'd2;
            end
        end
        else if(freq_down_trigger_i)begin
            if(freq > FREQUENCY_MIN)begin
                freq <= freq - FREQUENCY_RESOLUTION;
                freq_num <= freq_num - 2'd2;
            end
        end
    end
end

//==========Frenquency Output===========//
assign frequency_o = freq;


endmodule