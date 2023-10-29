`timescale 10ns / 100ps

module testbench();

reg clk, rst, x;
wire [1:0] state;
wire y;

SM1 DFF (clk, rst, x, y, state);

initial  begin
    clk = 0;
    rst = 0;
    x = 0;
    #10 x = 0; 
    #10 rst = 1;  
    

end

always begin
    #2 clk <= ~clk;
end
endmodule

