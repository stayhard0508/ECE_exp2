`timescale 1us / 1ns

module testbench();
reg clk;
reg rst;
reg btn_speed;
reg btn_1h;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
//clock

wire [3:0] led_red;
wire [3:0] led_yellow;
wire [3:0] led_green;
wire [3:0] led_left;
wire [3:0] led_walk_red;
wire [3:0] led_walk_green;

text_LCD_basic t1(rst, clk, btn_speed, btn_1h, LCD_E, LCD_RS, LCD_RW, LCD_DATA, led_red,led_yellow,led_green,led_left,led_walk_red,led_walk_green);

initial begin
    clk = 0;
    rst = 0;
    btn_speed = 0;
    btn_1h = 0;
    #4 rst = 1;
end

always begin
    #0.5 clk <= ~clk; //period is 1us
end    
// #1 == 1us

always begin
    #24 //delay
    #50000 btn_speed <= ~btn_speed;
    #50000 btn_speed <= ~btn_speed;
    #50000 btn_1h <= ~btn_1h;
    #50000 btn_1h <= ~btn_1h;
end
endmodule