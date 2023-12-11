module oneshot_universal(clk, rst, btn, btn_trig);

parameter WIDTH = 1;
input clk, rst, btn;
reg [WIDTH-1 :0] btn_reg;
output reg [WIDTH-1 :0] btn_trig;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        btn_reg <= {WIDTH{1'b0}};
        btn_trig <= {WIDTH{1'b0}};
    end
    else begin
        btn_reg <= btn;
        //btn_trig <= btn_reg; //no oneshot
        btn_trig <= btn & ~btn_reg;//oneshot
    end
end
endmodule