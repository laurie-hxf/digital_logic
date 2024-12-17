module countdown_timer(
    input clk,            // 100 MHz 时钟输入
    input rst_n,          // 复位信号，低有效
    output [7:0] seg1,    // 数码管显示秒数
    output [7:0] seg2,    // 数码管显示分钟
    output [3:0] an       // 数码管选择信号
);

    reg [27:0] clk_div;    // 用于时钟分频，100 MHz -> 1 Hz
    reg [7:0] sec;         // 秒数
    reg [7:0] min;         // 分钟数
    reg [3:0] state;       // 当前状态（显示分钟或秒数）

    // 分频器：100 MHz -> 1 Hz（每秒一次）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 0;
        else if (clk_div == 99999999) // 分频因子：100,000,000
            clk_div <= 0;
        else
            clk_div <= clk_div + 1;
    end

    // 倒计时逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sec <= 59;
            min <= 3;  // 初始180秒，3分钟
        end else if (clk_div == 99999999) begin
            if (sec == 0) begin
                if (min == 0)
                    sec <= 0;  // 倒计时结束
                else begin
                    min <= min - 1;
                    sec <= 59;
                end
            end else begin
                sec <= sec - 1;
            end
        end
    end

    // 数码管驱动：将分钟和秒数转换为7段显示编码
    seven_seg_display sec_disp(
        .digit(sec[3:0]),    // 秒数（低4位）
        .seg(seg1)
    );

    seven_seg_display min_disp(
        .digit(min[3:0]),    // 分钟（低4位）
        .seg(seg2)
    );

    // 数码管选择：选择显示秒数或分钟
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= 0;
        else
            state <= state + 1; // 每次切换显示秒数或分钟
    end

    // 显示逻辑（切换显示）
    always @(state) begin
        case(state)
            4'd0: an = 4'b1110; // 显示秒数
            4'd1: an = 4'b1101; // 显示分钟
            default: an = 4'b1111;
        endcase
    end

endmodule

// 7段数码管显示驱动
module seven_seg_display(
    input [3:0] digit,    // 输入数字
    output reg [7:0] seg  // 7段数码管显示信号
);
    always @(*) begin
        case(digit)
            4'b0000: seg = 8'b1111_1100; // 0
            4'b0001: seg = 8'b0110_0000; // 1
            4'b0010: seg = 8'b1101_1010; // 2
            4'b0011: seg = 8'b1111_0010; // 3
            4'b0100: seg = 8'b0110_0110; // 4
            4'b0101: seg = 8'b1011_0110; // 5
            4'b0110: seg = 8'b1011_1110; // 6
            4'b0111: seg = 8'b1110_0000; // 7
            4'b1000: seg = 8'b1111_1110; // 8
            4'b1001: seg = 8'b1111_0110; // 9
            default: seg = 8'b0000_0001; // 默认关闭所有段
        endcase
    end
endmodule
