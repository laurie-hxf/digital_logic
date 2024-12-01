module sequential_circuit (
    input clk,
    input reset,
    input x_in,
    output reg [2:0] state
);
    // 状态定义
    localparam S0 = 3'b001;
    localparam S1 = 3'b010;
    localparam S2 = 3'b100;

    // 状态寄存器
    reg [2:0] next_state;

    // 状态转移逻辑
    always @(posedge clk or posedge reset) begin
        if (reset) 
            state <= S0; // 初始状态
        else 
            state <= next_state; // 状态更新
    end

    // 下一状态逻辑
    always @(*) begin
        case (state)
            S0: next_state = (x_in) ? S1 : S0; // 如果 x_in = 1 则转到 S1，否则保持
            S1: next_state = (x_in) ? S2 : S1; // 如果 x_in = 1 则转到 S2，否则保持
            S2: next_state = (x_in) ? S0 : S2; // 如果 x_in = 1 则回到 S0，否则保持
            default: next_state = S0;         // 默认状态
        endcase
    end
endmodule
