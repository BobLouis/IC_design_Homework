module LZ77_Decoder(clk,reset,code_pos,code_len,chardata,encode,finish,char_nxt);

input 				clk;
input 				reset;
input 		[3:0] 	code_pos;
input 		[2:0] 	code_len;
input 		[7:0] 	chardata;
output  			encode;
output  			finish;
output 		[7:0] 	char_nxt;



/* write your code here ! */
reg [7:0]buff[0:9];
reg [2:0]cnt;
//buffer


always @(posedge clk or posedge reset) begin
	if(reset)begin
		buff[0] <= 0;
	end
	else begin
		buff[0] <= (cnt == code_len)?chardata:buff[code_pos];
		buff[1] <= buff[0];
		buff[2] <= buff[1];
		buff[3] <= buff[2];
		buff[4] <= buff[3];
		buff[5] <= buff[4];
		buff[6] <= buff[5];
		buff[7] <= buff[6];
		buff[8] <= buff[7];
		buff[9] <= buff[8];
	end
end
always @(posedge clk or posedge reset) begin
	if(reset)
		cnt <= 0;
	else begin
		if(cnt == code_len)begin
			cnt <= 0;
		end
		else 
			cnt <= cnt + 1;
	end
end
assign char_nxt = buff[0];
assign finish = (char_nxt == 8'h24)?1:0;
assign encode =  0;

endmodule

