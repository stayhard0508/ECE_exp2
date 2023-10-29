`timescale 10ns / 100ps

module testbench();

reg clk, rst, A,B,C;
wire [2:0] state;
wire y;

vm vending_machine(clk, rst, A, B, C, state, y);

initial  begin
    clk = 0;
    rst = 0;
    A=0;
    B=0;
    C=0;
    #5 rst = 1;  
    #5 A = 1; B = 0; C = 0;
    #5 A = 0; B = 1; C = 0;
    #5 A = 1; B = 0; C = 0;
    #5 A = 0; B = 1; C = 0;
    #5 A = 0; B = 0; C = 1; 
    #5 rst = 0;
    #5 rst = 1;
    #5 A = 1; B = 0; C = 0;
    #5 A = 0; B = 1; C = 0;
    #5 A = 0; B = 0; C = 1; 

end

always begin
    #1 clk <= ~clk;
end

endmodule
