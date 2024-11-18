module T_flipflop_with_reset (
    input wire clk,    // 时钟信号
    input wire T,      // T输入信号
    input wire reset,  // 复位信号
    output reg Q       // 输出
);

    always @(posedge clk or negedge reset) begin
        if (!reset)
            Q <= 1'b0;   // 复位信号为低电平时，将输出置0
        else if (T)
            Q <= ~Q;     // T为高电平时翻转输出
    end

endmodule

module testbench;

    reg clk;
    reg T;
    reg reset;
    wire Q;

    // 实例化T触发器模块
    T_flipflop_with_reset uut (
        .clk(clk),
        .T(T),
        .reset(reset),
        .Q(Q)
    );

    // 时钟生成
    initial begin
        $dumpfile("wave.vcd");  // 指定输出的波形文件名
        $dumpvars(0, testbench); 
        clk = 0;
        forever #5 clk = ~clk; // 每5个时间单位翻转一次，生成10个时间单位的时钟周期
    end

    // 测试序列
    initial begin
        // 初始化
        reset = 0; T = 0;
        #10 reset = 1;       // 释放复位
        #10 T = 1;           // T = 1，观察Q翻转
        #20 T = 0;           // T = 0，Q保持不变
        #10 T = 1;           // T = 1，Q翻转
        #10 reset = 0;       // 复位信号变低，Q应归0
        #10 reset = 1;       // 复位释放
        #10 T = 1;           // T = 1，Q翻转
        #20 $stop;           // 停止仿真
    end

endmodule