`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 14:42:29
// Design Name: 
// Module Name: NumberTub
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


module NumbertoTub( //7������ת��ģ��
input [3:0] in_b4,
output reg [7:0] tub_control
    );
    always @ *begin
    case(in_b4)
    4'b0000: tub_control = 8'b1111_1100; //"0" : abcdef_ _  
   4'b0001: tub_control = 8'b0110_0000; //"1":  _bc_ _ _ _ _ _
    4'b0010: tub_control = 8'b1101_1010; //"2": ab_de_g_ 
   4'b0011: tub_control = 8'b1111_0010; //"3":  abcd_ _ g _
    4'b0100: tub_control = 8'b0110_0110; //"4": _bc _ _fg_
    4'b0101: tub_control = 8'b1011_0110;  //"5": a_cd_fg_
    4'b0110: tub_control = 8'b1011_1110; //"6": a_cdefg_
    4'b0111: tub_control = 8'b1110_0000; //"7": abc_ _ _ _ _
    4'b1000: tub_control = 8'b1111_1110; //"8": abcdefg_
    4'b1001: tub_control = 8'b1110_0110; //"9": abc_ _ fg_
    default: 
   tub_control = 8'b1111_1111;  //"E": a_ _ defg_
    endcase
    end
endmodule
