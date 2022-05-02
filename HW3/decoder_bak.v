module LZ77_Decoder(clk,reset,code_pos,code_len,chardata,encode,finish,char_nxt);

input 				clk;
input 				reset;
input 		[3:0] 	code_pos;
input 		[2:0] 	code_len;
input 		[7:0] 	chardata;
output  			encode;
output  			finish;
output 	 reg   [7:0]char_nxt;


/*
	Write Your Design Here ~
*/

reg [7:0]buff[0:8];
reg [3:0]cnt;
integer i;

wire [3:0]b1 = (1 <= code_len)?code_pos - ((code_len - 1) % (code_pos+1)):0;
wire [3:0]b2 = (2 <= code_len)?code_pos - ((code_len - 2) % (code_pos+1)):(1-code_len);
wire [3:0]b3 = (3 <= code_len)?code_pos - ((code_len - 3) % (code_pos+1)):(2-code_len);
wire [3:0]b4 = (4 <= code_len)?code_pos - ((code_len - 4) % (code_pos+1)):(3-code_len);
wire [3:0]b5 = (5 <= code_len)?code_pos - ((code_len - 5) % (code_pos+1)):(4-code_len);
wire [3:0]b6 = (6 <= code_len)?code_pos - ((code_len - 6) % (code_pos+1)):(5-code_len);
wire [3:0]b7 = (7 <= code_len)?code_pos - ((code_len - 7) % (code_pos+1)):(6-code_len);
wire [3:0]b8 = (8 <= code_len)?code_pos - ((code_len - 8) % (code_pos+1)):(7-code_len);

//buffer
always @(posedge clk or posedge reset) begin
	if(reset)begin
		for(i=0;i<9;i=i+1) begin
			buff[i] <= 0;
		end
	end
	else if(cnt == 0)begin
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

// output
always @(posedge clk or posedge reset) begin
	if(reset)begin
		char_nxt <= 0;
	end
	else begin
		if(code_len == 0) begin
			char_nxt <= chardata;
		end
		else begin //len > 0
			if(cnt == 0)
				char_nxt <= buff[code_pos];
			else
				char_nxt <= buff[code_len - cnt];
		end
	end
end
assign finish = (char_nxt == 8'h24)?1:0;
assign encode = 0;
endmodule

