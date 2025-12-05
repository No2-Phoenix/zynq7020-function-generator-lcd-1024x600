module text_display #(
    parameter X_START = 11'd50,
    parameter Y_START = 10'd310,

    parameter FONT_W  = 5,          // Font Width: 5 cols in freq_font_5x7
    parameter FONT_H  = 7,          // Font Height: 7 rows
    parameter SCALE   = 3           // Magnification factor (2/3/4)
)(
    input  [10:0] x_pos,
    input  [9:0]  y_pos,
    input  [6:0]  freq_num,         // Range: 20~50

    output        text_on
);

//=============Parameter Definition============//
// Calculate character width/height with scaling
// Add 1 pixel for spacing between characters (CHAR_W)
localparam CHAR_W  = FONT_W * SCALE + 1;
localparam CHAR_H  = FONT_H * SCALE;
localparam STR_LEN = 17;            // Length of "FREQUENCY: XX KHZ"

//=============Internal Signal Declaration===========//
wire [6:0] freq_clamp;
wire [3:0] freq_tens;
wire [3:0] freq_ones;
wire [7:0] ch_tens_ascii;
wire [7:0] ch_ones_ascii;

// Region and Coordinate signals
wire in_x;
wire in_y;
wire in_region;
wire [10:0] rel_x;
wire [9:0]  rel_y;
wire [4:0]  char_idx;
wire [7:0]  col_in_cell;
wire [7:0]  row_in_cell;

// Font Mapping signals
wire [2:0]  font_col;
wire [2:0]  font_row;
wire        col_in_glyph;
reg  [7:0]  curr_char;
wire [4:0]  row_bits;
wire        dot_on;

//==============ASCII Conversion===============//
// Clamp frequency between 20 and 50 to avoid overflow
assign freq_clamp = (freq_num < 7'd20) ? 7'd20 :
                    (freq_num > 7'd50) ? 7'd50 :
                    freq_num;

assign freq_tens = freq_clamp / 10;
assign freq_ones = freq_clamp % 10;

// Convert digits to ASCII
assign ch_tens_ascii = "0" + freq_tens;
assign ch_ones_ascii = "0" + freq_ones;

//==============Region Detect & Coord==========//
// Check if current position is within text area
assign in_x = (x_pos >= X_START) && (x_pos < X_START + STR_LEN * CHAR_W);
assign in_y = (y_pos >= Y_START) && (y_pos < Y_START + CHAR_H);
assign in_region = in_x & in_y;

// Calculate relative coordinates from the start of the text box
assign rel_x = x_pos - X_START;
assign rel_y = y_pos - Y_START;

// Calculate character index and internal cell position
assign char_idx    = rel_x / CHAR_W;    // Which character (0~16)
assign col_in_cell = rel_x % CHAR_W;    // Column inside the scaled char box
assign row_in_cell = rel_y % CHAR_H;    // Row inside the scaled char box

// Map scaled coordinates back to original font grid
assign font_col = col_in_cell / SCALE;
assign font_row = row_in_cell / SCALE;

// Check if column is within valid font width (handling spacing)
assign col_in_glyph = (font_col < FONT_W);

//==============Character Selection============//
// Select ASCII char based on index: "FREQUENCY: XX KHZ"
always @(*) begin
    case (char_idx)
        5'd0 : curr_char = "F";
        5'd1 : curr_char = "R";
        5'd2 : curr_char = "E";
        5'd3 : curr_char = "Q";
        5'd4 : curr_char = "U";
        5'd5 : curr_char = "E";
        5'd6 : curr_char = "N";
        5'd7 : curr_char = "C";
        5'd8 : curr_char = "Y";
        5'd9 : curr_char = ":";
        5'd10: curr_char = " ";
        5'd11: curr_char = ch_tens_ascii;
        5'd12: curr_char = ch_ones_ascii;
        5'd13: curr_char = " ";
        5'd14: curr_char = "K";
        5'd15: curr_char = "H";
        5'd16: curr_char = "Z";
        default: curr_char = " ";
    endcase
end

//==============Font Lookup & Output===========//
// Instantiate 5x7 Font Library
freq_font_5x7 u_font (
    .ascii (curr_char),
    .row   (font_row[2:0]),
    .bits  (row_bits)
);

// Determine if pixel should be lit
// Check column validity and bitmask (MSB is left)
assign dot_on = col_in_glyph && row_bits[FONT_W-1 - font_col];

assign text_on = in_region && dot_on;

endmodule