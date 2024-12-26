`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 14:40:55
// Design Name: 
// Module Name: OverAllTimeCheck
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


module OverAllTimeCheck(
    input clk,
//    input CleanTime,          
    input rst_n,
    input working,
input Setting,
      input [4:0] hour,   
     input [5:0] min,
   input [5:0] sec,
    input Confirm,
   input AddOne,
   input power_on_pos,
    output reg [5:0] an, 
    output  [7:0] seg,seg2,
 output  [4:0] hour_out,   
 output  [5:0] min_out,
 output  [5:0] sec_out,
 output AddOne_debounce
);

  reg [2:0] digit_select;
  reg [3:0] current_digit; // ????????  
    wire clk_div;
    Time_div time_div(.clk(clk),.rst_n(rst_n),.clk_div(clk_div));
    OverAllTimer timecounter(.AddOne_debounce(AddOne_debounce),.Confirm(Confirm),.AddOne(AddOne),.Setting(Setting),.hour(hour),.min(min),.sec(sec),.rst_n(rst_n),.IfRunning(working),.clk(clk),.clk_div(clk_div),.power_on_pos(power_on_pos));
    NumbertoTub decoder(.in_b4(current_digit), .tub_control(seg));
    assign seg2=seg;
    always @(posedge clk_div,negedge rst_n) begin
    if(!rst_n) begin
    digit_select<=0;
    current_digit<=0;
    an<=6'b111111;
    end
    else  if(power_on_pos) begin
            digit_select<=0;
            current_digit<=0;
            an<=6'b111111;
         end
    else begin
         case (digit_select)
                   2'd0: begin
                       current_digit <= hour / 10;
                       an <= 6'b100000; // ???��

                   end
                   2'd1: begin
                       current_digit <= hour % 10;
                       an <= 6'b010000;

                   end
                   2'd2: begin
                       current_digit <= min / 10;
                       an <= 6'b001000; // ????��

                   end
                   2'd3: begin
                       current_digit <= min % 10;
                       an <= 6'b000100; 

                   end
                   3'd4: begin
                       current_digit <= sec / 10;
                       an <= 6'b000010; // ??5��

                   end
                   3'd5:begin
                      current_digit <= sec % 10;      
                       an <= 6'b000001; // ??6��

                    end
               endcase
               digit_select = (digit_select + 1) % 6;
        end
        end

endmodule
