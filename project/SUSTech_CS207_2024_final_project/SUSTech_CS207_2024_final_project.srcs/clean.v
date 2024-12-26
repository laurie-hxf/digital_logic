module clean(
    input clk,            // 100 MHz ʱ������
    input rst_n,          // ��λ�źţ�����Ч
    input enable,
    output reg[7:0] seg,
    output reg[2:0] an,       // �����ѡ���ź�
    input jumpout,
    output reg jumpout_out=1'b0
);

    reg [27:0] clk_div;    // ����ʱ�ӷ�Ƶ��100 MHz -> 1 Hz
    reg [7:0] sec=8'd0;         // ����
    wire [3:0]ge_wei;
    wire [3:0]shi_wei;
    reg [3:0] min=4'd3;         // ������
    reg [1:0] state=2'b0;       // ��ǰ״̬����ʾ���ӻ�������

    // ��Ƶ����100 MHz -> 1 Hz��ÿ��һ�Σ�
    always @(posedge clk ) begin
        if (!rst_n)begin
            clk_div <= 27'd0;
        end
        if (enable)begin
            if(clk_div == 27'd99999999)begin // ��Ƶ���ӣ�100,000,000
                clk_div <= 27'd0;
            end
            else begin
                clk_div <= clk_div + 1;
            end
        end
        else begin
            clk_div <= 27'd0;
         end
    end

    // ����ʱ�߼�
    always @(posedge clk) begin
        if (!rst_n) begin
            sec <= 8'd0;
            min <= 4'd3;  // ��ʼ180�룬3����
        end 
        if(enable) begin
            if (clk_div == 27'd99999999) begin
                if (sec == 8'd0) begin
                    if (min == 4'd0)begin
                        sec <= 8'd0;  // ����ʱ����
                        jumpout_out <=1'b1;
                    end
                    else begin
                        min <= min - 1;
                        sec <= 8'd59;
                    end
                end else begin
                    sec <= sec - 1;
                end
            end
        end
        else begin
            sec <= 8'd0;
            min <= 4'd3;  // ��ʼ180�룬3����
            jumpout_out <=1'b0;
        end
    end

    assign ge_wei = sec % 10;
    assign shi_wei = sec / 10;

    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;

    // ����������������Ӻ�����ת��Ϊ7����ʾ����
    seven_seg_display ge_wei_disp(
        .digit(ge_wei),    // ��λ
        .seg(seg1)
    );

    seven_seg_display shi_wei_disp(
        .digit(shi_wei),    // ʮλ
        .seg(seg2)
    );

    seven_seg_display min_disp(
        .digit(min),    // ����
        .seg(seg3)
    );


    reg clkout;
    reg [31:0] cnt;
    parameter period=200000;
    always @(posedge clk) begin
        if(enable)begin
            if(cnt == (period >> 1)-1) begin
                clkout <= ~clkout;
                cnt <=0;
            end
            else cnt <=cnt+1;
        end
        else begin
            cnt<=0;
            clkout<=0;
        end

    end

    // �����ѡ��ѡ����ʾ���������
    always @(posedge clkout) begin
        if(state==2'd3)begin
            state <= 2'd0;
        end
        else begin
            state <= state + 1; // ÿ���л���ʾ���������
        end
    end

    // ��ʾ�߼����л���ʾ��
    always @(state) begin
        if(enable)begin
            case(state)
                2'd0: begin
                      an = 3'b001;  //��ʾ��λ
                      seg=seg1;
                end
                2'd1: begin
                      an = 3'b010;  //��ʾʮλ
                      seg=seg2;
                end
                2'd2: begin
                      an = 3'b100;  //��ʾ����
                      seg=seg3;
                end
                default: an = 3'b000;
            endcase
        end

        else begin
            an = 3'b000;
            seg = 8'd0;
        end
    end

endmodule

// 7���������ʾ����
module seven_seg_display(
    input [3:0] digit,    // ��������
    output reg [7:0] seg  // 7���������ʾ�ź�
);
    always @(*) begin
        case(digit)
            4'b0000: seg = 8'b1111_1100; // 0
            4'b0001: seg = 8'b0110_0000; // s
            4'b0010: seg = 8'b1101_1010; // 2
            4'b0011: seg = 8'b1111_0010; // 3
            4'b0100: seg = 8'b0110_0110; // 4
            4'b0101: seg = 8'b1011_0110; // 5
            4'b0110: seg = 8'b1011_1110; // 6
            4'b0111: seg = 8'b1110_0000; // 7
            4'b1000: seg = 8'b1111_1110; // 8
            4'b1001: seg = 8'b1111_0110; // 9
            default: seg = 8'b0000_0000; // Ĭ�Ϲر����ж�
        endcase
    end
endmodule
