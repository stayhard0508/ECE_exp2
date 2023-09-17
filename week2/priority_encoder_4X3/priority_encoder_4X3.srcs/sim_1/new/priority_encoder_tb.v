`timescale 10ns / 100ps

module priority_encoder_tb();

 reg [3:0] i;
 wire [1:0] a;
 
 priority_encoder u1(a, i); //변수 가져오는 순서 바꾸지 말기
 initial begin

  i = 4'b0000;
 #10 i = 4'b1000;
 #10 i = 4'b1011;
 #10 i = 4'b0101;
 #10 i = 4'b0001;
 
 end 
     
endmodule
