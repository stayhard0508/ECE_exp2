`timescale 1ns / 1ps

module full_adder(
a, b, cin, s, cout
);

input a,b, cin;
output s,cout;

wire s, cout;
wire reg_c1,reg_c2;
wire reg_sum;

half_adder u1 (.a(a), .b(b), .s(reg_sum), .c(reg_c1));
half_adder u2 (.a(cin), .b(reg_sum), .s(s), .c(reg_c2));

assign cout = reg_c1 | reg_c2;

endmodule 

