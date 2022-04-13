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
reg [3:0]cnt;
wire b1 = (1 <= code_len)?(code_pos-len+1):(0);
wire b2 = (2 <= code_len)?(code_pos-len+1):(1-len);
wire b3 = (3 <= code_len)?(code_pos-len+1):(2-len);
wire b4 = (4 <= code_len)?(code_pos-len+1):(3-len);
wire b5 = (5 <= code_len)?(code_pos-len+1):(4-len);
wire b6 = (6 <= code_len)?(code_pos-len+1):(5-len);
wire b7 = (7 <= code_len)?(code_pos-len+1):(6-len);
wire b8 = (8 <= code_len)?(code_pos-len+1):(7-len);
//buffer
always @(posedge clk or posedge reset) begin
	if(reset)begin
		for(i=0;i<9;i=i+1) begin
			buff[i] <= 0;
		end
	end
	else begin
		buff[0] <= chardata;
		buff[1] <= buff[b1];
		buff[2] <= buff[b2];
		buff[3] <= buff[b3];
		buff[4] <= buff[b4];
		buff[5] <= buff[b5];
		buff[6] <= buff[b6];
		buff[7] <= buff[b7];
		buff[8] <= buff[b8];
end
//cnt
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
			char_nxt <= buff[code_len - cnt];
		end
	end
end



endmodule

