module TLS(clk, reset, Set, Stop, Jump, Gin, Yin, Rin, Gout, Yout, Rout);
input           clk;
input           reset;
input           Set;
input           Stop;
input           Jump;
input     [3:0] Gin;
input     [3:0] Yin;
input     [3:0] Rin;
output reg      Gout;
output reg      Yout;
output reg      Rout;

/*
    Write Your Design Here ~
*/
reg [2:0]state, next_state;
reg cnt_rst;
reg [4:0]cnt;
reg [3:0]g_t;
reg [3:0]y_t;
reg [3:0]r_t;
reg [12:0]i;
parameter IDLE  = 3'd0;
parameter GREEN = 3'd1;
parameter YELLOW= 3'd2;
parameter RED   = 3'd3;


always @(posedge clk or posedge reset) begin
    if(reset) i <= 1;
    else i <= i + 1;
end

//state
always @(posedge clk or posedge reset) begin
    if(reset) state <= IDLE;
    else if (!Stop)state <= next_state;
end

//next state
always @(*) begin

    if(Set)begin
        next_state = GREEN;
    end
    else if(Jump)begin
        next_state = RED;
    end
    else begin
        case (state)
            IDLE:begin
                if(Set == 1) next_state = GREEN;
                else next_state = IDLE;
            end 
            GREEN:begin
                if(cnt == g_t -1  && !Stop) 
                    next_state = YELLOW;
                else next_state = GREEN;
            end
            YELLOW:begin
                if(cnt == y_t -1  && !Stop) next_state = RED;
                else next_state = YELLOW;
            end
            RED:begin
                if(cnt == r_t -1  && !Stop) next_state = GREEN;
                else next_state = RED;
            end
            default: next_state = IDLE;
        endcase
    end
    
end

//cnt_rst
// always @(*) begin
//     case (state)
//         IDLE:begin
//             cnt_rst = 1;
//         end 
//         GREEN:begin
//             if(cnt == g_t -1) cnt_rst = 1;
//             else cnt_rst = 0;
//         end
//         YELLOW:begin
//             if(cnt == y_t-1) cnt_rst = 1;
//             else cnt_rst = 0;
//         end
//         RED:begin
//             if(cnt == r_t-1) cnt_rst = 1;
//             else cnt_rst = 0;
//         end
//         default: cnt_rst = 0;
//     endcase
// end


//cnt
// always @(posedge clk or posedge reset) begin
//     if(reset || cnt_rst) cnt <= 0;
//     else if(!Stop) cnt <= cnt + 1;
// end


always @(posedge clk or posedge reset) begin
    if(reset) begin
        cnt <= 0;
    end
    else begin
        case (state)
            IDLE:begin
                cnt <= 0;
            end 
            GREEN:begin
                if(cnt >= g_t -1 && !Stop) cnt <= 0;
                else if(!Stop)cnt <= cnt + 1;
            end
            YELLOW:begin
                if(cnt >= y_t-1 && !Stop) cnt <= 0;
                else if(!Stop)cnt <= cnt + 1;
            end
            RED:begin
                if(cnt >= r_t-1 && !Stop) cnt <= 0;
                else if(!Stop)cnt <= cnt + 1;
            end
            default: cnt <= cnt;
        endcase
    end
end

//set
always @(posedge clk or posedge reset) begin
    if(reset)begin
        g_t <= 0;
        y_t <= 0;
        r_t <= 0;
    end 
    else if(Set == 1)begin
        g_t <= Gin;
        y_t <= Yin;
        r_t <= Rin;
    end
end


//output
always @(posedge clk) begin
    if(next_state == GREEN && !Stop)begin
        Gout <= 1;
        Yout <= 0;
        Rout <= 0;
        
    end
    else if(next_state == YELLOW && !Stop)begin
        Gout <= 0;
        Yout <= 1;
        Rout <= 0;
    end
    else if(next_state == RED && !Stop)begin
        Gout <= 0;
        Yout <= 0;
        Rout <= 1;
    end
end

endmodule