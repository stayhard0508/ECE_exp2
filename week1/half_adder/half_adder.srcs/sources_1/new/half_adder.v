`timescale 1ns / 1ps

// Create Date: 2023/09/08 16:11:58
// Design Name: 2016440097 


module halfadder(a,b,sum,carry);
input a,b;
output sum,carry;

assign sum=  a & ~b | ~a & b;
assign carry=a&b;

endmodule
