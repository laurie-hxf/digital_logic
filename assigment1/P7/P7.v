module lab3_practice_add2bit(
    input [1:0] a, 
    input [1:0] b, 
    output [2:0]sum
);
wire carry0, carry1;

assign sum[0]=a[0]^b[0];
assign carry0=a[0]&b[0];

assign sum[1]=a[1]^b[1]^carry0;
assign carry1=(a[1]^b[1])&carry0|(a[1]&b[1]);

assign sum[2]=carry1;
endmodule