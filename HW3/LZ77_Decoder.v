module LZ77_Decoder(clk,reset,code_pos,code_len,chardata,encode,finish,char_nxt);

input 				clk;
input 				reset;
input 		[3:0] 	code_pos;
input 		[2:0] 	code_len;
input 		[7:0] 	chardata;
output  			encode;
output  			finish;
output 	 	[7:0] 	char_nxt;


/*
	Write Your Design Here ~
*/
assign encode = 1'b0;
assign finish = (char_nxt == 8'h24)?1:0;
reg [7:0]buff[0:8];

//buffer
always @(posedge clk or posedge reset) begin
	if(reset)begin
		for(i=0;i<9;i=i+1) begin
			buff[i] <= 0;
		end
	end
	else begin

	end
end
//output
always @(posedge clk or posedge reset) begin
	if(reset)begin
		char_nxt <= 0;
	end
	else begin
		if(code_len == 0) begin
			char_nxt <= chardata;
		end
		else begin //len > 0

		end
	end
end



endmodule

