module lab3_practice_add2bit_tb();
reg [1:0]a_tb;
reg [1:0]b_tb;
wire [2:0]sum_tb;
lab3_practice_add2bit P7_instance(.a(a_tb),.b(b_tb),.sum(sum_tb));
initial begin
    {a_tb,b_tb}=4'b0000;
    $monitor("%d %d %d", a_tb, b_tb, sum_tb);
    #160 $finish;
    end
always #10 {a_tb,b_tb}={a_tb,b_tb}+1;
endmodule