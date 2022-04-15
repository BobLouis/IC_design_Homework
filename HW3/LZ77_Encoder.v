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
reg [12:0]look_ptr;
reg [3:0]match_len_tmp;


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


//look_ptr
always @(posedge clk or posedge reset) begin
	if(reset)begin
		look_ptr <= 8;
	end
	else if(next_state == OUT)begin
		look_ptr <= look_ptr + match_len + 1;
	end
end


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
                char_nxt <=;
            end
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