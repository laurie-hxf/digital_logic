module vga_full_white (
    input clk,              // 系统时钟（100 MHz）
    input rst_n,            // 全局复位信号
    output [2:0] disp_RGB,  // VGA 显示数据
    output test,
    output hsync,           // 行同步信号
    output vsync            // 场同步信号
);

    // VGA时序参数（适配800x600@60Hz）
    parameter H_SYNC_CYCLES = 10'd95;    // 行同步脉冲宽度
    parameter H_BACK_PORCH = 10'd143;    // 行背肩宽度
    parameter H_ACTIVE_VIDEO = 10'd799;  // 行有效显示像素（800 - 1）
    parameter H_FRONT_PORCH = 10'd15;    // 行前肩宽度
    parameter H_TOTAL_CYCLES = 10'd1047; // 一行总像素数（包括前肩、同步脉冲、后肩）

    parameter V_SYNC_CYCLES = 10'd1;     // 场同步脉冲宽度
    parameter V_BACK_PORCH = 10'd29;    // 场背肩宽度
    parameter V_ACTIVE_VIDEO = 10'd599; // 场有效显示行数（600 - 1）
    parameter V_FRONT_PORCH = 10'd10;   // 场前肩宽度
    parameter V_TOTAL_CYCLES = 10'd631; // 一场总行数（包括前肩、同步脉冲、后肩）

    // 分频器信号
    reg clk_25mhz; // 25 MHz 时钟信号
    reg [1:0] clk_div; // 时钟分频计数器

    // VGA信号生成计数器
    reg [9:0] hcount;  // 水平计数器
    reg [9:0] vcount;  // 垂直计数器

    // 同步信号
    wire hsync_pulse = (hcount < H_SYNC_CYCLES);
    wire vsync_pulse = (vcount < V_SYNC_CYCLES);
    
    // 设置RGB信号为白色
    assign disp_RGB = 3'b111;  // 白色（RGB：111）

    // 同步信号输出
    assign hsync = hsync_pulse;
    assign vsync = vsync_pulse;

    // 时钟分频器：将100 MHz时钟分频为25 MHz
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            clk_div <= 2'b00;  // 复位时计数器清零
        else
            clk_div <= clk_div + 1'b1;  // 计数器加1
    end
    
    // 每当计数器达到2，输出25 MHz时钟
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            clk_25mhz <= 0;  // 复位时25 MHz时钟为0
        else if (clk_div == 2'b10)  // 每4个100 MHz时钟周期产生1个25 MHz时钟周期
            clk_25mhz <= ~clk_25mhz;
    end

    // 水平扫描计数器
    always @(posedge clk_25mhz or negedge rst_n) begin
        if (~rst_n)
            hcount <= 10'd0;  // 复位时水平计数器为0
        else if (hcount == H_TOTAL_CYCLES)
            hcount <= 10'd0;  // 一行结束，重新计数
        else
            hcount <= hcount + 1'b1;
    end
    assign test=1'b1;
    // 垂直扫描计数器
    always @(posedge clk_25mhz or negedge rst_n) begin
        if (~rst_n)
            vcount <= 10'd0;  // 复位时垂直计数器为0
        else if (hcount == H_TOTAL_CYCLES) begin
            if (vcount == V_TOTAL_CYCLES)
                vcount <= 10'd0;  // 一场结束，重新计数
            else
                vcount <= vcount + 1'b1;
        end
    end

endmodule
