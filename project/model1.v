module module1(
    input enable,
    output reg[7:0] mode,
    output reg[7:0] one,
    output reg tubsel_mode,
    output reg tubsel_one
    );
    
        always @* begin
            tubsel_one=1'b1;
            tubsel_mode=1'b1;
            if(enable)begin
                mode=8'b1111_1100;
                one = 8'b1101_1010;
            end
            else begin
                mode=8'b0000_0000;
                one=8'b0000_0000;
            end
        end
endmodule
