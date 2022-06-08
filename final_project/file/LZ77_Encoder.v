module LZ77_Encoder(clk,reset,chardata,valid,encode,finish,offset,match_len,char_nxt);

input 				clk;
input 				reset;
input 		[7:0] 	chardata;
output  	reg		valid;
output  	reg		encode;
output  	reg		finish;
output  	reg[4:0] 	offset;
output  	reg[4:0] 	match_len;
output  	reg[7:0] 	char_nxt;


/*-------------------------------------/
/		Write your code here~		   /
/-------------------------------------*/
reg [2:0]state, next_state;
parameter IDLE = 3'b000;
parameter READ = 3'b001;
parameter CAL = 3'b010;
parameter OUT = 3'b011;
parameter SHIFT = 3'b100;
parameter OFFSET = 3'b101;
parameter FINISH = 3'b110;

reg [7:0]str[0:2078]; 

reg [11:0]cnt;
reg [5:0] look_ptr;
reg [5:0] search_ptr;

reg [4:0] pos_cnt;
reg [4:0] cmp_cnt;
reg [4:0] shift_cnt;
integer i;
reg [20:0] cyc;


wire [7:0]search_buf;
assign search_buf = str[search_ptr];
wire [7:0]look_buf;
assign look_buf = str[look_ptr];
//STATE MACHINE

always @(posedge clk or posedge reset) begin
    if(reset)
        cyc <=0;
    else
        cyc <= cyc + 1;
end

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
                if(cnt == 13'd2079) next_state = CAL;
                else next_state = READ;   
            end
            CAL:begin
                if(pos_cnt == 30 || match_len == 24) next_state = OUT;
                else next_state = CAL;
            end 
            OUT:begin
                if(char_nxt == 8'h24 ) next_state = FINISH;
                else next_state = SHIFT;
            end   
            SHIFT:begin
                if(shift_cnt == match_len) next_state = OFFSET;
                else next_state = SHIFT;
            end
            OFFSET:
                next_state = CAL;
            FINISH:begin
                next_state = FINISH;
            end
            default:    next_state = IDLE;
        endcase
    end 
end


//read_cnt
always@(posedge clk or posedge reset)begin
    if(reset)
        cnt <= 30;
    else if(next_state == READ)
        cnt <= cnt + 1;
end

//shift_cnt
always@(posedge clk or posedge reset)begin
    if(reset)
        shift_cnt <= 0;
    else if(state == SHIFT)
        shift_cnt <= shift_cnt + 1;
    else if(state == OUT)
        shift_cnt <= 0;
end

//pos_cnt
always @(posedge clk or posedge reset) begin
    if(reset)
        pos_cnt <= 0;
    else if(next_state == CAL)begin
        if(look_buf != search_buf)  
            pos_cnt <= pos_cnt + 1;
    end
    else if(next_state == OFFSET)   
        pos_cnt <= 0;
end

//look_ptr
always @(posedge clk or posedge reset) begin
    if(reset)
        look_ptr <= 30;
    else begin
        if(next_state == CAL)begin
            if(search_buf == look_buf)  
                look_ptr <= look_ptr + 1;
            else    
                look_ptr <= 30;
        end
        else if(next_state == OUT)
            look_ptr <= 30;
    end
end

//search_ptr
always @(posedge clk or posedge reset) begin
    if(reset)
        search_ptr <= 0;
    else begin
        if(next_state == CAL)begin
            if(cmp_cnt && search_buf != look_buf) 
                search_ptr <= pos_cnt + 1;
            else
                search_ptr <= search_ptr + 1;
        end
        else if(next_state == OUT)
            search_ptr <= 0;
    end
end

//cmp_cnt
always @(posedge clk or posedge reset) begin
    if(reset)
        cmp_cnt <= 0;
    else begin
        if(next_state == CAL && look_buf == search_buf)begin
            cmp_cnt <= cmp_cnt +1;
        end
        else begin
            cmp_cnt <= 0;
        end
    end
end



//DATA INPUTs
always@(posedge clk or posedge reset)begin
    if(reset)begin
        str[0] <= 8'hFF;
        str[1] <= 8'hFF;
        str[2] <= 8'hFF;
        str[3] <= 8'hFF;
        str[4] <= 8'hFF;
        str[5] <= 8'hFF;
        str[6] <= 8'hFF;
        str[7] <= 8'hFF;
        str[8] <= 8'hFF;
        str[9] <= 8'hFF;
        str[10] <= 8'hFF;
        str[11] <= 8'hFF;
        str[12] <= 8'hFF;
        str[13] <= 8'hFF;
        str[14] <= 8'hFF;
        str[15] <= 8'hFF;
        str[16] <= 8'hFF;
        str[17] <= 8'hFF;
        str[18] <= 8'hFF;
        str[19] <= 8'hFF;
        str[20] <= 8'hFF;
        str[21] <= 8'hFF;
        str[22] <= 8'hFF;
        str[23] <= 8'hFF;
        str[24] <= 8'hFF;
        str[25] <= 8'hFF;
        str[26] <= 8'hFF;
        str[27] <= 8'hFF;
        str[28] <= 8'hFF;
        str[29] <= 8'hFF;
    end
    else if(next_state == READ)begin
        str[cnt] <= chardata;
    end
    else if(next_state == SHIFT)begin
        for(i = 0; i <2079; i= i+1)begin
            str[i] <= str[i + 1];
        end
    end
end



//CAL
always @(posedge clk) begin
    if(next_state == READ)begin
        match_len <=0;
        offset    <= 0;
        char_nxt  <= str[30];
    end
	else if(next_state == CAL)begin
        if(cmp_cnt > match_len)begin
            match_len <= cmp_cnt;
            offset <= 29-pos_cnt;
            char_nxt <= look_buf;
        end
	end
    else if(next_state == OFFSET)begin
        match_len <= 0;
        offset <= 0;
        char_nxt <= str[30];
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
    if(next_state == READ || next_state == FINISH)begin
        encode = 0;
    end
    else begin
        encode = 1;
    end
end

//FINISH 
always@(*)begin
    if(next_state == FINISH || cyc == 20'h18697)
        finish = 1'b1;
    else
        finish = 1'b0;
end

endmodule
