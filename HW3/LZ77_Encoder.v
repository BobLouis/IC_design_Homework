module LZ77_Encoder(clk,reset,chardata,valid,encode,finish,offset,match_len,char_nxt);


input 				clk;
input 				reset;
input 		[7:0] 	chardata;
output  			valid;
output  			encode;
output  			finish;
output 	reg	[3:0] 	offset;
output 	reg	[2:0] 	match_len;
output 	reg [7:0] 	char_nxt;


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
reg [12:0]str_ptr;
reg [3:0]match_len_tmp;
reg [7:0]match;
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
                if(cnt == 9) next_state = OUT;
                else next_state = CAL;
            end 
            OUT:
                if(str_ptr == 2047) next_state = FINISH;
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
    else if(next_state == READ && cnt == 2048)
        cnt <= 0;
    else if(next_state == CAL && cnt == 9)
        cnt <= 0;
    else if(next_state == OUT)
        cnt <= 0;
    else 
        cnt <= cnt + 1;
end

//DATA INPUTs
always@(posedge clk or posedge reset)begin
    if(reset)begin
        str [2048]<= 8'h24;
    end
    else if(next_state == READ)begin
        str[cnt] <= chardata;
    end
end


//str_ptr
always @(posedge clk or posedge reset) begin
	if(reset)begin
		str_ptr <= 8;
	end
	else if(next_state == CAL)begin
		if(cnt == 0)begin
			str_ptr <= 8;
		end
	end
end


//window_idx
always @(posedge clk or posedge reset) begin
    if(reset)begin
        window_idx <= 0;
    else if(next_state == CAL && window_idx < 8)begin
        window_idx <= window_idx + 1;
    end
    else if(next_state == CAL && window_idx == 8)begin
        window_idx <= 0;
    end
end


assign window = buffer[16-window_idx:8-window_idx];

//CAL
always @(posedge clk or posedge reset) begin
	if(reset)begin
        //search buffer
		for(i = 8; i < 17 ; i = i +1)begin
			buffer[i] <= 0 ;
		end
	end
    else if(state == READ && cnt ==2046)
    begin
        //look ahead buufer
        for(i = 0; i < 8; i = i + 1)
            buffer[7-i] <= str[i];
    end
	else if(state == CAL)begin
		if(cnt == 0)begin
            match_len <= 0;
            offset    <= 0;
            char_nxt  <= buffer[7];
		end
		else begin
			if(match_len_tmp > match_len)begin
                match_len <= match_len_tmp;
                offset <= window_idx;
                char_nxt <= buffer[8-window_idx]
            end
		end
	end
end

//compare window with look ahead
always @(*) begin
    match[0] = window[8] == buffer[7]; 
    match[1] = window[7] == buffer[6]; 
    match[2] = window[6] == buffer[5]; 
    match[3] = window[5] == buffer[4]; 
    match[4] = window[4] == buffer[3]; 
    match[5] = window[3] == buffer[2]; 
    match[6] = window[2] == buffer[1]; 
    match[7] = window[1] == buffer[0]; 
end

always @(*) begin
    casex(match)
        8'b11111111: match_len_tmp = 8;
        8'b11111110: match_len_tmp = 7;
        8'b1111110x: match_len_tmp = 6;
        8'b111110xx: match_len_tmp = 5;
        8'b11110xxx: match_len_tmp = 4;
        8'b1110xxxx: match_len_tmp = 3;
        8'b110xxxxx: match_len_tmp = 2;
        8'b10xxxxxx: match_len_tmp = 1;
        8'b0xxxxxxx: match_len_tmp = 0;
    endcase
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

