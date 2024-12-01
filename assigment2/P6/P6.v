module lab_a2_p6_decoder_4_16_s (
    input wire en,          // Enable signal
    input wire [3:0] in,    // 4-bit input
    output wire [15:0] out  // 16-bit output
);

    // 中间信号定义
    wire [7:0] low_out;     // 低8位输出
    wire [7:0] high_out;    // 高8位输出
    wire low_en;            // 低位decoder使能
    wire high_en;           // 高位decoder使能

    // 使用逻辑门生成低位和高位使能信号
    and u1 (low_en, en, ~in[3]);   // 低位使能信号 low_en = en & ~in[3]
    and u2 (high_en, en, in[3]);   // 高位使能信号 high_en = en & in[3]

    // 实例化两个 3-to-8 解码器
    decoder_3_8 low_decoder (
        .en(low_en),
        .in(in[2:0]),
        .out(low_out)
    );

    decoder_3_8 high_decoder (
        .en(high_en),
        .in(in[2:0]),
        .out(high_out)
    );

    // 连接高低位输出到最终输出
    or u3 (out[0], low_out[0], 1'b0);   // 低位输出
    or u4 (out[1], low_out[1], 1'b0);
    or u5 (out[2], low_out[2], 1'b0);
    or u6 (out[3], low_out[3], 1'b0);
    or u7 (out[4], low_out[4], 1'b0);
    or u8 (out[5], low_out[5], 1'b0);
    or u9 (out[6], low_out[6], 1'b0);
    or u10 (out[7], low_out[7], 1'b0);

    or u11 (out[8], high_out[0], 1'b0); // 高位输出
    or u12 (out[9], high_out[1], 1'b0);
    or u13 (out[10], high_out[2], 1'b0);
    or u14 (out[11], high_out[3], 1'b0);
    or u15 (out[12], high_out[4], 1'b0);
    or u16 (out[13], high_out[5], 1'b0);
    or u17 (out[14], high_out[6], 1'b0);
    or u18 (out[15], high_out[7], 1'b0);

endmodule
