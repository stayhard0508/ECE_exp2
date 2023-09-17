`timescale 10ns / 100ps

module PriorityEncoder_Test();
 //Reg and Wire declarations
 reg [3:0] Y;
 wire [1:0] A;
 
 // Instantiate the Unit Under Test (UUT)
priority_encoder u1(Y,A);
 initial begin

     Y = 4'b0000;
 #10 Y = 4'b1000;
 #10 Y = 4'b0100;
 #10 Y = 4'b0010;
 #10 Y = 4'b0001;
 #10 Y = 4'b1010;
 #10 Y = 4'b1111;
 end 
     
endmodule