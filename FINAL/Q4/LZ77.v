module LZ77(clk,reset,chardata,valid,encode,busy,offset,match_len,char_nxt);

input 				clk;
input 				reset;
output  			valid;
output  			encode;
output  			busy;
output  	[7:0] 	char_nxt;

inout		[3:0] 	offset;
inout		[2:0] 	match_len;
inout 		[7:0] 	chardata;


/* write your code here ! */

endmodule
