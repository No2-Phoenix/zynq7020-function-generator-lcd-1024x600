module dds_downsample #(
    parameter DIS_Y_END = 255,
    parameter WR_ADDR_MAX = 1023
)(
    input clk,
    input rst_n,
    input [9:0] y_pos,
    input [7:0] wave_data,
    input data_valid,
    input [6:0] freq_num,

    output reg [10:0] wr_addr,
    output wr_en,
    output [7:0] sample_data,
    output reg ram_sel          // 0: Write Ram1 | 1: Write Ram2

);

//=============Parameter Definition============//
localparam DIV_NUM = 0;      // How much clock cycles are delayed to sample
localparam TRIG_LEVEL = 8'd128; // Determines from what phase of data the current frame is written
localparam FRAME_HOLD_NUM = 6;

//==============FSM State Definition==========//
localparam [1:0] S_WAIT_TRIG = 2'd0;    // Wait for Capturing data
localparam [1:0] S_CAPTURE = 2'd1;      // Capture data for one frame
localparam [1:0] S_HOLD = 2'd2;         // Hold to display the current frame

//=============Internal Signal Declaration===========//
wire sample_en;             // 1: Allow to Sample | 0 : Not Allowed to Sample
reg [2:0] sample_cnt;      // Count the  clock cycles for delaying
reg [7:0] pre_wave;         // Save the previous data to compare with the current data to detect the phase
wire trig_en;                // 1 : The current data phase is satisficated to be the beginng of the frame | 0 : Not satisficated
wire frame_end;               // 1 : Y is more than display area
reg frame_end_pre;           // 1 : Y is more than display area at the previous time
wire frame_new;               // 1: The new frame is coming
reg [2:0] frame_hold_cnt;       // The number of frame to hold
reg [1:0] state;                // FSM state
wire cap_en;                     // 1 : The data is allowed to write to the ram

//==============Frequency Division Sample=============//
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        sample_cnt <= 3'd0;
    end
    else if (sample_cnt == DIV_NUM)begin
        sample_cnt <= 3'd0;
    end
    else begin
        sample_cnt <= sample_cnt + 3'd1;
    end
end
assign sample_en = (sample_cnt == DIV_NUM) ? 1'b1 : 1'b0;

//=============Data Phase Detect===============//
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        pre_wave <= 8'd0;
    end
    else begin
        pre_wave <= wave_data;
    end
end
assign trig_en = (data_valid && (pre_wave < TRIG_LEVEL) && (wave_data >= TRIG_LEVEL));

//===============Frame Detect==============//
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        frame_end_pre <= 1'b0;
    end
    else begin
        frame_end_pre <= frame_end;
    end
end
assign frame_end = (y_pos > DIS_Y_END);
assign frame_new = ((!frame_end) && (frame_end_pre));

//==============FSM to Capure Data=============//
assign cap_en = (state == S_CAPTURE) && data_valid && sample_en;
assign wr_en = cap_en;
assign sample_data = wave_data;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        ram_sel <= 1'b0;
        wr_addr <= 10'd0;
        frame_hold_cnt <= 3'd0;
        state <= S_WAIT_TRIG;
    end
    else begin
        case(state)
        S_WAIT_TRIG:begin
            wr_addr <= 10'd0;
            frame_hold_cnt <= 3'd0;
            if(trig_en)begin
                state <= S_CAPTURE;
            end
        end
        S_CAPTURE:begin
            if(cap_en)begin
                if(wr_addr == WR_ADDR_MAX)begin
                    wr_addr <= 10'd0;
                    state <= S_HOLD;
                    frame_hold_cnt <= 3'd0;
                    ram_sel <= ~ram_sel;
                end
                else begin
                    wr_addr <= wr_addr + 10'd1;
                end
            end
        end
        S_HOLD:begin
            if(frame_new)begin
                if(frame_hold_cnt == FRAME_HOLD_NUM)begin
                    frame_hold_cnt <= 3'd0;
                    state <= S_WAIT_TRIG;
                end
                else begin
                    frame_hold_cnt <= frame_hold_cnt + 8'd1;
                end
            end
        end
        default:begin
            state <= S_WAIT_TRIG;
        end
        endcase
    end

end


endmodule