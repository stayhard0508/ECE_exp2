`timescale 1us / 1ns


module testbench();
    
reg clk, rst, btn;

wire [7:0] seg_data;
wire [7:0] seg_sel;

seg_array sa(clk, rst, btn, seg_data, seg_sel);

initial  begin
    clk <= 0;
    rst <= 1;
    btn <= 0;
    #1e+6; rst <= 0;
    #1e+6; rst <= 1;
    #1e+6; btn <= 1;
    #1e+6; btn <= 0;
    #1e+6; btn <= 1;
    
    
    
end

always begin
    #0.5 clk <= ~clk;
end

endmodule