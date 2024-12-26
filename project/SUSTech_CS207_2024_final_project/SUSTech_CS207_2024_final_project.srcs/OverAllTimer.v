`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 14:41:12
// Design Name: 
// Module Name: OverAllTimer
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


module OverAllTimer(
    input clk,    // ʱ�����룬��Ƶ��������ˢ��ʱ��
    input rst_n,      // �����ź�
    input Setting,
    input IfRunning, //�Ƿ�ǰ���ڹ���״̬
    input Confirm,
    input AddOne,
   
    input clk_div,
    input power_on_pos,
    output reg [5:0] sec, // �� (0-59)
    output reg [5:0] min, // �� (0-59)
    output reg [4:0] hour, // ʱ (0-23)
    output reg clk_1Hz,   //1��
    output AddOne_debounce
);
wire Confirm_debounce;
parameter [3:0] second=4'd6;
//SecondGenerator generateSecond(.clk(clk),.rst_n(rst_n),.Working(IfRunning),.clk_1Hz(clk_1Hz));
//wire AddOne_debounce;
ButtonDebounce #(
        .WIDTH(1),            // ��������
        .DEBOUNCE_TIME(12_000_000) // ����ʱ�䣬���� 20ms��ʱ�� 50MHz
   ) AddOne_button_debounce (
        .clk(clk),
        .rst_n(rst_n),
        .btn_in(AddOne),
        .btn_out(AddOne_debounce)
    );
    ButtonDebounce #( .WIDTH(1), .DEBOUNCE_TIME(12_000_000)  )
     Confirm_button_debounce (
                .clk(clk),
                .rst_n(rst_n),
                .btn_in(Confirm),
                .btn_out(Confirm_debounce)
            );
reg [1:0] cont; //����ָʾ��ǰ������Ϊ��һλ
reg [3:0] cont2;
wire clkdiv;
TimeSplit timesplit(.clk(clk),.rst_n(rst_n),.clk_div(clkdiv));
    always @(posedge clkdiv or posedge rst_n) begin
        if (!rst_n) begin
            sec <= 0;
            min <= 0;
            hour <= 0;
            cont<=2'b0;
            cont2<=4'b0;
            clk_1Hz<=1'b0;
        end 
        else if(power_on_pos) begin
                sec <= 0;
                min <= 0;
                hour <= 0;
                cont<=2'b0;
                cont2<=4'b0;
                clk_1Hz<=1'b0;
             end
        else begin 
                 cont2=cont2+1;
                 if (cont2==second-1) begin
                       clk_1Hz=~clk_1Hz;
                       cont2=0;
                       end
                 if(clk_1Hz==1'b1 && cont2==1) begin
                       clk_1Hz=~clk_1Hz;
                       end
                 if(IfRunning && clk_1Hz) begin
                        if (sec == 59) begin
                            sec <= 0;
                            if (min == 59) begin
                                min <= 0;
                                if (hour == 23)
                                    hour <= 0;
                                else
                                    hour <= hour + 1;
                            end else
                                min <= min + 1;
                        end else
                            sec <= sec + 1;
          end
           else  if (Setting && ~IfRunning) begin
                 if(Confirm_debounce) begin
                 cont=(cont+1)%3;
                 end
                 if(AddOne_debounce) begin
                 case(cont) 
                   1'd0:begin
                        hour=(hour+1)%24;
                        end
                   1'd1:begin
                        min=(min+1)%60;
                       end
                   2'd2:begin
                       sec=(sec+1)%60;
                       end 
                  endcase      
                 end
             end
            end
            end
endmodule
