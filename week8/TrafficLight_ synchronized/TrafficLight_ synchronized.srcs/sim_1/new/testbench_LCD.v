`timescale 1us / 1ns

module testbench_LCD();
reg clk;
reg rst;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;
//clock
wire [5:0] hours;
wire [5:0] minutes;
wire [5:0] seconds;
//bin2bcd
wire [7:0] hours_bcd;
wire [7:0] minutes_bcd;
wire [7:0] seconds_bcd;

text_LCD_basic t_lcd(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, hours, minutes, seconds,hours_bcd, minutes_bcd, seconds_bcd);

initial begin
    clk = 0;
    rst = 0;
    #4 rst = 1;
end

always begin
    #0.5 clk <= ~clk; //period is 1us
end    
// #1 == 1us
endmodule