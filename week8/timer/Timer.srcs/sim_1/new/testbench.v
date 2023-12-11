`timescale 1us / 1ns

module testbench();
reg clk;
reg rst;
reg btn_speed;
wire btn_speed_trig;
reg btn_1h;
wire btn_1h_trig;
wire [5:0] hours;
wire [5:0] minutes;
wire [5:0] seconds;
wire [12:0] CLK_FREQUENCY;
wire [3:0] clk_speed;
wire [31:0] timer;

clock ck( clk,rst,btn_speed,btn_1h, hours, minutes,seconds, btn_speed_trig,btn_1h_trig, CLK_FREQUENCY, clk_speed, timer);

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
