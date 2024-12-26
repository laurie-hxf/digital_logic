`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 15:01:05
// Design Name: 
// Module Name: LimitTimeSetting
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


module LimitTimeSetting(  //��ģ��ͬʱ�Ƕ���Ҳ����ʾ�ź�����ģ��
input clk,
input rst_n,
input Setting,
input AddOne,

input Confirm,
input clk_div,
output reg [4:0]  hour_out,
output reg [5:0] min_out,sec_out
    );
    wire Confirm_debounce;
    wire AddOne_debounce;
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
    wire clkdiv;
    Timediv timediv(.clk(clk),.rst_n(rst_n),.clk_div(clkdiv));
   always @ (posedge clkdiv,posedge rst_n) begin
   if(!rst_n) begin 
   hour_out=5'b01010;
   min_out=6'b0;
   sec_out=6'b0;
   cont=2'b0;     
   end
    else if (Setting) begin
              if(Confirm_debounce) begin
              cont=(cont+1)%3;
              end
              if(AddOne_debounce) begin
              case(cont) 
                1'd0:begin
                     hour_out=(hour_out+1)%24;
                     end
                1'd1:begin
                     min_out=(min_out+1)%60;
                    end
                2'd2:begin
                    sec_out=(sec_out+1)%60;
                    end 
               endcase      
              end
          end
   end

    
endmodule
