module freq_font_5x7(
    input      [7:0] ascii,
    input      [2:0] row,   // Row index: 0~6
    output reg [4:0] bits   // 5 dots output: bit4=Left, bit0=Right
);

//=============Font Pattern Logic============//
// 5x7 Font Library
// Content: Digits 0-9, Space, Colon, and specific uppercase letters
// Mapping: bits[4] is the leftmost column, bits[0] is the rightmost column

    always @(*) begin
        bits = 5'b00000;
        case (ascii)
            //--------- Numbers 0~9 ----------
            "0": begin
                case (row)
                    3'd0: bits = 5'b01110;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b10001;
                    3'd3: bits = 5'b10001;
                    3'd4: bits = 5'b10001;
                    3'd5: bits = 5'b10001;
                    3'd6: bits = 5'b01110;
                    default: bits = 5'b00000;
                endcase
            end
            "1": begin
                case (row)
                    3'd0: bits = 5'b00100;
                    3'd1: bits = 5'b01100;
                    3'd2: bits = 5'b00100;
                    3'd3: bits = 5'b00100;
                    3'd4: bits = 5'b00100;
                    3'd5: bits = 5'b00100;
                    3'd6: bits = 5'b01110;
                    default: bits = 5'b00000;
                endcase
            end
            "2": begin
                case (row)
                    3'd0: bits = 5'b01110;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b00001;
                    3'd3: bits = 5'b00110;
                    3'd4: bits = 5'b01000;
                    3'd5: bits = 5'b10000;
                    3'd6: bits = 5'b11111;
                    default: bits = 5'b00000;
                endcase
            end
            "3": begin
                case (row)
                    3'd0: bits = 5'b01110;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b00001;
                    3'd3: bits = 5'b00110;
                    3'd4: bits = 5'b00001;
                    3'd5: bits = 5'b10001;
                    3'd6: bits = 5'b01110;
                    default: bits = 5'b00000;
                endcase
            end
            "4": begin
                case (row)
                    3'd0: bits = 5'b00010;
                    3'd1: bits = 5'b00110;
                    3'd2: bits = 5'b01010;
                    3'd3: bits = 5'b10010;
                    3'd4: bits = 5'b11111;
                    3'd5: bits = 5'b00010;
                    3'd6: bits = 5'b00010;
                    default: bits = 5'b00000;
                endcase
            end
            "5": begin
                case (row)
                    3'd0: bits = 5'b11111;
                    3'd1: bits = 5'b10000;
                    3'd2: bits = 5'b11110;
                    3'd3: bits = 5'b00001;
                    3'd4: bits = 5'b00001;
                    3'd5: bits = 5'b10001;
                    3'd6: bits = 5'b01110;
                    default: bits = 5'b00000;
                endcase
            end
            "6": begin
                case (row)
                    3'd0: bits = 5'b00110;
                    3'd1: bits = 5'b01000;
                    3'd2: bits = 5'b10000;
                    3'd3: bits = 5'b11110;
                    3'd4: bits = 5'b10001;
                    3'd5: bits = 5'b10001;
                    3'd6: bits = 5'b01110;
                    default: bits = 5'b00000;
                endcase
            end
            "7": begin
                case (row)
                    3'd0: bits = 5'b11111;
                    3'd1: bits = 5'b00001;
                    3'd2: bits = 5'b00010;
                    3'd3: bits = 5'b00100;
                    3'd4: bits = 5'b01000;
                    3'd5: bits = 5'b01000;
                    3'd6: bits = 5'b01000;
                    default: bits = 5'b00000;
                endcase
            end
            "8": begin
                case (row)
                    3'd0: bits = 5'b01110;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b10001;
                    3'd3: bits = 5'b01110;
                    3'd4: bits = 5'b10001;
                    3'd5: bits = 5'b10001;
                    3'd6: bits = 5'b01110;
                    default: bits = 5'b00000;
                endcase
            end
            "9": begin
                case (row)
                    3'd0: bits = 5'b01110;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b10001;
                    3'd3: bits = 5'b01111;
                    3'd4: bits = 5'b00001;
                    3'd5: bits = 5'b00010;
                    3'd6: bits = 5'b01100;
                    default: bits = 5'b00000;
                endcase
            end

            //--------- Space ----------
            " ": begin
                bits = 5'b00000;
            end

            //--------- Colon ':' ----------
            ":": begin
                case (row)
                    3'd0: bits = 5'b00000;
                    3'd1: bits = 5'b00100;
                    3'd2: bits = 5'b00100;
                    3'd3: bits = 5'b00000;
                    3'd4: bits = 5'b00100;
                    3'd5: bits = 5'b00100;
                    3'd6: bits = 5'b00000;
                    default: bits = 5'b00000;
                endcase
            end

            //--------- Uppercase Letters: F,R,E,Q,U,N,C,Y,K,H,Z ----------
            "F": begin
                case (row)
                    3'd0: bits = 5'b11111;
                    3'd1: bits = 5'b10000;
                    3'd2: bits = 5'b11110;
                    3'd3: bits = 5'b10000;
                    3'd4: bits = 5'b10000;
                    3'd5: bits = 5'b10000;
                    3'd6: bits = 5'b10000;
                    default: bits = 5'b00000;
                endcase
            end

            "R": begin
                case (row)
                    3'd0: bits = 5'b11110;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b10001;
                    3'd3: bits = 5'b11110;
                    3'd4: bits = 5'b10100;
                    3'd5: bits = 5'b10010;
                    3'd6: bits = 5'b10001;
                    default: bits = 5'b00000;
                endcase
            end

            "E": begin
                case (row)
                    3'd0: bits = 5'b11111;
                    3'd1: bits = 5'b10000;
                    3'd2: bits = 5'b11110;
                    3'd3: bits = 5'b10000;
                    3'd4: bits = 5'b10000;
                    3'd5: bits = 5'b10000;
                    3'd6: bits = 5'b11111;
                    default: bits = 5'b00000;
                endcase
            end

            "Q": begin
                case (row)
                    3'd0: bits = 5'b01110;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b10001;
                    3'd3: bits = 5'b10001;
                    3'd4: bits = 5'b10101;
                    3'd5: bits = 5'b10011;
                    3'd6: bits = 5'b01111;
                    default: bits = 5'b00000;
                endcase
            end

            "U": begin
                case (row)
                    3'd0: bits = 5'b10001;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b10001;
                    3'd3: bits = 5'b10001;
                    3'd4: bits = 5'b10001;
                    3'd5: bits = 5'b10001;
                    3'd6: bits = 5'b01110;
                    default: bits = 5'b00000;
                endcase
            end

            "N": begin
                case (row)
                    3'd0: bits = 5'b10001;
                    3'd1: bits = 5'b11001;
                    3'd2: bits = 5'b10101;
                    3'd3: bits = 5'b10011;
                    3'd4: bits = 5'b10001;
                    3'd5: bits = 5'b10001;
                    3'd6: bits = 5'b10001;
                    default: bits = 5'b00000;
                endcase
            end

            "C": begin
                case (row)
                    3'd0: bits = 5'b01110;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b10000;
                    3'd3: bits = 5'b10000;
                    3'd4: bits = 5'b10000;
                    3'd5: bits = 5'b10001;
                    3'd6: bits = 5'b01110;
                    default: bits = 5'b00000;
                endcase
            end

            "Y": begin
                case (row)
                    3'd0: bits = 5'b10001;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b01010;
                    3'd3: bits = 5'b00100;
                    3'd4: bits = 5'b00100;
                    3'd5: bits = 5'b00100;
                    3'd6: bits = 5'b00100;
                    default: bits = 5'b00000;
                endcase
            end

            "K": begin
                case (row)
                    3'd0: bits = 5'b10001;
                    3'd1: bits = 5'b10010;
                    3'd2: bits = 5'b10100;
                    3'd3: bits = 5'b11000;
                    3'd4: bits = 5'b10100;
                    3'd5: bits = 5'b10010;
                    3'd6: bits = 5'b10001;
                    default: bits = 5'b00000;
                endcase
            end

            "H": begin
                case (row)
                    3'd0: bits = 5'b10001;
                    3'd1: bits = 5'b10001;
                    3'd2: bits = 5'b10001;
                    3'd3: bits = 5'b11111;
                    3'd4: bits = 5'b10001;
                    3'd5: bits = 5'b10001;
                    3'd6: bits = 5'b10001;
                    default: bits = 5'b00000;
                endcase
            end

            "Z": begin
                case (row)
                    3'd0: bits = 5'b11111;
                    3'd1: bits = 5'b00001;
                    3'd2: bits = 5'b00010;
                    3'd3: bits = 5'b00100;
                    3'd4: bits = 5'b01000;
                    3'd5: bits = 5'b10000;
                    3'd6: bits = 5'b11111;
                    default: bits = 5'b00000;
                endcase
            end

            default: begin
                bits = 5'b00000;
            end
        endcase
    end
endmodule