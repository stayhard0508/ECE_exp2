`timescale 10ns / 100ps


module testbench();

reg a,b,c;

wire d, bor;

full_sub u1(a,b,c,d, bor);

initial begin 
        a = 0; b = 0; c = 0;
    #10 a = 1; b = 0; c = 0;   
    #10 a = 0; b = 1; c = 0;
    #10 a = 1; b = 1; c = 0;  
    #10 a = 0; b = 0; c = 1;  
    #10 a = 1; b = 0; c = 1;  
    #10 a = 0; b = 1; c = 1;  
    #10 a = 1; b = 1; c = 1;    
    #10 a = 0; b = 0; c = 0;   
end    

endmodule
