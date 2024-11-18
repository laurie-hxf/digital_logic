module lab_a2_p3_BCD2Gray(
    input [3:0]bcd,
    output reg [3:0]  gray,
    output reg valid_bcd
);

always @(*)begin
    case(bcd)
    4'b0000:begin gray=4'b0000;valid_bcd=1'b1;end	 
    4'b0001:begin gray=4'b0001;valid_bcd=1'b1;end		 
    4'b0010:begin gray=4'b0011;valid_bcd=1'b1;end		 
    4'b0011:begin gray=4'b0010;valid_bcd=1'b1;end		 
    4'b0100:begin gray=4'b0110;valid_bcd=1'b1;end		 
    4'b0101:begin gray=4'b0111;valid_bcd=1'b1;end		 
    4'b0110:begin gray=4'b0101;valid_bcd=1'b1;end		 
    4'b0111:begin gray=4'b0100;valid_bcd=1'b1;end		 
    4'b1000:begin gray=4'b1100;valid_bcd=1'b1;end		 
    4'b1001:begin gray=4'b1101;valid_bcd=1'b1;end		
    default:begin gray=4'b1111;valid_bcd=1'b0;end
endcase
end
endmodule