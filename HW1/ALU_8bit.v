`include "ALU_1bit.v"
module ALU_8bit(result, zero, overflow, ALU_src1, ALU_src2, Ainvert, Binvert, op);
input  [7:0] ALU_src1;
input  [7:0] ALU_src2;
input        Ainvert;
input        Binvert;
input  [1:0] op;
output [7:0] result;
output       zero;
output       overflow;

/*
	Write Your Design Here ~
*/
wire c_01,c_12,c_23,c_34,c_45,c_56,c_67;
wire comb_set, comb;
assign comb = ($signed(ALU_src1) < $signed(ALU_src2)) ? 1 : 0;
assign zero = ~(result[0] | result[1] | result[2] | result[3] | result[4] | result[5] | result[6] | result[7]);
ALU_1bit ALU_0(.result(result[0]), .c_out(c_01), .set(), .overflow(), .a(ALU_src1[0]), .b(ALU_src2[0]), .less(comb), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(Binvert), .op(op));
ALU_1bit ALU_1(.result(result[1]), .c_out(c_12), .set(), .overflow(), .a(ALU_src1[1]), .b(ALU_src2[1]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(c_01), .op(op));
ALU_1bit ALU_2(.result(result[2]), .c_out(c_23), .set(), .overflow(), .a(ALU_src1[2]), .b(ALU_src2[2]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(c_12), .op(op));
ALU_1bit ALU_3(.result(result[3]), .c_out(c_34), .set(), .overflow(), .a(ALU_src1[3]), .b(ALU_src2[3]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(c_23), .op(op));
ALU_1bit ALU_4(.result(result[4]), .c_out(c_45), .set(), .overflow(), .a(ALU_src1[4]), .b(ALU_src2[4]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(c_34), .op(op));
ALU_1bit ALU_5(.result(result[5]), .c_out(c_56), .set(), .overflow(), .a(ALU_src1[5]), .b(ALU_src2[5]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(c_45), .op(op));
ALU_1bit ALU_6(.result(result[6]), .c_out(c_67), .set(), .overflow(), .a(ALU_src1[6]), .b(ALU_src2[6]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(c_56), .op(op));
ALU_1bit ALU_7(.result(result[7]), .c_out(), .set(comb_set), .overflow(overflow), .a(ALU_src1[7]), .b(ALU_src2[7]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(c_67), .op(op));

endmodule
