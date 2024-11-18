module lab_a2_p4_BCD2Gray_MUX8_1(
    input [3:0] bcd,
    output [3:0] gray
);
    // Intermediate wires for each Gray code bit
    wire [7:0] gray_bit3_data, gray_bit2_data, gray_bit1_data, gray_bit0_data;

    // Assign Gray code data for valid and invalid BCD
    assign gray_bit3_data = (~bcd[3]) ? 8'b00000000 : 8'b11111111;
    assign gray_bit2_data = (~bcd[3]) ? 8'b11110000 : 8'b11111111;
    assign gray_bit1_data = (~bcd[3]) ? 8'b00111100 : 8'b11111100;
    assign gray_bit0_data = (~bcd[3]) ? 8'b01100110 : 8'b11111110;

    // Instantiate 4 MUX_8_1 modules for Gray code output
    MUX_8_1 mux3(.sel(bcd[2:0]), .data_in(gray_bit3_data), .data_out(gray[3]));
    MUX_8_1 mux2(.sel(bcd[2:0]), .data_in(gray_bit2_data), .data_out(gray[2]));
    MUX_8_1 mux1(.sel(bcd[2:0]), .data_in(gray_bit1_data), .data_out(gray[1]));
    MUX_8_1 mux0(.sel(bcd[2:0]), .data_in(gray_bit0_data), .data_out(gray[0]));
endmodule