module LZ77_Decoder(clk,reset,ready,code_pos,code_len,chardata,encode,finish,char_nxt);

input 				clk;
input 				reset;
input				ready;
input 		[4:0] 	code_pos;
input 		[4:0] 	code_len;
input 		[7:0] 	chardata;
output  			encode;
output  			finish;
output 	  [7:0] 	char_nxt;


	/*-------------------------------------/
	/		Write your code here~		   /
	/-------------------------------------*/
reg [7:0]buff[0:29];
reg [5:0]cnt;
//buffer


always @(posedge clk or posedge reset) begin
	if(reset)begin
		buff[0] <= 0;
	end
	else begin
		buff[0] <= (cnt == code_len)?chardata:buff[code_pos];
		buff[1] <=  buff[0];
		buff[2] <=  buff[1];
		buff[3] <=  buff[2];
		buff[4] <=  buff[3];
		buff[5] <=  buff[4];
		buff[6] <=  buff[5];
		buff[7] <=  buff[6];
		buff[8] <=  buff[7];
		buff[9] <=  buff[8];
		buff[10] <= buff[9];
		buff[11] <= buff[10];
		buff[12] <= buff[11];
		buff[13] <= buff[12];
		buff[14] <= buff[13];
		buff[15] <= buff[14];
		buff[16] <= buff[15];
		buff[17] <= buff[16];
		buff[18] <= buff[17];
		buff[19] <= buff[18];
		buff[20] <= buff[19];
		buff[21] <= buff[20];
		buff[22] <= buff[21];
		buff[23] <= buff[22];
		buff[24] <= buff[23];
		buff[25] <= buff[24];
		buff[26] <= buff[25];
		buff[27] <= buff[26];
		buff[28] <= buff[27];
		buff[29] <= buff[28];
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
