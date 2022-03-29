module LZ77_Encoder(clk,reset,chardata,valid,encode,finish,offset,match_len,char_nxt);


input 				clk;
input 				reset;
input 		[7:0] 	chardata;
output  			valid;
output  			encode;
output  			finish;
output 		[3:0] 	offset;
output 		[2:0] 	match_len;
output 	 	[7:0] 	char_nxt;


/*
	Write Your Design Here ~
*/


reg [2:0]state, next_state;
parameter IDLE = 3'b000;
parameter READ = 3'b001;
parameter CAL = 3'b010;
parameter OUT = 3'b011;

reg [7:0]str[0:2048];
reg [12:0]cnt;
reg [7:0] buffer[0:16];
reg [12:0]str_idx;
reg [3:0] window_dix;
wire [7:0] window[0:8];
integer i;


//STATE MACHINE
always@(posedge clk or posedge reset)begin
    if(reset)
        state <= IDLE;
    else 
        state <= next_state;
end

always@(*)begin
    if(reset)
        next_state <= IDLE;
    else begin
        case(state)
            IDLE:
                next_state = READ;
            READ:begin
                if(cnt == 13'd2048) next_state = CAL;
                else next_state = READ;   
            end
            CAL:begin
                if() next_state = OUT;
                else next_state = CAL;
            end 
            OUT:
                if() next_state = FINISH;
                else next_state = CAL;
            FINISH:begin
                next_state = FINISH;
            end
            default:    next_state = IDLE;
        endcase
    end 
end




//cnt
always@(posedge clk or posedge reset)begin
    if(reset)
        cnt <= 0;
    else if(state == READ)
        cnt <= cnt + 13'd1;
    else 
        cnt <= 0;
end

//DATA INPUT
always@(posedge clk or posedge reset)begin
    if(reset)begin
        str [2048]<= 8'h24;
    end
    else if(next_state ==READ)begin
        str[cnt] <= chardata;
    end
end


//str_index
always @(posedge clk or posedge reset) begin
	if(reset)begin
		str_idx <= 0;
	end
	else if(next_state == CAL)begin
		if(cnt == 0)begin
			str_idx <= 8;
		end
	end
end

assign window = buffer[16-window_idx:8-window_idx];

//CAL
always @(posedge clk or posedge reset) begin
	if(reset)begin
		str_idx <= 0;
		for(i = 0; i < 17 ; i = i +1)begin
			buffer[i] <=0 ;
		end
	end
	if(state == CAL)begin
		if(cnt == 0)begin
			//init
			for(i = 0; i <8; i = i + 1)
				buffer[7-i] <= str[i];
		end
		else begin
			win
		end
	end
end

//OUTPUT
always@(*)begin
    if(next_state == OUT)
        valid = 1'b1;
    else
        valid = 1'b0;
end

//FINISH 
always@(*)begin
    if(next_state == FINISH)
        finish = 1'b1;
    else
        finish = 1'b0;
end

endmodule

