`timescale 1us / 1ns

module testbench_LCD();
reg clk;
reg rst;
reg btn_speed;
reg btn_1h;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;
//clock
wire [5:0] hours;
wire [5:0] minutes;
wire [5:0] seconds;

text_LCD_basic t_lcd(rst, clk, btn_speed, btn_1h, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, hours, minutes, seconds);

clock ck(clk,rst, btn_speed,btn_1h, hours,minutes,seconds);

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