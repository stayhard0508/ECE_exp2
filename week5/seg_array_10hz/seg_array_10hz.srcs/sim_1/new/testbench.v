`timescale 10ns / 10ps


module testbench();
    
reg clk, rst, btn;

wire [7:0] seg_data;
wire [7:0] seg_sel;

seg_array sa(clk, rst, btn, seg_data, seg_sel);

initial  begin
    clk = 0;
    rst = 0;
    btn = 0;
    #4 rst = 1;  
    
end

always begin
    #1 clk <= ~clk;
end

always begin
    #24 //delay
    #1 btn <= ~btn;
    #1 btn <= ~btn;
end
endmodule