module priority_encoder(a, i);

input [3:0]i;
output [1:0]a;

reg [1:0]a;

always@(i)
begin

casex(i)

4'b0001:a = 2'b00;
4'b001x:a = 2'b01;
4'b01xx:a = 2'b10;
4'b1xxx:a = 2'b11;

endcase
end
endmodule