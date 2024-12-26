`timescale 1ns / 1ps
module PosEdgeDetection(
    input wire clk,
    input wire rst_n,
    input wire edge_din,
    output reg edge_out
);
reg [31:0] counter; // ������������Ϊ 32 λ

// ��Ե����ź�
reg trig1, trig2, trig3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {trig1, trig2, trig3} <= 3'b000;
        edge_out <= 1'b0;
        counter <= 32'd0;
    end else begin
        trig1 <= edge_din;
        trig2 <= trig1;
        trig3 <= trig2;

        if ((~trig3) & trig2) begin
            edge_out <= 1'b1;
            counter <= 32'd20000000;
        end else if (counter > 0) begin
            counter <= counter - 1;
        end else begin
            edge_out <= 1'b0;
        end
    end
end

endmodule