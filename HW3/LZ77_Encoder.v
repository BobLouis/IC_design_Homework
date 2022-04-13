module LZ77_Encoder(clk,reset,chardata,valid,encode,finish,offset,match_len,char_nxt);
input 				clk;
input 				reset;
input 		[7:0] 	chardata;
output  reg			valid;
output  reg			encode;
output  reg			finish;
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
parameter FINISH = 3'b100;

reg [7:0]str[0:2048]; 
reg [12:0]cnt;
reg [7:0] buffer[0:16];
reg [12:0]str_ptr;
reg [3:0]match_len_tmp;
reg [7:0]match;
reg [3:0]window_idx;
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
                if(cnt == 10) next_state = OUT;
                else next_state = CAL;
            end 
            OUT:
                if(char_nxt == 8'h24) next_state = FINISH;
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
    else if(state == READ && cnt == 2048)
        cnt <= 0;
    else if(next_state == CAL && cnt == 10)
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
	else if(next_state == OUT)begin
		str_ptr <= str_ptr + match_len + 1;
	end
end


// //window_idx
// always @(posedge clk or posedge reset) begin
//     if(reset)begin
//         window_idx <= 0;
//     end
//     else if(next_state == CAL && window_idx > 1)begin
//         window_idx <= window_idx + 1;
//     end
//     else if(next_state == CAL && window_idx == 8)begin
//         window_idx <= 0;
//     end
// end


// assign window = buffer[16-window_idx:8-window_idx];
//window
assign window[0] = (cnt > 0 && cnt < 10) ? buffer[9-cnt]  : window[0];
assign window[1] = (cnt > 0 && cnt < 10) ? buffer[10-cnt] : window[1];
assign window[2] = (cnt > 0 && cnt < 10) ? buffer[11-cnt] : window[2];
assign window[3] = (cnt > 0 && cnt < 10) ? buffer[12-cnt] : window[3];
assign window[4] = (cnt > 0 && cnt < 10) ? buffer[13-cnt] : window[4];
assign window[5] = (cnt > 0 && cnt < 10) ? buffer[14-cnt] : window[5];
assign window[6] = (cnt > 0 && cnt < 10) ? buffer[15-cnt] : window[6];
assign window[7] = (cnt > 0 && cnt < 10) ? buffer[16-cnt] : window[7];
assign window[8] = (cnt > 0 && cnt < 10) ? buffer[17-cnt] : window[8];



//CAL
always @(posedge clk ) begin
	if(next_state == CAL)begin
		if(cnt == 0)begin
            match_len <= 0;
            offset    <= 0;
            char_nxt  <= buffer[7];
		end
		else begin
			if(match_len_tmp > match_len)begin
                match_len <= match_len_tmp;
                offset <= 9-cnt;
                char_nxt <= (match_len_tmp != 8) ? buffer[7-match_len_tmp] : str[str_ptr];
            end
		end
	end
end

// always @(posedge clk) begin
// 	if(next_state == OUT || next_state == READ)begin
//             match_len <= 0;
//             offset    <= 0;
//             char_nxt  <= buffer[7];
//     end
//     else if(next_state == CAL && cnt < 9)begin
//         if(match_len_tmp > match_len)begin
//             match_len <= match_len_tmp;
//             offset <= 8-cnt;
//             char_nxt <= (match_len_tmp != 8) ? buffer[7-match_len_tmp] : str[str_ptr];
//         end
//     end
// end



//buffer
always @(posedge clk) begin
    if(state == READ && cnt ==2046)
    begin
        //look ahead buufer
        for(i = 8; i < 17; i = i + 1)
            buffer[i] <= 8'b11111111;
        for(i = 0; i < 8; i = i + 1)
            buffer[7-i] <= str[i];
    end
    else if(next_state == OUT)begin
        //search
        buffer[16] <= buffer[15-match_len];
        buffer[15] <= buffer[14-match_len];
        buffer[14] <= buffer[13-match_len];
        buffer[13] <= buffer[12-match_len];
        buffer[12] <= buffer[11-match_len];
        buffer[11] <= buffer[10-match_len];
        buffer[10] <= buffer[9 -match_len];
        buffer[9]  <= buffer[8 -match_len];
        buffer[8]  <= buffer[7 -match_len];
        //look
        buffer[7] <= (6  >= match_len) ? buffer[6-match_len] : str[str_ptr+match_len-7];
        buffer[6] <= (5  >= match_len) ? buffer[5-match_len] : str[str_ptr+match_len-6];
        buffer[5] <= (4  >= match_len) ? buffer[4-match_len] : str[str_ptr+match_len-5];
        buffer[4] <= (3  >= match_len) ? buffer[3-match_len] : str[str_ptr+match_len-4];
        buffer[3] <= (2  >= match_len) ? buffer[2-match_len] : str[str_ptr+match_len-3];
        buffer[2] <= (1  >= match_len) ? buffer[1-match_len] : str[str_ptr+match_len-2];
        buffer[1] <= (0  >= match_len) ? buffer[0-match_len] : str[str_ptr+match_len-1];
        buffer[0] <= str[str_ptr+match_len];
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
        8'b11111111: match_len_tmp = 7;
        8'b01111111: match_len_tmp = 7;
        8'bx0111111: match_len_tmp = 6;
        8'bxx011111: match_len_tmp = 5;
        8'bxxx01111: match_len_tmp = 4;
        8'bxxxx0111: match_len_tmp = 3;
        8'bxxxxx011: match_len_tmp = 2;
        8'bxxxxxx01: match_len_tmp = 1;
        8'bxxxxxxx0: match_len_tmp = 0;
    endcase
end






//OUTPUT
always@(*)begin
    if(next_state == OUT)
        valid = 1'b1;
    else
        valid = 1'b0;
end

//encode
always @(*) begin
    if(next_state == OUT || next_state == CAL)begin
        encode = 1;
    end
    else begin
        encode = 1'b0;
    end
end

//FINISH 
always@(*)begin
    if(next_state == FINISH)
        finish = 1'b1;
    else
        finish = 1'b0;
end

endmodule