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
    parameter WIDTH = 1,        // ������ȣ�֧�ֶఴ��������
    parameter DEBOUNCE_TIME = 20_000 // ����ʱ�� (��λ: ʱ������)
)(
    input wire clk,             // ʱ���ź�
    input wire rst_n,           // �첽��λ���͵�ƽ��Ч
    input wire [WIDTH-1:0] btn_in, // ԭʼ��������
    output reg [WIDTH-1:0] btn_out // ������İ������
);
    // �ڲ��Ĵ���
    reg [WIDTH-1:0] btn_sync1, btn_sync2; // ͬ���Ĵ���
    reg [WIDTH-1:0] btn_stable;           // �ȶ��źżĴ���
    reg [$clog2(DEBOUNCE_TIME)-1:0] counter [WIDTH-1:0]; // ������

    // ˫�Ĵ���ͬ�������źţ���������̬
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            btn_sync1 <= 0;
            btn_sync2 <= 0;
        end else begin
            btn_sync1 <= btn_in;
            btn_sync2 <= btn_sync1;
        end
    end

    // �����߼�
    integer i;
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            btn_stable <= 0;
            btn_out <= 0;
            for (i = 0; i < WIDTH; i = i + 1) counter[i] <= 0;
        end else begin
            for (i = 0; i < WIDTH; i = i + 1) begin
                if (btn_sync2[i] == btn_stable[i]) begin
                    counter[i] <= 0; // �����ź�δ�仯�����������
                end else begin
                    if (counter[i] < DEBOUNCE_TIME) begin
                        counter[i] <= counter[i] + 1; // �źű仯������
                    end else begin
                        btn_stable[i] <= btn_sync2[i]; // �ź��ȶ�������״̬
                    end
                end
            end
            btn_out <= btn_stable; // �������
        end
    end
endmodule

