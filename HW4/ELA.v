`timescale 1ns/10ps

module ELA(clk, rst, in_data, data_rd, req, wen, addr, data_wr, done);

	input				clk;
	input				rst;
	input		[7:0]	in_data;
	input		[7:0]	data_rd;
	output				req;
	output		reg		wen;
	output		reg[9:0]addr;
	output		reg[7:0]data_wr;
	output				done;


	//--------------------------------------
	//		Write your code here
	//--------------------------------------
	reg [2:0]state, next_state;
	reg [7:0]buff[0:31];
	reg [4:0]row, col, cnt;
	reg [7:0]tmp1, tmp2;
	wire [7:0] d1,d2,d3;
	wire [7:0] a,b,c,d,e,f;
	reg [8:0]out_tmp;
	assign a = buff[0];
	assign b = buff[1];
	assign c = buff[4];
	assign d = buff[2];
	assign e = buff[3];
	assign f = buff[5];
	parameter IDLE = 3'd0;
	parameter ODD_RD = 3'd1;
	parameter ODD_WR = 3'd2;
	parameter EVEN_RD = 3'd3;
	parameter EVEN_WR = 3'd4;
	parameter DONE = 3'd5;

	always @(posedge clk or posedge rst) begin
		if(rst)
			state <= IDLE;
		else 
			state <= next_state;
	end

	always @(*) begin
		case(state)
			IDLE :begin
				next_state = ODD_RD;
			end
			ODD_RD :begin
				if(cnt == 31)
					next_state = ODD_WR;
				else
					next_state = ODD_RD;
			end
			ODD_WR :begin
				if(col == 31)begin
					if(row == 30)
						next_state = EVEN_RD;
					else
						next_state = ODD_RD;
				end
				else begin
					next_state = ODD_WR;
				end
			end
			EVEN_RD :begin
				if((col == 0) && cnt == 3)
					next_state = EVEN_WR;
				else if((col != 0) && cnt == 2)
					next_state = EVEN_WR;
				else 
					next_state = EVEN_RD;
			end
			EVEN_WR :begin
				if(col == 31 && row == 30)
					next_state = DONE;
				else
					next_state = EVEN_RD;
			end
			DONE:
				next_state = DONE;
			default: next_state = IDLE;
		endcase
	end

	//req
	assign req = (state == ODD_RD && cnt == 0)?1:0;

	//buff
	always @(posedge clk) begin
		if(state == ODD_RD)begin
			buff[cnt] <= in_data;
		end
		else if(next_state == EVEN_RD || next_state == EVEN_WR)begin
			if(!col) begin
				buff[cnt - 1] <= data_rd;
			end
			else if (col != 31) begin
				buff[ cnt+3 ] <= data_rd;
				if(col != 1 && !cnt)begin
					buff[0] <= buff[1];
					buff[1] <= buff[4];
					buff[2] <= buff[3];
					buff[3] <= buff[5];
				end
			end
		end
	end
	//cnt
	always @(posedge clk or posedge rst) begin
		if(rst)begin
			cnt <= 0;
		end
		else if(state == ODD_RD)begin
			cnt <= cnt + 1;
		end
		else if(state == EVEN_RD)begin
			cnt <= cnt + 1;
		end
		else if(state == EVEN_WR)begin
			cnt <= 0;
		end
	end

	//addr
	always @(posedge clk or posedge rst) begin
		if(rst)begin
			addr <= 0;
		end
		else if(state == ODD_WR)begin
			addr <= {row,col};
		end
		else if(state == EVEN_RD)begin
			if(col == 0)begin
				if(cnt == 0 || cnt == 1)
					addr <= {row,cnt};
				else
					addr <= {row +5'd2,cnt -5'd2};//2 3
			end
			else begin
				if(cnt == 0)
					addr <= {row , col + 5'd1};
				else
					addr <= {row +5'd2, col + 5'd1};
			end
		end
		else if (state == EVEN_WR)begin
			addr <= {row + 5'd1,col};
		end
	end
	assign d1 = (a>f)?a-f:f-a;
	assign d2 = (b>e)?b-e:e-b;
	assign d3 = (c>d)?c-d:d-c;
	
	always @(*) begin
		if(col == 0) begin
			out_tmp = buff[0] + buff[2];
		end
		else if(col == 31)begin
			out_tmp = (buff[4] + buff[5]);
		end
		else begin
			if(d2 <= d1 && d2 <= d3)
				out_tmp = (b+e);
			else if(d1 <= d2 && d1 <= d3)	
				out_tmp = (a+f);
			else
				out_tmp = (c+d);
		end
	end
	//data_wr
	always @(posedge clk or posedge rst) begin
		if(state == ODD_WR)begin
			data_wr = buff[col];
			wen <= 1;
		end
		else if(state == EVEN_WR)begin
			wen <= 1;
			data_wr <= out_tmp[8:1];
		end
		else
			wen <= 0;
	end
	//col row
	always @(posedge clk) begin
		if(rst)begin
			row <= 0;
			col <= 0;
		end
		else if(state == ODD_RD || state == ODD_WR)begin
			if(col == 31 && state == ODD_WR)
				row <= row + 2;
			col <= col +1;
		end
		else if(state == EVEN_WR)begin
			if(col == 31)begin
				row <= row + 2;
			end
			col <= col + 1;
		end
	end
	assign done = (state == DONE)?1:0;
endmodule