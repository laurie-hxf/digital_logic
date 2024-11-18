module lab_a2_p2_thermometer2(
    input [2:0] d_in,    // 3-bit input
    input en,            // enable signal
    output [6:0] d_out   // 7-bit thermometer display output
);
    wire [7:0] decoder_out; // 8-bit output from decoder_3_8

    // Instantiating the decoder
    decoder_3_8 decoder (
        .in(d_in),
        .en(en),
        .out(decoder_out)
    );

    // Using OR gates to construct d_out
    or u1 (d_out[6], decoder_out[3]);                        // d_out[6] = decoder_out[3]
    or u2 (d_out[5], decoder_out[3], decoder_out[2]);          // d_out[5] = decoder_out[3] | decoder_out[2] | decoder_out[1] | decoder_out[0]
    or u3 (d_out[4], decoder_out[1], decoder_out[3],decoder_out[2]);        // d_out[4] = decoder_out[4] | decoder_out[3]
    or u4 (d_out[3], en);        // d_out[3] = decoder_out[0] | decoder_out[4]
    or u5 (d_out[2], decoder_out[5],decoder_out[6],decoder_out[7]);                        // d_out[2] = decoder_out[5]
    or u6 (d_out[1], decoder_out[6],decoder_out[5]);                        // d_out[1] = decoder_out[6]
    or u7 (d_out[0], decoder_out[5]);                        // d_out[0] = decoder_out[7]

endmodule