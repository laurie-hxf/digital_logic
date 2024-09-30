module lab_a1_p1 (
    input A,
    input B,
    output x
);
xor x1(x,A,B);

    
endmodule

module P1_demo();
reg a_tb,b_tb;
wire x_tb;
P1 ux(.A(a_tb),.B(b_tb),.x(x_tb));
initial begin
    {a_tb,b_tb}=2'b00;
    //  $dumpfile("wave.vcd");  // 指定输出的波形文件名
    //  $dumpvars(0, P1_demo); 
    #40 $finish;
end
always #10 {a_tb,b_tb}={a_tb,b_tb}+1;
endmodule