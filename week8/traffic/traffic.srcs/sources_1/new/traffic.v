
module traffic( rst, clk, flicker,sw_flicker,
                led_red, led_yellow, led_green, led_left,
                led_walk_red, led_walk_green, led_manual_flicker
);

input rst, clk;
input flicker;
input sw_flicker;
output [3:0] led_red;
output [3:0] led_yellow;
output [3:0] led_green;
output [3:0] led_left;
output [3:0] led_walk_red;
output [3:0] led_walk_green;
output [1:0] led_manual_flicker;

reg [3:0] led_red;
reg [3:0] led_yellow;
reg [3:0] led_green;
wire [3:0] led_left;
reg [3:0] led_walk_red;
reg [3:0] led_walk_green;

wire [1:0] led_manual_flicker;

reg [13:0] cnt_1h;
reg [3:0] cnt_circle;

reg [1:0] direction;
parameter south = 2'b00,
        west = 2'b01,
        east = 2'b10,
        north = 2'b11;

reg manual_flicker;
reg [1:0] reg_sw_flicker;

wire clk_1h;
wire flicker_en;
wire clk_flicker;

always  @(posedge rst or posedge clk)
begin
    if (rst)
        reg_sw_flicker = 2'b00;
    else
        reg_sw_flicker = { reg_sw_flicker[0], sw_flicker};
end

always @(posedge rst or posedge clk)
begin 
    if (rst)
        manual_flicker <= 0;
    else if (reg_sw_flicker == 2'b01)
        manual_flicker <= ~ manual_flicker;
end

assign led_manual_flicker = manual_flicker;

assign flicker_en = ((manual_flicker == 1'b1) || ( flicker == 1'b1)) ? 1 : 0;

always @(posedge rst or posedge clk)
begin
    if (rst)
        cnt_1h <= 0;
    else 
        if (cnt_1h >= 9999)
            cnt_1h <= 0;
        else  
            cnt_1h <= cnt_1h + 1;
end

assign clk_1h = (cnt_1h >= 9999) ? 1: 0;
assign clk_flicker = (cnt_1h <= 4999) ? 0 :1;
                
endmodule
