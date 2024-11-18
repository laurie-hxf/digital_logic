module lab7(
    input D0,D1,D2,D3,D4,D5,D6,D7,
    input S2,S1,S0,
    output reg Y
    );
    always @(*) begin
        case({S2,S1,S0})
            3'b000:Y=D0;
            3'b001:Y=D1;
            3'b010:Y=D2;
            3'b011:Y=D3;
            3'b100:Y=D4;
            3'b101:Y=D5;
            3'b110:Y=D6;
            3'b111:Y=D7;
        endcase    
    end    
endmodule
module temp(
    input A,B,C,D,
    output Y
);
lab7 ux(.S2(A),.S1(B),.S0(C),.D0(1'b1),.D1(1'b0),.D2(D),.D3(D),.D4(1'b0),.D5(D),.D6(D),.D7(D),.Y(Y));
endmodule

module test();
reg a_tb,b_tb,c_tb,d_tb;
wire y_tb;
temp ux (.A(a_tb),.B(b_tb),.C(c_tb),.D(d_tb),.Y(y_tb));
initial begin 
    $dumpfile("lab7.vcd");  // 指定输出的波形文件名
    $dumpvars;
    {a_tb,b_tb,c_tb,d_tb}=4'b0000;
       
    #160 $finish;
end
always #10 {a_tb,b_tb,c_tb,d_tb}={a_tb,b_tb,c_tb,d_tb}+1;
endmodule