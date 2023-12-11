`timescale 1us / 1ns

module testbench();

reg clk, rst;
wire [3:0] led_red;
wire [3:0] led_yellow;
wire [3:0] led_green;
wire [3:0] led_left;
wire [3:0] led_walk_red;
wire [3:0] led_walk_green;

TrafficLight TL(clk,rst,led_red,led_yellow,led_green,led_left,led_walk_red,led_walk_green);

initial begin
    clk = 0;
    rst = 1;
    #4 rst = 0;
end

always begin
    #0.5 clk <= ~clk; //period is 1us
end    

endmodule
