
module text_LCD_basic(rst, clk, btn_speed, btn_1h, btn_stop, LCD_E, LCD_RS, LCD_RW, LCD_DATA
,led_red,led_yellow,led_green,led_left,led_walk_red,led_walk_green);

//LCD
input rst,clk;
//clk speed
input btn_speed;
input btn_1h;
input btn_stop;
output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;
output wire [3:0] led_red;
output wire [3:0] led_yellow;
output wire [3:0] led_green;
output wire [3:0] led_left;
output wire [3:0] led_walk_red;
output wire [3:0] led_walk_green;

reg [7:0] LED_out;
wire LCD_E;
reg LCD_RS, LCD_RW;
reg [2:0] state;
parameter DELAY = 3'b000,
    FUNCTION_SET = 3'b001,
    ENTRY_MODE   = 3'B010,
    DISP_ONOFF   = 3'B011,
    LINE1        = 3'b100,
    LINE2        = 3'b101,
    DELAY_T      = 3'b110,
    CLEAR_DISP   = 3'b111;
integer cnt;
//clock
wire [5:0] hours;
wire [5:0] minutes;
wire [5:0] seconds;
//bin2bcd
wire [7:0] hours_bcd;
wire [7:0] minutes_bcd;
wire [7:0] seconds_bcd;

clock ck(clk,rst, btn_speed,btn_1h, hours,minutes,seconds);

bin2bcd b2h(clk,rst, hours, hours_bcd);
bin2bcd b2min(clk,rst, minutes, minutes_bcd);
bin2bcd b2sec(clk,rst, seconds, seconds_bcd);

wire [3:0] state_TL;

TrafficLight TL(clk,rst,hours,minutes,seconds, btn_speed,btn_1h,btn_stop,led_red,led_yellow,led_green,led_left,led_walk_red,led_walk_green,count,state_TL);

always  @(posedge  clk or negedge  rst)
begin
    if(!rst)
        state = DELAY;
    else
    begin
        case(state)
            DELAY : begin
                LED_out = 8'b1000_0000;
                if(cnt == 70) state = FUNCTION_SET;
            end
            FUNCTION_SET : begin
                LED_out = 8'b0100_0000;
                if(cnt == 30) state = DISP_ONOFF;
            end
            DISP_ONOFF : begin
                LED_out = 8'b0010_0000;
                if(cnt == 30) state = ENTRY_MODE;
            end
            ENTRY_MODE : begin
                LED_out = 8'b0001_0000;
                if(cnt == 30) state = LINE1;
            end
            LINE1 : begin
                LED_out = 8'b0000_1000;
                if(cnt == 20) state = LINE2;
            end
            LINE2 : begin
                LED_out = 8'b0000_0100;
                if(cnt == 20) state = DELAY_T;
            end
            DELAY_T : begin
                LED_out = 8'b0000_0010;
                if(cnt == 500) state = CLEAR_DISP; //5
            end
            CLEAR_DISP : begin
                LED_out = 8'b0000_0001;
                if(cnt == 5) begin
                state = LINE1;
                //cnt = -1;
                end
            end
            default : state = DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst)
begin
    if(!rst)
        cnt = 0;
    else begin
        case(state)
            DELAY : 
                if(cnt >= 70) cnt = 0;
                else cnt = cnt + 1;
            FUNCTION_SET :
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            DISP_ONOFF :
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            ENTRY_MODE :
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            LINE1 :
                if(cnt >= 20) cnt = 0;
                else cnt = cnt + 1;
            LINE2 :
                if(cnt >= 20) cnt = 0;
                else cnt = cnt + 1;
            DELAY_T :
                if(cnt >= 500) cnt = 0; //5
                else cnt = cnt + 1;
            CLEAR_DISP :
                if(cnt >= 5) cnt = 0;
                else if( cnt == 5) cnt = -1; //있어야 오류가 안난다.
                else cnt = cnt + 1;
            default : state = DELAY;
        endcase
    end 
end 

always @(posedge clk or negedge rst)
begin
    if(!rst)
        {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_00000000;
    else begin
        case(state)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_1000;
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1100; 
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110;               
            LINE1 :
                begin 
                    case(cnt)
                        00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000; //address set 
                        01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0100; //T
                        02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1001; //I
                        03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1101; //M
                        04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0101; //E
                        05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; //:
                        06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000 + hours_bcd[7:4]; //1
                        07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000 + hours_bcd[3:0]; //1
                        08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; //:
                        09 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000 + minutes_bcd[7:4]; //4
                        10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000 + minutes_bcd[3:0]; //8
                        11 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; //:
                        12 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000 + seconds_bcd[7:4]; //3
                        13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000 + seconds_bcd[3:0]; //6
                        14 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                        15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                        16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    endcase
                end
            LINE2 :
                begin 
                    case(cnt)
                        00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1100_0000;
                        01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0011; //S
                        02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0100; //T
                        03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0001; //A
                        04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0100; //T
                        05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0101; //E
                        06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; //:
                        07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0000 + state_TL; //A,B,C,,,F
                        08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1000; //(
                        09 : {LCD_RS, LCD_RW, LCD_DATA} = hours >= 8 && hours < 23? 10'b1_0_0010_0000 : 10'b1_0_0100_1110; //if day print blank else N
                        10 : {LCD_RS, LCD_RW, LCD_DATA} = hours >= 8 && hours < 23? 10'b1_0_0100_0100 : 10'b1_0_0100_1001; //if day print D else I
                        11 : {LCD_RS, LCD_RW, LCD_DATA} = hours >= 8 && hours < 23? 10'b1_0_0100_0001 : 10'b1_0_0100_0111; //if day print A else G
                        12 : {LCD_RS, LCD_RW, LCD_DATA} = hours >= 8 && hours < 23? 10'b1_0_0101_1001 : 10'b1_0_0100_1000; //if day print Y else H
                        13 : {LCD_RS, LCD_RW, LCD_DATA} = hours >= 8 && hours < 23? 10'b1_0_0010_0000 : 10'b1_0_0101_0100; //if day print black else T
                        14 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1001; //)
                        15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                        16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    endcase
                end
            DELAY_T:
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
            CLEAR_DISP :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0001;
            default :    
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0000_0000;
        endcase        
    end
end

assign LCD_E = clk;
                             
endmodule
