module sound_output (
    input wire clk,          // 时钟输入
    input wire rst_n,        // 异步复位信号，低电平有效
    output reg audio_out     // 声音输出信号
);
    parameter CLK_FREQ = 100000000;  // 输入时钟频率，例如50 MHz
    parameter TONE_FREQ = 1000;     // 音频信号频率，例如1 kHz

    reg [31:0] counter;             // 计数器寄存器
    reg toggle;                     // 方波状态

    // 计算半周期计数值
    localparam HALF_PERIOD = (CLK_FREQ / (2 * TONE_FREQ));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            toggle <= 0;
            audio_out <= 0;
        end else begin
            if (counter >= HALF_PERIOD) begin
                counter <= 0;
                toggle <= ~toggle;  // 翻转方波状态
                audio_out <= toggle;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule