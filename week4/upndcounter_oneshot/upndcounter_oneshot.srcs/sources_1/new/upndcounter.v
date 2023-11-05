
module upndcounter(clk, rst, x, state);

input clk, rst;
input x;
reg x_reg, x_trig;
reg y_sw;
output reg [2:0] state;

always @(negedge  rst or posedge clk) begin
    if(!rst) begin
        {x_reg, x_trig} <= 2'b00;
    end
    else begin
        x_reg <= x;
        x_trig <= x & ~x_reg;
    end
end


always @(negedge rst or posedge clk) begin
    if(!rst) begin 
    state <= 2'b000;
    y_sw = 1;
    end
    else begin
        if (y_sw) begin
        // up-counter
            case(state)
                3'b000 : state <= x_trig ? 3'b001 : 3'b000;
                3'b001 : state <= x_trig ? 3'b010 : 3'b001;
                3'b010 : state <= x_trig ? 3'b011 : 3'b010;
                3'b011 : state <= x_trig ? 3'b100 : 3'b011;
                3'b100 : state <= x_trig ? 3'b101 : 3'b100;
                3'b101 : state <= x_trig ? 3'b110 : 3'b101;
                3'b110 : state <= x_trig ? 3'b111 : 3'b110;
                3'b111 : y_sw = 0;
            endcase
         end else begin
         // douwn-counter   
            case(state)
                3'b111 : state <= x_trig ? 3'b110 : 3'b111;
                3'b110 : state <= x_trig ? 3'b101 : 3'b110;
                3'b101 : state <= x_trig ? 3'b100 : 3'b101;
                3'b100 : state <= x_trig ? 3'b011 : 3'b100;
                3'b011 : state <= x_trig ? 3'b010 : 3'b011;
                3'b010 : state <= x_trig ? 3'b001 : 3'b010;
                3'b001 : state <= x_trig ? 3'b000 : 3'b011;
                3'b000 : y_sw = 1;
            endcase
        end
   end
end         
endmodule