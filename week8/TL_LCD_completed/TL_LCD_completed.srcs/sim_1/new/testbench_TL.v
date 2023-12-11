`timescale 1us / 1ns

module testbench_TL();

reg clk, rst;
wire [3:0] led_red;
wire [3:0] led_yellow;
wire [3:0] led_green;
wire [3:0] led_left;
wire [3:0] led_walk_red;
wire [3:0] led_walk_green;
wire [3:0] count;   
wire [5:0] hours;
wire [5:0] minutes;
wire [5:0] seconds;
wire [3:0] state;

TrafficLight TL(clk,rst,led_red,led_yellow,led_green,led_left,led_walk_red,led_walk_green, count, hours, minutes, seconds, state);

initial begin
    clk = 0;
    rst = 0;
    #4 rst = 1;
end

always begin
    #0.5 clk <= ~clk; //period is 1us
end    

endmodule
