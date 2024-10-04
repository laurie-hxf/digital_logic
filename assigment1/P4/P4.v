module bcd_valid_check_p1 (
    input [3:0] bcd_din,
    output bcd_valid
);
    wire case_1,case_2,case_3,case_4;
    xor x1(case_1,bcd_din[3],1);
    xor x2(case_2,bcd_din[2],1);
    xor x3(case_3,bcd_din[1],1);

    and a1(case_4,case_2,case_3);
    or o1(bcd_valid,case_1,case_4);
endmodule