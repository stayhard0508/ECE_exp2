`timescale 1ns / 1ps

module testbench();

reg clk, rst;
reg  [11:0] bin; 
wire [11:0] bcd_out;

bin2bcd b2b(clk, rst, bin, bcd_out);

initial  begin
    clk = 0;
    rst = 1;
    bin = 12'b000000000000;
    #4 rst = 0;  
    #4 bin = 12'b001001001111;

end

always begin
    #2 clk <= ~clk;
end

endmodule

