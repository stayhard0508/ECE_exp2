module priority_encoder_4X3(
    input [3:0] Input,
    output [2:0] Output
);

always @(*) begin
    case (Input)
        4'b0001: Output = 3'b000;
        4'b0010: Output = 3'b001;
        4'b0100: Output = 3'b010;
        4'b1000: Output = 3'b100;
        default:   Output = 3'b111; // Default case, for undefined or multiple high inputs
    endcase
end

endmodule
