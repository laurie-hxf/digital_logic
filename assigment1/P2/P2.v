module P2(
    input A,
    input B,
    output Y
);
wire nota,notb;
wire and1,and2;
wire or1;

not na(nota,A);
not nb(notb,B);

and a1(and1,A,B);
and a2(and2,nota,notb);

or o1(or1,and1,and2);

not n3(Y,o1);
endmodule

module P2_demo ();
reg  sA,sB;
wire sy;
P2 ux(.A(sA),.B(sB),.Y(sy));
    
endmodule