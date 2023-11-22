
module LCD_cursor(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn, control_dip);

input rst, clk;
input [9:0] number_btn;
input [1:0] control_btn;
input control_dip; // line1,2 change

wire [9:0] number_btn_t;
wire [1:0] control_btn_t;
wire control_dip_1t ,control_dip_2t;


oneshot_universal #(.WIDTH(12)) O1(clk, rst, {number_btn[9:0],control_btn[1:0], control_dip, ~control_dip}, {number_btn_t[9:0],control_btn_t[1:0],control_dip_1t ,control_dip_2t});
//oneshot_universal #(.WIDTH(12)) 01(clk, rst, {number_btn[9:0], control_btn[1:0]}, {number_btn_t[9:0], control_btn_t[1:0]});
//module name cannot start number, ex 01. O1(O is spelling) is correct.

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;
output reg [7:0] LED_out;

wire LCD_E;
reg LCD_RS, LCD_RW;

reg [7:0] cnt;

reg [3:0] state;
parameter DELAY = 4'b0000;
parameter 
        FUNCTION_SET = 4'b0001,
        DISP_ONOFF = 4'b0010,
        ENTRY_MODE = 4'b0011,
        SET_ADDRESS = 4'b0100,
        DELAY_T = 4'b0101,
        WRITE = 4'b0110,
        CURSOR = 4'b0111,
        SET_LINE_1 = 4'b1110,
        SET_LINE_2 = 4'b1111;
        
always @(posedge clk or negedge  rst)
begin
    if(!rst) begin
        state <= DELAY;
        LED_out <= 8'b0000_0000;
    end
    else begin
        case(state)
            DELAY : begin
                if (cnt == 70) state <= FUNCTION_SET;
                LED_out <= 8'b1000_0000;
            end
            FUNCTION_SET : begin
                if(cnt == 30) state <= DISP_ONOFF;
                LED_out <= 8'b0100_0000;
            end    
            DISP_ONOFF : begin
                if(cnt == 30) state <= ENTRY_MODE;
                LED_out <= 8'b0010_0001;
            end
            ENTRY_MODE : begin
                if(cnt == 30) state <= SET_ADDRESS;
                LED_out <= 8'b0001_0000;
            end
            SET_ADDRESS : begin
                if(cnt == 100) state <= DELAY_T;
                LED_out <= 8'b0000_1000;
            end
            DELAY_T : begin
                state <= |number_btn_t ? WRITE : (|control_btn_t ? CURSOR : (control_dip_1t ? SET_LINE_2 : (control_dip_2t ? SET_LINE_1 : DELAY_T)));
                LED_out <= 8'b0000_0100; //add choose about dipsw
            end
            WRITE : begin
                if(cnt == 30) state <= DELAY_T;
                LED_out <= 8'b0000_0010;
            end
            CURSOR : begin
                if(cnt == 30) state <= DELAY_T;
                LED_out <= 8'b0000_0001;
            end
            SET_LINE_1 : begin
                if(cnt == 30) state <= DELAY_T;
                LED_out <= 8'b0000_0001;
            end
            SET_LINE_2 : begin
                if(cnt == 30) state <= DELAY_T;
                LED_out <= 8'b0000_0001;    
            end
        endcase
    end
end    

always @(posedge clk or negedge  rst)
begin
    if(!rst)
        cnt <= 8'b0000_0000;
    else 
    begin
        case(state)
            DELAY : 
                if(cnt >= 70) cnt <= 0;
                else cnt <= cnt + 1;
            FUNCTION_SET :
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;
            DISP_ONOFF :
                if(cnt >= 30) cnt <=0;
                else cnt <= cnt + 1;
            ENTRY_MODE :
                if(cnt >= 30) cnt <=0;
                else cnt <= cnt + 1;
            SET_ADDRESS :
                if(cnt >= 100) cnt <=0;
                else cnt <= cnt + 1;
            DELAY_T :
                cnt <= 0;
            WRITE :
                if(cnt >= 30) cnt <=0;
                else cnt <= cnt + 1;
            CURSOR :
                if(cnt >= 30) cnt <=0;
                else cnt <= cnt + 1;
            SET_LINE_1 :
                if(cnt >= 30) cnt <=0;
                else cnt <= cnt + 1;     
            SET_LINE_2 :
                if(cnt >= 30) cnt <=0;
                else cnt <= cnt + 1;                         
        endcase
    end
end    

always @(posedge clk or negedge  rst)
begin
    if(!rst)
        {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0001;
    else    
    begin
        case(state)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0011_1000;
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1111;
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0110;
            SET_ADDRESS :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0010; // cursor at home
            DELAY_T :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1111;
            WRITE : begin
                if(cnt == 20) begin
                    case(number_btn)
                        10'b1000_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0001; //1
                        10'b0100_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0010; //2
                        10'b0010_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0011; //3
                        10'b0001_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0100; //4
                        10'b0000_1000_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0101; //5
                        10'b0000_0100_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0110; //6
                        10'b0000_0010_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0111; //7
                        10'b0000_0001_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_1000; //8
                        10'b0000_0000_10 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_1001; //9
                        10'b0000_0000_01 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0000; //0
                    endcase   
                end
                else {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1111;
            end
            CURSOR : begin
                if(cnt == 20) begin
                    case(control_btn)
                        2'b10 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0001_0000; // left
                        2'b01 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0001_0100; //right
                    endcase                     
                end
                else {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1111;               
            end
            SET_LINE_1 :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_1000_0000; 
            SET_LINE_2 :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_1100_0000;
        endcase 
    end
end


assign LCD_E = clk;

endmodule
