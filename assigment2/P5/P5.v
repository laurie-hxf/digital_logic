module lab_a2_p5_BCD_valid_MUX16_1(
    input [3:0]bcd,
    output valid_bcd
);
wire [15:0] give;
assign give =16'b0000_0011_1111_1111;
MUX_16_1 mu(.sel(bcd),.data_in(give),.data_out(valid_bcd));
endmodule