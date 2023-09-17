`timescale 10ns / 100ps

module testbench();

reg a,b,c;

wire [7:0] o;

decoder3X8 u1(a,b,c,o);

initial begin
        a=0; b=0; c=0;
    #10 a=0; b=0; c=1;
    #10 a=0; b=1; c=0;
    #10 a=0; b=1; c=1;
    #10 a=1; b=0; c=0;
    #10 a=1; b=0; c=1;
    #10 a=1; b=1; c=0;
    #10 a=1; b=1; c=1;
    #10 a=0; b=0; c=0;    
end    

endmodule
