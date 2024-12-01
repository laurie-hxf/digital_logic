module time_counter(
    input clk,           // 系统时钟
    input reset,         // 复位信号
    output reg [5:0] hour,  // 小时
    output reg [5:0] min,   // 分钟
    output reg [5:0] sec    // 秒
);

    reg [25:0] counter; // 用来计数产生秒的信号，假设时钟是 100 MHz

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            hour <= 6'b0;   // 初始化为 00
            min <= 6'b0;    // 初始化为 00
            sec <= 6'b0;    // 初始化为 00
        end else begin
            if (counter == 26'd99999999) begin  // 每秒增加一次（假设时钟是 100 MHz）
                counter <= 0;
                sec <= sec + 1;
                if (sec == 6'd59) begin
                    sec <= 0;
                    min <= min + 1;
                    if (min == 6'd59) begin
                        min <= 0;
                        hour <= hour + 1;
                        if (hour == 6'd23) begin
                            hour <= 0;  // 时钟溢出后，重置为 00:00
                        end
                    end
                end
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule