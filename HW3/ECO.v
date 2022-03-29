reg [2:0]state, next_state;
parameter IDLE = 3'b000;
parameter READ = 3'b001;
parameter CAL = 3'b010;
parameter OUT = 3'b011;
parameter FINISH = 3'b100;

reg [7:0]str[0:2048];
reg [12:0]cnt;

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
