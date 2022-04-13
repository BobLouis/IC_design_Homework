module BOE(clk, rst, data_num, data_in, result);
input clk;
input rst;
input [2:0] data_num;
input [7:0] data_in;
output reg [10:0] result;

/*
    Write your design here!
*/
parameter IDLE = 3'd0;
parameter READ = 3'd1;
parameter WRITE_MAX = 3'd2;
parameter WRITE_SUM = 3'd3;
parameter WRITE_SORT = 3'd4;
reg [2:0]state, next_state;
reg [2:0]num;
reg [7:0]array[0:5];
reg [7:0]array_sort[0:5];
reg [7:0]temp;
reg [3:0]cnt;
reg [3:0]cnt_read;
integer i,j;

wire [7:0]a_1,a_2,a_3,b_1,b_2,c;
//state
always @(posedge clk or posedge rst) begin
    if(rst) state <= IDLE;
    else state <= next_state;
end

//next state
always @(*) begin
    if(rst)begin
        next_state = IDLE;
    end  
    else begin
        case(state)
            IDLE:
                next_state = READ;
            READ:begin
                if(cnt_read == num)begin
                    next_state = WRITE_MAX;
                end
                else begin
                    next_state = READ;
                end
            end
                
            WRITE_MAX:
                next_state = WRITE_SUM;
            WRITE_SUM: 
                next_state = WRITE_SORT;
            WRITE_SORT: begin
                if(cnt == num)begin
                    next_state = READ;
                end
                else begin
                    next_state = WRITE_SORT;
                end
            end
            default:next_state = IDLE;
        endcase
    end
end

//array
always @(posedge clk or posedge rst) begin
    if(rst)begin
        for(i=0;i<6;i=i+1)begin
            array[i] <= 0;
        end
    end
    else if(next_state == READ)begin
        if(cnt_read == 0)begin
            num <= data_num;
            array[0] <= data_in;
        end
        else begin
            array[cnt_read] <= data_in;
        end
    end
    else if(state == WRITE_SORT )begin
        for(i=0;i<6;i=i+1)begin
            array[i] <= 0;
        end
    end
end

//cnt
always @(posedge clk or posedge rst) begin
    case(next_state)
            IDLE:begin
                cnt <=0;
                cnt_read <= 0;
            end
            READ:begin
                if(cnt_read == num)begin
                    cnt_read <= 0;
                end
                else begin
                    cnt_read <= cnt_read + 1;
                end
            end
            WRITE_MAX:begin
                cnt_read <= 0;
                cnt <= 0;
            end
                
            WRITE_SUM: 
                cnt <= 0;
            WRITE_SORT: begin
                if(cnt == num)begin
                    cnt <= 0;
                end
                else begin
                    cnt <= cnt + 1; 
                end
            end
            default:cnt <= 0;
        endcase
end

//output 
always @(posedge clk or posedge rst) begin
    if(next_state == WRITE_MAX)begin
        result <= c;
    end
    else if(next_state == WRITE_SUM)begin
        result = array[0] + array[1] + array[2] + array[3] + array[4] + array[5];
    end
    else if(next_state == WRITE_SORT)begin
        result = array_sort[num-1-cnt];
    end 
end




assign a_1 = (array[0] > array[1])?array[0]:array[1];
assign a_2 = (array[2] > array[3])?array[2]:array[3];
assign a_3 = (array[4] > array[5])?array[4]:array[5];

assign b_1 = (a_1>a_2) ? a_1 : a_2;
assign c =   (b_1>a_3) ? b_1 : a_3;


//sort
always@(*)begin
    if(state == READ && cnt_read == num)begin
        for(i=0;i<6;i=i+1)begin
            array_sort[i]=array[i];
        end
    end
    else begin
        for (i = 6; i > 0; i = i - 1) begin
            for (j = 0 ; j < i; j = j + 1) begin
                if (array_sort[j] < array_sort[j + 1]) begin
                    temp         = array_sort[j];
                    array_sort[j]     = array_sort[j + 1];
                    array_sort[j + 1] = temp;
                end 
            end
        end
    end
end



endmodule