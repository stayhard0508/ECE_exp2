`timescale 1us / 1ns

module testbench();

reg clk, rst;
reg  [7:0] btn; 
wire [3:0] led_signal_R;
wire [3:0] led_signal_G;
wire [3:0] led_signal_B;

LED3_control LC(clk, rst, btn, led_signal_R, led_signal_G, led_signal_B);

initial  begin
    clk =1; 
    rst = 1;
    btn = 8'b00000000;
    #4 rst = 0;  
    #1000 btn = 8'b00000001;
    #1000 btn = 8'b00000010;
    #1000 btn = 8'b00000100;

end

always begin
    #0.5 clk <= ~clk; //period is 1us
end
// #1 == 1us
endmodule
