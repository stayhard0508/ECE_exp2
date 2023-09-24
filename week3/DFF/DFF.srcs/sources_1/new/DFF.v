
module DFF(clk, D, Q);

input D, clk;
output reg Q;

always @(posedge clk) //always 안의 실행문은 한clk 내에서 실행
begin
    Q <= D;
end
endmodule
