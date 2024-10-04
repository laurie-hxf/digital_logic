module bcd_valid_check_tb();
    reg [3:0] in_tb;
    wire valid_p1_tb,valid_p2_tb;

    bcd_valid_check_p1 p1_instance(.bcd_din(in_tb),.bcd_valid(valid_p1_tb));
    bcd_valid_check_p2 p2_instance(.bcd_din(in_tb),.bcd_valid(valid_p2_tb));

    initial begin
        {in_tb}=4'b0000;
        $monitor("%d %d %d",in_tb, valid_p1_tb, valid_p2_tb);
        #160 $finish;
    end

    always #10 {in_tb}={in_tb}+1;
endmodule