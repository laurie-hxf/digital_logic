module Vga_ctrl_module// VGA控制模块，根据当前扫描到的点是哪一部分输出相应颜色
(
	input Clk_25mhz,//25M时钟
	input Rst_n,//全局复位信号
	
	input [1:0] Object,//用于表示当前扫描的对象，有四种状态 00：NONE； 01：HEAD； 10：BODY； 11：WALL；
	
	input [5:0] Apple_x,//苹果的X坐标
	input [4:0] Apple_y,//苹果的Y坐标
	
	output reg [9:0] Pixel_x,
	output reg [9:0] Pixel_y,
	
	
	
	output reg Hsync_sig,//列同步信号
	output reg Vsync_sig,//场同步信号
	output  play_VGA_red,
	output  play_VGA_green,
	output  play_VGA_blue

);
	reg [2:0] Vga_rgb;//RGB
	assign play_VGA_red = Vga_rgb[0];
	assign play_VGA_green = Vga_rgb[1];
	assign play_VGA_blue = Vga_rgb[2];
	
	
//	assign {play_VGA_red,play_VGA_green,play_VGA_blue} = Vga_rgb[2:0];
/***************************************************************************/
	reg [9:0] Column_count;//行像素的计数器
	reg [9:0] Row_count;//列像素的计数器
	
	localparam NONE = 2'b00;
	localparam HEAD = 2'b01;
	localparam BODY = 2'b10;
	localparam WALL = 2'b11;
	
	localparam HEAD_COLOR = 3'b010;
	localparam BODY_COLOR = 3'b011;
	
	
/***************************************************************************/
/***************************************************************************/
	
	reg [3:0] lox;
	reg [3:0] loy;

	always @ (posedge Clk_25mhz or negedge Rst_n)
	begin	
		if(!Rst_n)
		begin
			Row_count <= 10'd0;
			Column_count <= 10'd0;
			
			Hsync_sig <= 1'd1;
			Vsync_sig <= 1'd1;
		end
		else 
		begin
			Pixel_x <= Row_count - 10'd144;//a + b段的像素=144（640*480 @ 60）
			Pixel_y <= Column_count - 10'd33;//o + p段的像素=33（640*480 @ 60）
						
			if(Row_count == 10'd0)//检测到列计数器为0，则说明开始工作了，拉低列同步信号
			begin
				Hsync_sig <= 1'd0;
				Row_count <= Row_count + 10'd1;
			end
			else if(Row_count == 10'd96)//a段有96个像素，过了之后Hsync_sig就拉高了
					begin
						Hsync_sig <= 1'd1;
						Row_count <= Row_count + 10'd1;
					end
			else if(Row_count == 10'd799)//整一行有799个像素，4个区域，满一行则移到下一行，行数目加1，列数目清零
					begin
						Row_count <= 10'd0;
						Column_count <= Column_count + 10'd1;//Column_count的累加是靠判断行像素是否达到799个
					end
			else 
				