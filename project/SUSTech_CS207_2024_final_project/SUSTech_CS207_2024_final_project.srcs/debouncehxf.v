module debounce(
    input clk,             // 时钟信号
    input rst_n,           // 复位信号
    input key_in,          // 按键输入
    output reg key_stable  // 稳定的按键输出
);
    reg [15:0] debounce_cnt;  // 去抖动计数器
    reg key_reg, key_reg_stable;  // 按键的寄存器，记录按键状态

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            key_stable <= 0;
            debounce_cnt <= 0;
            key_reg <= 0;
            key_reg_stable <= 0;
        end else begin
            key_reg <= key_in;  // 捕获按键输入
            if (key_reg == key_reg_stable) begin
                if (debounce_cnt == 16'hFFFF)  // 去抖动计数到最大值
                    key_stable <= key_reg;
                else
                    debounce_cnt <= debounce_cnt + 1;
            end else begin
                debounce_cnt <= 0;  // 状态变化时重置计数器
            end
            key_reg_stable <= key_reg;
        end
    end
endmodule