`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 2023/09/07 20:05:18
// Design Name: 2016440097 ¿Ã¿Œ¿Á


module half_adder(a,b,sum,carry);
input a,b;
output sum,carry;

assign sum=a^b;
assign carry=a&b;

endmodule
