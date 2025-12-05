module lcd_display (
    input           lcd_pclk,
    input           rst_n,

    input   [10:0]  pixel_xpos,  
    input   [9:0]   pixel_ypos, 
    input   [6:0]   freq_num,
    input   [7:0]   dds_wave_data,    

    output reg  [23:0]  pixel_data   
);

//============Parameter Definition============//
//-------Color----------//
localparam BACKGROUND_COLOR = 24'h000000;  // Black
localparam GRID_COLOR       = 24'h404040;  // Grey
localparam WAVE_COLOR       = 24'h00FF00;  // Green
localparam AXIS_COLOR       = 24'hFFFFFF;  // White

//-------Screen Parameter-----//
localparam DIS_X_START = 0;
localparam DIS_Y_START = 0;
localparam DIS_X_END   = 1023;
localparam DIS_Y_END   = 255;

//-------Line Thickness-------//
localparam LINE_THICKNESS = 10'd3; //2 * LINE_THICKNESS + 1

//=============Internal Signal Declaration==========//

wire [9:0]  current_wave_y;  
reg  [9:0]  prev_wave_y;     
reg  [9:0]  val_min, val_max;
wire freq_text_on; 

//============Display Logic=============//
//---------Text--------//
text_display #(
    .X_START(11'd80),
    .Y_START(10'd310),
    .SCALE  (3)         
) u_text_display (
    .x_pos   (pixel_xpos),
    .y_pos   (pixel_ypos),
    .freq_num(freq_num),
    .text_on (freq_text_on)
);


assign current_wave_y = dds_wave_data;

always @(posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n) 
        prev_wave_y <= 10'd0;
    else
        prev_wave_y <= current_wave_y; 
end

always @(*) begin
    if(current_wave_y >= prev_wave_y) begin
        val_min = prev_wave_y;
        val_max = current_wave_y;
    end else begin
        val_min = current_wave_y;
        val_max = prev_wave_y;
    end
end

always @(posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n) begin
        pixel_data <= BACKGROUND_COLOR;
    end
    else begin
        pixel_data <= BACKGROUND_COLOR;

        // Grid
        if((pixel_xpos % 50 == 0) || (pixel_ypos % 50 == 0))
            pixel_data <= GRID_COLOR;

        // Axis
        if(pixel_xpos == DIS_X_START || pixel_ypos == DIS_Y_START)
            pixel_data <= AXIS_COLOR;

        // Wave
        if(pixel_xpos >= DIS_X_START && pixel_xpos <= DIS_X_END) begin
            if( (pixel_ypos + LINE_THICKNESS >= val_min) && 
                (pixel_ypos <= val_max + LINE_THICKNESS) ) begin
                pixel_data <= WAVE_COLOR;
            end
        end
        
        //Text
        if (freq_text_on) begin
            pixel_data <= 24'hFFFFFF;  
        end
    end
end

endmodule