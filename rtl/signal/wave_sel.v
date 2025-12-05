module wave_sel (
    input clk_i,
    input rst_n_i,
    input wave_form_trigger_i,
    input signed [7:0] dds_wave,
    input dds_wave_valid,
    input [31:0] dds_phase_i, 

    output reg [7:0] wave_data,
    output reg wave_data_valid
);
//============Paramter Definition============//
localparam SIN      = 2'd0;
localparam TRIANGLE = 2'd1;
localparam SAWTOOTH = 2'd2;
localparam SQUARE   = 2'd3;

//============Internal Signal Declaration=========//
wire [7:0] sin;
wire [7:0] sawtooth;
wire [7:0] triangle;
wire [7:0] square;
reg  [1:0] mode;         
wire [7:0] tri_phase_msb;

//===========Wave Generate===========//
//---------Sawtooth---------//
assign sawtooth = dds_phase_i[26:19];

//--------Triangle---------// 

assign tri_phase_msb = dds_phase_i[26:19];
assign triangle = (tri_phase_msb[7] == 1'b0) ? {tri_phase_msb[6:0], 1'b0} : (8'd255 - {tri_phase_msb[6:0], 1'b0});

//---------Square--------//
assign square = dds_wave[7] ? 8'd0 : 8'd255;

//----------Sin---------//
assign sin = dds_wave + 8'd128;

//============Wave Mode Select===========//
always @(posedge clk_i or negedge rst_n_i) begin
    if(!rst_n_i)
        mode <= 2'd0;
    else if(wave_form_trigger_i)
        mode <= mode + 2'd1;
end

always @(posedge clk_i or negedge rst_n_i) begin
    if(!rst_n_i) begin
        wave_data       <= 8'd0;
        wave_data_valid <= 1'b0;
    end 
    else if(dds_wave_valid) begin
        wave_data_valid <= 1'b1;
        case (mode)
            SIN:      wave_data <= sin;
            TRIANGLE: wave_data <= triangle;
            SAWTOOTH: wave_data <= sawtooth;
            SQUARE:   wave_data <= square;
            default:  wave_data <= sin;
        endcase
    end 
    else begin
        wave_data_valid <= 1'b0;
    end
end

endmodule
