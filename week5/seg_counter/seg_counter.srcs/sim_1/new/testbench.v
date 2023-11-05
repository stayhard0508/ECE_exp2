`timescale 10ns / 100ps


module testbench();
    
reg clk, rst, btn;

wire [7:0] seg;

seg_counter sc(clk, rst, btn, seg);

initial  begin
    clk = 0;
    rst = 0;
    btn = 0;
    #4 rst = 1;  
    #30 btn <= ~btn;
    #2 btn <= ~btn;
    #10 btn <= ~btn;
    #2 btn <= ~btn;
end

always begin
    #2 clk <= ~clk;
    
end

endmodule