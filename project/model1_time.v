module vga_display(
    input clk,                   // 系统时钟
    input [5:0] hour,            // 小时（6位，最大为 23）
    input [5:0] min,             // 分钟（6位，最大为 59）
    input [5:0] sec,             // 秒（6位，最大为 59）
    output [2:0] disp_RGB,       // VGA 显示数据
    output hsync,                // VGA 行同步信号
    output vsync                 // VGA 场同步信号
);

// 定义字符点阵：数字字符 '0' 到 '9'
reg [7:0] digit_0[7:0] = {
    8'b11111100, 
    8'b10000010, 
    8'b10000010, 
    8'b10000010, 
    8'b10000010, 
    8'b10000010, 
    8'b11111100, 
    8'b00000000
    };
reg [7:0] digit_1[7:0] = {
    8'b00011000, 
    8'b00111000, 
    8'b00011000, 
    8'b00011000, 
    8'b00011000, 
    8'b00011000, 
    8'b00111100, 
    8'b00000000
    };
reg [7:0] digit_2[7:0] = {
    8'b11111100, 
    8'b10000010, 
    8'b00000010, 
    8'b00000010, 
    8'b00111000, 
    8'b01000000, 
    8'b11111110, 
    8'b00000000
    };
reg [7:0] digit_3[7:0] = {
    8'b11111100, 
    8'b10000010, 
    8'b00000010, 
    8'b11111110, 
    8'b00000010, 
    8'b10000010, 
    8'b11111100, 
    8'b00000000
};
reg [7:0] digit_4[7:0] = {
    8'b00000110, 
    8'b00001110, 
    8'b00010110, 
    8'b00100110, 
    8'b11111110, 
    8'b00000110, 
    8'b00000110, 
    8'b00000000
};
reg [7:0] digit_5[7:0] = {
    8'b11111110, 
    8'b10000000, 
    8'b10000000, 
    8'b11111100, 
    8'b00000010, 
    8'b00000010, 
    8'b11111100, 
    8'b00000000
};
reg [7:0] digit_6[7:0] = {
    8'b01111110, 
    8'b10000000, 
    8'b10000000, 
    8'b11111100, 
    8'b10000010, 
    8'b10000010, 
    8'b01111100, 
    8'b00000000
};
reg [7:0] digit_7[7:0] = {
    8'b11111110, 
    8'b00000010, 
    8'b00000110, 
    8'b00001100, 
    8'b00011000, 
    8'b00110000, 
    8'b01100000, 
    8'b00000000
};
reg [7:0] digit_8[7:0] = {
    8'b11111100, 
    8'b10000010, 
    8'b10000010, 
    8'b11111100, 
    8'b10000010, 
    8'b10000010, 
    8'b11111100, 
    8'b00000000
};
reg [7:0] digit_9[7:0] = {
    8'b11111100, 
    8'b10000010, 
    8'b10000010, 
    8'b11111110, 
    8'b00000010, 
    8'b10000010, 
    8'b11111100, 
    8'b00000000
};

// 定义字符 "model1"
reg [7:0] char_m[7:0] = {
    8'b10000001, 
    8'b11000011,
    8'b10100101, 
    8'b10100101,
    8'b10100101, 
    8'b10111101, 
    8'b10000001, 
    8'b10000001
};

reg [7:0] char_o[7:0] = {
    8'b01111110, 
    8'b10000001, 
    8'b10000001, 
    8'b10000001,
    8'b10000001, 
    8'b10000001, 
    8'b10000001, 
    8'b01111110
};

reg [7:0] char_d[7:0] = {
    8'b11111110, 
    8'b10000001, 
    8'b10000001, 
    8'b10000001,
    8'b10000001, 
    8'b10000001, 
    8'b11111110, 
    8'b00000000
};

reg [7:0] char_e[7:0] = {
    8'b11111111, 
    8'b10000000, 
    8'b11111110, 
    8'b10000000,
    8'b10000000, 
    8'b10000000, 
    8'b11111111, 
    8'b00000000
};

reg [7:0] char_l[7:0] = {
    8'b10000000, 
    8'b10000000, 
    8'b10000000, 
    8'b10000000,
    8'b10000000, 
    8'b10000000, 
    8'b10000000, 
    8'b11111111
};

reg [7:0] char_1[7:0] = {
    8'b00011000, 
    8'b00111000, 
    8'b00011000, 
    8'b00011000, 
    8'b00011000, 
    8'b00011000, 
    8'b00111100, 
    8'b00000000
};

// 时钟分频器和时序参数保持不变（见之前的代码）
parameter hsync_end   = 10'd95,
          hdat_begin  = 10'd143,
          hdat_end    = 10'd783,
          hpixel_end  = 10'd799,
          vsync_end   = 10'd1,
          vdat_begin  = 10'd34,
          vdat_end    = 10'd514,
          vline_end   = 10'd524;

reg [9:0] hcount;  // VGA 行扫描计数器
reg [9:0] vcount;  // VGA 场扫描计数器
reg vga_clk = 0;    // VGA 时钟信号
reg cnt_clk = 0;    // 分频计数器
reg [7:0] current_row; // 当前显示字符的行数据

// 时钟分频器：将 100MHz 的时钟分频为 VGA 时钟
always @(posedge clk) begin
    if (cnt_clk == 1) begin
        vga_clk <= ~vga_clk;
        cnt_clk <= 0;
    end else begin
        cnt_clk <= cnt_clk + 1;
    end
end
// 行扫描
always @(posedge vga_clk) begin
    if (hcount == hpixel_end) 
        hcount <= 0;
    else
        hcount <= hcount + 1;
end

// 场扫描
always @(posedge vga_clk) begin
    if (hcount == hpixel_end) begin
        if (vcount == vline_end) 
            vcount <= 0;
        else
            vcount <= vcount + 1;
    end
end

// 生成同步信号
assign hsync = (hcount < hsync_end);
assign vsync = (vcount < vsync_end);

// 显示时间的数字：hour[5:0]、min[5:0] 和 sec[5:0] 转为字符
reg [7:0] current_digit[7:0];
reg [3:0] char_x, char_y;

// 显示逻辑：决定是显示 "model1" 字符，还是时间数字
always @(*) begin
    if (char_x < 6) begin  // 显示 "model1" 字符
        case (char_x)
            0: current_digit = char_m[char_y]; // "m"
            1: current_digit = char_o[char_y]; // "o"
            2: current_digit = char_d[char_y]; // "d"
            3: current_digit = char_e[char_y]; // "e"
            4: current_digit = char_l[char_y]; // "l"
            5: current_digit = char_1[char_y]; // "1"
            default: current_digit = 8'b0; // 空白
        endcase
    end else if (char_x == 6 || char_x == 7) begin  // 显示时间的数字
        case (char_x - 6)  // 处理右侧的时间部分（分钟和秒）
            0: current_digit = digit_0; // 显示小时的第一位数字
            1: current_digit = digit_1; // 显示小时的第二位数字
            // 可以继续处理分钟和秒的数字
            2: current_digit = 
            default: current_digit = 8'b0; // 空白
        endcase
    end else begin
        current_digit = 8'b0; // 空白
    end
end

// 显示字符逻辑与之前一样，计算每个像素的 RGB 值
assign disp_RGB = current_digit[7 - bit_x] ? 3'h7 : 3'h0;
assign hsync = (hcount < hsync_end);
assign vsync = (vcount < vsync_end);

endmodule