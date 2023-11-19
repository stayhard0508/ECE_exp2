`timescale 1us / 1ns

module testbench();

reg clk, rst;
reg [5:0] btn;
reg add_sel;

wire dac_csn, dac_ldacn, dac_wrn, dac_a_b;
wire [7:0] dac_d;
wire [7:0] led_out;

DAC DtoAC(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out);

initial begin
    clk = 0;
    rst = 0;
    add_sel = 0;
    btn = 6'b000000;
    #4 rst = 1;
    #4000 btn = 6'b000100; //+2
    #4000 btn = 6'b000001; //+8
    #4000 btn = 6'b000100; //+2
    #4000 btn = 6'b000001; //+8

    #4000 btn = 6'b100000; //-1
    #4000 btn = 6'b010000; //+1
    #4000 btn = 6'b001000; //-2
    #4000 btn = 6'b000100; //+2
    #4000 btn = 6'b000010; //-8
    #4000 btn = 6'b000001; //+8
end

always begin
    #0.5 clk <= ~clk; //period is 1us
end    
// #1 == 1us
endmodule