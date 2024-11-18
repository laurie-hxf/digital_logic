module lab_a2_p1_thermometer1(
    input[2:0] d_in,
    output reg [6:0] d_out
);
always @(*)begin
    case(d_in)
        3'b000:d_out=7'b000_1_000;
        3'b001:d_out=7'b001_1_000;
        3'b010:d_out=7'b011_1_000;
        3'b011:d_out=7'b111_1_000;
        3'b100:d_out=7'b000_1_000;
        3'b101:d_out=7'b000_1_111;
        3'b110:d_out=7'b000_1_110;
        3'b111:d_out=7'b000_1_100;
    endcase
end

endmodule