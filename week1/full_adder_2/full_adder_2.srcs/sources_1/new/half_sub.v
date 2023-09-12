`timescale 1ns / 1ps


module half_sub(
a,b,d, bor
    );
input a,b;

output d,bor;

assign  d = a^b;

assign bor = a & b;

endmodule
