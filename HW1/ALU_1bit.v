`include "FA.v"
module ALU_1bit(result, c_out, set, overflow, a, b, less, Ainvert, Binvert, c_in, op);
input        a;
input        b;
input        less;
input        Ainvert;
input        Binvert;
input        c_in;
input  [1:0] op;
output  reg  result;
output  reg  c_out;
output       set;                 
output       overflow;      

/*
	Write Your Design Here ~
*/
wire a_out = (Ainvert) ? ~a : a;
wire b_out = (Binvert) ? ~b : b;
assign overflow = c_in ^ c_out;
assign set = (Binvert && (b > a)) ? 1:0;
always @(*) begin
	case (op)
		0: result = a_out & b_out;
		1: result = a_out | b_out;
		2: {c_out,result} = a_out + b_out + c_in;                      // FA FA_1(.s(result), .carry_out(c_out), .x( a_out), .y(b_out), .carry_in(c_in));
		3: result = less;
	endcase
end

endmodule
