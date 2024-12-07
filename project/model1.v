module module1(
    output reg[7:0] mode,
    output reg[7:0] one,
    output tubsel_mode,
    output tubsel_one
    );
    assign tubsel_mode=1'b1;
    assign tubsel_one=1'b1;
    always @* begin
     mode=8'b1111_1100;
     one = 8'b0110_0000;
    end
endmodule