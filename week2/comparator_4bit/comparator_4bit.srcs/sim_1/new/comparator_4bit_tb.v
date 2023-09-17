`timescale 10ns / 100ps


module comparator_4bit_tb();

reg [3:0] a,b;

wire x,y,z;

comparator_4bit u1(a,b,x,y,z);

initial  begin 

//    #10 a=4'b0011; b=4'b1000;
//    #10 a=4'b0111; b=4'b0001;
//      #10 a=4'b1001; b=4'b1001;
   #10 a=4'b1011; b=4'b1111;
end
    
endmodule
