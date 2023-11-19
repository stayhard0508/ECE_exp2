`timescale 1us / 1ns

module testbench();

reg clk, rst;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;
wire [2:0] state;

reg [9:0] number_btn;
reg [1:0] control_btn;

LCD_cursor tb1(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn, state);
// for display state value, state output is included in module defination.

initial begin
    clk = 0;
    rst = 0;
    number_btn = 10'b0000_0000_00;
    control_btn = 2'b00;
    #4 rst = 1;
    #4000 number_btn = 10'b0000_0000_10; //9
    #4000 number_btn = 10'b0000_0010_00; //7
    #4000 control_btn = 2'b10; //left
    #4000 control_btn = 2'b01; //right
end

always begin
    #0.5 clk <= ~clk; //period is 1us
end    
// #1 == 1us
endmodule