`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 15:07:03
// Design Name: 
// Module Name: LimitTimeSettingDisplay
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LimitTimeSettingDisplay(    //��ģ��ͬʱ�Ƕ���Ҳ����ʾ�ź�����ģ��
input clk,          
//input PowerOn,
input rst_n,
input AddOne,
input Confirm,
input SettingLimit,    //�л�����������״̬
output [31:0]work_time_limit,

output reg [5:0] an, 
output  [7:0] seg,seg2

);
wire [4:0] hour_limit;   
wire [5:0] min_limit;
wire [5:0] sec_limit;
wire clk_div;

reg [2:0] digit_select;
reg [3:0] current_digit; // ????????  

assign work_time_limit=hour_limit*3600+min_limit*60+sec_limit;
Time_div time_div(.clk(clk),.rst_n(rst_n),.clk_div(clk_div));
LimitTimeSetting(.clk(clk),.rst_n(rst_n),.AddOne(AddOne),.Confirm(Confirm),.Setting(SettingLimit),
.hour_out(hour_limit),.min_out(min_limit),.sec_out(sec_limit),.clk_div(clk_div));
NumbertoTub decoder(.in_b4(current_digit), .tub_control(seg));
assign seg2=seg;
always @(posedge clk_div,posedge rst_n) begin
if(!rst_n) begin
digit_select<=0;
current_digit<=0;
an<=6'b111111;
end
else begin
     case (digit_select)
               2'd0: begin
                   current_digit <= hour_limit / 10;
                   an <= 6'b100000; // ???��

               end
               2'd1: begin
                   current_digit <= hour_limit % 10;
                   an <= 6'b010000;

               end
               2'd2: begin
                   current_digit <= min_limit / 10;
                   an <= 6'b001000; // ????��

               end
               2'd3: begin
                   current_digit <= min_limit % 10;
                   an <= 6'b000100; 

               end
               3'd4: begin
                   current_digit <= sec_limit / 10;
                   an <= 6'b000010; // ??5��

               end
               3'd5:begin
                  current_digit <= sec_limit % 10;      
                   an <= 6'b000001; // ??6��

                end
           endcase
           digit_select = (digit_select + 1) % 6;
    end
    end

endmodule
