`timescale 1us / 1ns

module testbench();

reg clk, rst;
reg  [7:0] bin; 
wire [7:0] seg_data;
wire [7:0] seg_sel;
wire led_signal;

LED_control LC(clk, rst, bin, seg_data, seg_sel, led_signal);

initial  begin
    clk = 0;
    rst = 1;
    bin = 8'b00000000;
    #4 rst = 0;  
    #1000 bin = 8'b00000000;
    #1000 bin = 8'b00111111;
    #1000 bin = 8'b01111111;
    #1000 bin = 8'b10111111;
    #1000 bin = 8'b11111111;
    #1000 bin = 8'b00000000;

end

always begin
    #0.5 clk <= ~clk; //period is 1us
end
// #1 == 1us
endmodule

