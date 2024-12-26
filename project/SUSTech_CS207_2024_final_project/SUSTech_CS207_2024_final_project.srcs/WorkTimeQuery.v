module WorkingTimeQuery(
    input clk,          
    input rst_n,
    input en,
    input [4:0] hour,
    input [5:0] min,
    input [5:0] sec,
    output reg [5:0] an, 
    output [7:0] seg1,
    output [7:0] seg2
);

    reg [2:0] digit_select;
    reg [3:0] current_digit;
    wire clk_div;

    Time_div time_div(.clk(clk),.rst_n(rst_n) ,.clk_div(clk_div));
    NumbertoTub decoder(.in_b4(current_digit), .tub_control(seg1));
    assign seg2 = seg1;

    always @(posedge clk_div or negedge rst_n) begin
        if (!rst_n) begin
            digit_select <= 0;
            current_digit <= 0;
            an <= 6'b000001;
        end else if (en) begin
            case (digit_select)
                3'd0: begin
                    current_digit <= hour / 10;
                    an <= 6'b100000;
                end
                3'd1: begin
                    current_digit <= hour % 10;
                    an <= 6'b010000;
                end
                3'd2: begin
                    current_digit <= min / 10;
                    an <= 6'b001000;
                end
                3'd3: begin
                    current_digit <= min % 10;
                    an <= 6'b000100;
                end
                3'd4: begin
                    current_digit <= sec / 10;
                    an <= 6'b000010;
                end
                3'd5: begin
                    current_digit <= sec % 10;
                    an <= 6'b000001;
                end
            endcase
            digit_select <= digit_select + 1;
        end
    end

endmodule
