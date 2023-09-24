`timescale 1ns / 1ps


module TFF_behav_test();

reg clk, rst, T;
wire Q;

TFF FF(clk, rst, T, Q);

initial begin 
    clk <= 0;
    rst <= 1;
    #10 rst <= 0;
    #10 rst <= 1;
    #80 T <= 1; // 10+10+80���� 100���� ���� 
    #100 T <= 0;
    #80 T <= 1;
    #100 T <= 0;
    #80 T <= 1;
    #100 T <= 0;
    
end

always begin
    #5 clk <= ~clk;
end

endmodule
