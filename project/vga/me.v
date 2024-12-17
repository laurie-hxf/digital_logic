module project(
input clk, // 系统时钟
output [2:0] disp_RGB, // VGA 显示数据
output test,
output hsync, // VGA 行同步信号
output vsync // VGA 场同步信号
);

// VGA 行、场扫描时序参数
parameter hsync_end = 10'd95,
hdat_begin = 10'd143,
hdat_end = 10'd783,
hpixel_end = 10'd799,
vsync_end = 10'd1,
vdat_begin = 10'd34,
vdat_end = 10'd514,
vline_end = 10'd524;

reg [9:0] hcount; // VGA 行扫描计数器
reg [9:0] vcount; // VGA 场扫描计数器
reg vga_clk = 0; // VGA 时钟信号
reg cnt_clk = 0; // 分频计数器
reg [7:0] current_row; // 当前显示字符的行数据

// 8x8 字符点阵图定义
// 手动分配每个字符的点阵图
reg [7:0] char_m[7:0];
reg [7:0] char_o[7:0];
reg [7:0] char_d[7:0];
reg [7:0] char_e[7:0];
reg [7:0] char_l[7:0];
reg [7:0] char_1[7:0];

initial begin
    // 字符 "m"
    char_m[0] = 8'b10000001;
    char_m[1] = 8'b11000011;
    char_m[2] = 8'b10100101;
    char_m[3] = 8'b10100101;
    char_m[4] = 8'b10100101;
    char_m[5] = 8'b10111101;
    char_m[6] = 8'b10000001;
    char_m[7] = 8'b10000001;

    // 字符 "o"
    char_o[0] = 8'b01111110;
    char_o[1] = 8'b10000001;
    char_o[2] = 8'b10000001;
    char_o[3] = 8'b10000001;
    char_o[4] = 8'b10000001;
    char_o[5] = 8'b10000001;
    char_o[6] = 8'b10000001;
    char_o[7] = 8'b01111110;

    // 字符 "d"
    char_d[0] = 8'b11111110;
    char_d[1] = 8'b10000001;
    char_d[2] = 8'b10000001;
    char_d[3] = 8'b10000001;
    char_d[4] = 8'b10000001;
    char_d[5] = 8'b10000001;
    char_d[6] = 8'b11111110;
    char_d[7] = 8'b00000000;

    // 字符 "e"
    char_e[0] = 8'b11111111;
    char_e[1] = 8'b10000000;
    char_e[2] = 8'b11111110;
    char_e[3] = 8'b10000000;
    char_e[4] = 8'b10000000;
    char_e[5] = 8'b10000000;
    char_e[6] = 8'b11111111;
    char_e[7] = 8'b00000000;

    // 字符 "l"
    char_l[0] = 8'b10000000;
    char_l[1] = 8'b10000000;
    char_l[2] = 8'b10000000;
    char_l[3] = 8'b10000000;
    char_l[4] = 8'b10000000;
    char_l[5] = 8'b10000000;
    char_l[6] = 8'b10000000;
    char_l[7] = 8'b11111111;

    // 字符 "1"
    char_1[0] = 8'b01110000;
    char_1[1] = 8'b00010000;
    char_1[2] = 8'b00010000;
    char_1[3] = 8'b00010000;
    char_1[4] = 8'b00010000;
    char_1[5] = 8'b00010000;
    char_1[6] = 8'b01111110;
    char_1[7] = 8'b00000000;
end

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

// 计算字符坐标和选择字符
wire [3:0] char_x = (hcount - hdat_begin) / 8; // 每个字符宽度 8
wire [3:0] char_y = vcount ; // 每个字符高度 8

always @(*) begin
case (char_x)
0: current_row = char_m[char_y]; // "m"
1: current_row = char_o[char_y]; // "o"
2: current_row = char_d[char_y]; // "d"
3: current_row = char_e[char_y]; // "e"
4: current_row = char_l[char_y]; // "l"
5: current_row = char_1[char_y]; // "1"
default: current_row = 8'b0; // 空白
endcase
end

// 显示字符
wire [2:0] bit_x = (hcount - hdat_begin) % 8; // 当前字符内的像素列
wire [2:0] bit_y = (vcount - vdat_begin) % 8; // 当前字符内的像素行

assign disp_RGB = current_row[7-bit_x] ? 3'h7 : 3'h0; // 如果对应位为 1，则显示白色，否则显示黑色
assign test=1'b1;
endmodule