`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 14:41:44
// Design Name: 
// Module Name: ButtonDebounce
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


module ButtonDebounce #(
    parameter WIDTH = 1,        // 按键宽度（支持多按键消抖）
    parameter DEBOUNCE_TIME = 20_000 // 消抖时间 (单位: 时钟周期)
)(
    input wire clk,             // 时钟信号
    input wire rst_n,           // 异步复位，低电平有效
    input wire [WIDTH-1:0] btn_in, // 原始按键输入
    output reg [WIDTH-1:0] btn_out // 消抖后的按键输出
);
    // 内部寄存器
    reg [WIDTH-1:0] btn_sync1, btn_sync2; // 同步寄存器
    reg [WIDTH-1:0] btn_stable;           // 稳定信号寄存器
    reg [$clog2(DEBOUNCE_TIME)-1:0] counter [WIDTH-1:0]; // 计数器

    // 双寄存器同步输入信号，避免亚稳态
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            btn_sync1 <= 0;
            btn_sync2 <= 0;
        end else begin
            btn_sync1 <= btn_in;
            btn_sync2 <= btn_sync1;
        end
    end

    // 消抖逻辑
    integer i;
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            btn_stable <= 0;
            btn_out <= 0;
            for (i = 0; i < WIDTH; i = i + 1) counter[i] <= 0;
        end else begin
            for (i = 0; i < WIDTH; i = i + 1) begin
                if (btn_sync2[i] == btn_stable[i]) begin
                    counter[i] <= 0; // 输入信号未变化，清零计数器
                end else begin
                    if (counter[i] < DEBOUNCE_TIME) begin
                        counter[i] <= counter[i] + 1; // 信号变化，计数
                    end else begin
                        btn_stable[i] <= btn_sync2[i]; // 信号稳定，更新状态
                    end
                end
            end
            btn_out <= btn_stable; // 更新输出
        end
    end
endmodule

