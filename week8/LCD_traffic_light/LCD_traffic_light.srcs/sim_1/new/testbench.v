`timescale 1us / 1ns

module testbench();
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
//wire [7:0] hours_bcd;
//wire [7:0] minutes_bcd;
//wire [7:0] seconds_bcd;
//wire [5:0] count;

text_LCD_basic tlcd(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA);
clock ck(clk,rst,hours,minutes,seconds);

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