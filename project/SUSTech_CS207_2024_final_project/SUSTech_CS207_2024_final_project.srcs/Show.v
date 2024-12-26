module Show (
    input wire clk,
    input wire rst_n,
    input wire select,
    input [3:0] state,//��ʾ����ʱ��0111����ʾ����ʱ����??0101����ʾ�ۼƹ���ʱ??1100����ʾ��ǰʱ??0001
    input [7:0] gesture_sel_en,
    input [7:0] gesture_seg1,
    input [7:0] work_limit_an,
    input [7:0] work_limit_seg1,
    input [7:0] work_limit_seg2,
    input [5:0] clock_an,
    input [7:0] working_seg1,
    input [7:0] working_seg2,
    input [7:0] mode,
    input [7:0] mode_name,
    input [1:0] tubsel,
    input [1:0] number_select,
    input [2:0] clean_select,
    input reminder,
    input [5:0]set_time_an,
    input [7:0] set_time_seg1,
    input [7:0] set_time_seg2,
    output reg[7:0]sel_en,
    output reg[7:0]seg1,
    output reg[7:0] seg2
);
    // 7-segment display encoding for digits 0-9
    reg[3:0]d1;
    reg[3:0]d2;
    reg[3:0]d3;
    reg[3:0]d4;
    reg[3:0]d5;
    reg[3:0]d6;
    reg[3:0]d7;
    reg[3:0]d8;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sel_en <= 8'b00000000;
            seg1 <= 8'b00000000;
            seg2 <= 8'b00000000;
        end else begin
            case (state)
                4'b0111: begin // Display gesture time
                    //TODO
                    sel_en<=gesture_sel_en;
                    seg1<=gesture_seg1;
                    seg2<=8'b0000_0000;
                end
                4'b0101: begin // Display working limit
                    //TODO
                    sel_en<=work_limit_an;
                    seg1<=work_limit_seg1;
                    seg2<=work_limit_seg2;
                end
                4'b1100: begin // Display cumulative working time
                    //TODO
                    sel_en<=clock_an;
                    seg1<=working_seg1;
                    seg2<=working_seg2;
                end
                4'b0001: begin // Display current time
                    sel_en<={2'b00,set_time_an};
                    seg1<=set_time_seg1;
                    seg2<=set_time_seg2;
                end
                4'b0011: begin
                    sel_en<={tubsel[1],clean_select,1'b0,number_select,tubsel[0]};
                    seg1<=mode;
                    seg2<=mode_name;
                end
                4'b0100:begin
                    sel_en<={2'b00,set_time_an};
                    seg1<=set_time_seg1;
                    seg2<=set_time_seg2;
                end

                default: begin
                    sel_en <= 8'b00000000;
                    seg1 <= 8'b00000000;
                    seg2 <= 8'b00000000;
                end
            endcase
        end
    end

endmodule
