module P1 (
    input A,
    input B,
    output x
);
xor x1(x,A,B);

    
endmodule

module P1_demo();
reg sA,sB;
wire sx;
P1 ux(.A(sA),.B(sB),.x(sx));
initial begin
    {sA,sB}=3'b000;
     $dumpfile("wave.vcd");  // 指定输出的波形文件名
     $dumpvars(0, P1_demo); 
    #80 $finish;
end
always #10 {sA,sB}={sA,sB}+1;
endmodule