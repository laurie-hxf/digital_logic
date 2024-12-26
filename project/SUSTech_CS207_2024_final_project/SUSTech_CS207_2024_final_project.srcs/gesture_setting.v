module gesture_setting(
    input set_gesture_time_en,
    input wire clk,
    input wire rst_n,
    input wire button,
    output reg [3:0] gesture_time,
    output reg [7:0] sel_en,
    output reg [7:0] seg1
);
    wire clkdiv;
    wire pos;
    ButtonDebounce #(
        .WIDTH(1),            
        .DEBOUNCE_TIME(12_000_000) 
   ) AddOne_button_debounce (
        .clk(clk),
        .rst_n(rst_n),
        .btn_in(button),
        .btn_out(pos)
    );
    TimeSplit timesplit(.clk(clk),.rst_n(rst_n),.clk_div(clkdiv));
    // Gesture time setting logic
    always @(posedge clkdiv or negedge rst_n) begin
        if (!rst_n) begin
            gesture_time <= 4'd5;
            sel_en <= 8'b1000_0000;
        end
         else if (set_gesture_time_en) begin
            if (pos) begin 
                if (gesture_time == 4'd7) begin
                    gesture_time <= 4'd2;
                end else begin
                    gesture_time <= gesture_time + 1;
                end
            end
        end
    end
    always @ * begin
        case(gesture_time)
            4'b0000: seg1 = 8'b1111_1100;  //"0" : abcdef_ _  
            4'b0001: seg1 = 8'b0110_0000; //"1":  _bc_ _ _ _ _ _
            4'b0010: seg1 = 8'b1101_1010; //"2": ab_de_g_ 
            4'b0011: seg1 = 8'b1111_0010;  //"3":  abcd_ _ g _
            4'b0100: seg1 = 8'b0110_0110; //"4": _bc _ _fg_
            4'b0101: seg1 = 8'b1011_0110;  //"5": a_cd_fg_
            4'b0110: seg1 = 8'b1011_1110; //"6": a_cdefg_
            4'b0111: seg1 = 8'b1110_0000; //"7": abc_ _ _ _ _
            4'b1000: seg1 = 8'b1111_1110; //"8": abcdefg_
            4'b1001: seg1 = 8'b1110_0110; //"9": abc_ _ fg_
            default: 
                seg1 = 8'b1001_1110;   //"E": a_ _ defg_
        endcase
    end
endmodule