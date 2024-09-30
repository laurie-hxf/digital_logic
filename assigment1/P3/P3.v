module lab_a1_p1_p2_tb();
    reg a_tb, b_tb;  // 测试输入
    wire x_tb, y_tb; // 测试输出

    // 实例化模块 lab_a1_p1 和 lab_a1_p2
    lab_a1_p1 p1_instance (.A(a_tb), .B(b_tb), .X(x_tb));
    lab_a1_p2 p2_instance (.A(a_tb), .B(b_tb), .Y(y_tb));

    // 初始块，初始化并设置仿真结束时间
    initial begin
        a_tb = 0;
        b_tb = 0;
        // 打印标题行
       $monitor("%d %d %d %d", a_tb, b_tb, x_tb, y_tb);
        // 40ns后结束仿真
        #40 $finish;
    end

    // 每隔 10ns 递增 a_tb 和 b_tb 的值，进行所有输入组合的测试
    always #10 {a_tb, b_tb} = {a_tb, b_tb} + 1;
endmodule