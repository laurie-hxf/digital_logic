`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 14:40:27
// Design Name: 
// Module Name: OverAllClock
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


module OverAllClock(  //��Ϊworking clock �Ķ���ģ��
    input clk,      // ������ʱ��
    input rst_n,    // �����ź�
    input Setting,
    input Confirm,
    input AddOne,    
    input Working,
    input power_on_pos,
    output  [5:0] an, // ��ʾλ��ѡ��
    output [7:0] seg,seg2 // �߶���ʾ�ź�
//    output AddOne_debounce
//    output  [4:0] hour_out,   
//    output  [5:0] min_out,
//    output  [5:0] sec_out
   

);
   wire  [4:0] hour_out;   
wire  [5:0] min_out;
wire  [5:0] sec_out;
//    Timer timer(.clk_1Hz(clk_1Hz),.clk(clk),.IfRunning(Working), .rst_n(rst_n), .sec(sec_out), .min(min_out), .hour(hour_out));
    OverAllTimeCheck display(.working(Working),.AddOne(AddOne),.Confirm(Confirm),.power_on_pos(power_on_pos),
    .Setting(Setting),.rst_n(rst_n),.clk(clk),  .an(an), .seg(seg),.seg2(seg2),.hour_out(hour_out),.min_out(min_out),.sec_out(sec_out));  //�������ɹ���ʱ�ӵ���ʾ�źţ��������ǰʱ��??
endmodule
