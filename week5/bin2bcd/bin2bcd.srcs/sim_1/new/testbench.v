`timescale 10ns / 100ps


module testbench();
    
reg clk, rst;
reg [3:0] bin;
wire [7:0] bcd;

bin2bcd b2b(clk,rst, bin, bcd);

initial  begin
    clk = 0;
    rst = 0;
    bin = 2'b0000;
    #4 rst = 1;  
    #4 bin = 4'b0000;
    #4 bin = 4'b0001;
    #4 bin = 4'b0010;
    #4 bin = 4'b0011;
    #4 bin = 4'b0100;
    #4 bin = 4'b0101;
    #4 bin = 4'b0110;
    #4 bin = 4'b0111;
    #4 bin = 4'b1000;
    #4 bin = 4'b1001;
    #4 bin = 4'b1010;
    #4 bin = 4'b1011;
    #4 bin = 4'b1100;
    #4 bin = 4'b1101;
    #4 bin = 4'b1110;
    #4 bin = 4'b1111;
    #4 bin = 4'b0000;
    
    
end

always begin
    #2 clk <= ~clk;
end

endmodule
