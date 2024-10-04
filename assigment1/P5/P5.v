module bcd_valid_check_p2(
    input [3:0] bcd_din,
    output bcd_valid
);
    // 使用条件表达式判断 bcd_din 是否为有效的 BCD 码
    assign bcd_valid = (bcd_din <= 4'b1001) ? 1'b1 : 1'b0;
    
endmodule