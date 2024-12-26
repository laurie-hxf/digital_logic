`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 14:45:02
// Design Name: 
// Module Name: Time_div
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


module Time_div(
    input clk,      
    input rst_n,    
    output reg [13:0] counter1, // ???
    output reg [12:0] counter2,
    output reg clk_div//
);
parameter [13:0] second1=14'd10000;
parameter [12:0] second2=13'd5;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter1 <= 0;
            counter2<=0;
            clk_div <= 0;
        end else if (counter1 == second1-1)begin 
            counter1 <= 0;
            counter2<=counter2 +1;
            if (counter2==second2) begin
            counter2<=0;
            clk_div<=~clk_div;
            end
        end else  begin
            counter1 <= counter1 + 1;
        end
    end
endmodule
