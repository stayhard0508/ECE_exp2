
module oneshot(clk, rst, btn, btn_trig);

input clk, rst, btn;
reg btn_reg;
output reg btn_trig;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        btn_reg <= 0;
        btn_trig <= 0;
    end
    else begin
        btn_reg <= btn;
        //btn_trig <= btn_reg; //no oneshot
        btn_trig <= btn & ~btn_reg;//oneshot
    end
end

endmodule
