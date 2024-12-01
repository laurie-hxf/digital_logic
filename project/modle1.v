module vga_display(
    input clk,                   // 系统时钟
    output [2:0] disp_RGB,       // VGA 显示数据
    output hsync,                // VGA 行同步信号
    output vsync                 // VGA 场同步信号
);

// VGA 行、场扫描时序参数
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

// 8x8 字符点阵图定义
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
    8'b01110000, 
    8'b00010000, 
    8'b00010000, 
    8'b00010000,
    8'b00010000, 
    8'b00010000, 
    8'b01111110, 
    8'b00000000
};

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
wire [3:0] char_x = (hcount - hdat_begin) / 8;  // 每个字符宽度 8
wire [3:0] char_y = vcount ;  // 每个字符高度 8

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
wire [2:0] bit_x = (hcount - hdat_begin) % 8;  // 当前字符内的像素列
wire [2:0] bit_y = (vcount - vdat_begin) % 8;  // 当前字符内的像素行

assign disp_RGB = current_row[bit_x] ? 3'h7 : 3'h0; // 如果对应位为 1，则显示白色，否则显示黑色

endmodule