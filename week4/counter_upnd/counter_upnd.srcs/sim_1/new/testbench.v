`timescale 10ns / 100ps

module testbench();

reg clk, rst, x;
wire [2:0] state;

counter_upnd upnd (clk, rst, x, state);

initial  begin
    clk = 0;
    rst = 0;
    x = 0;
    #5 x = 1;
    #5 rst = 1;
    

end

always begin
    #1 clk <= ~clk;
end
endmodule

