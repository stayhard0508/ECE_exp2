module JKFF(
  input J, // JK flip-flop J input
  input K, // JK flip-flop K input
  input CLK, // Clock input
  input RESET, // Reset input
  output reg Q, // Output Q
  output reg Qn // Output Q' (complement of Q)
  );
    
 always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
      Q <= 0;
      Qn <= 0;
    end else begin
      case ({J, K})
        2'b00: {Q, Qn} <= {Q, Qn}; // No change
        2'b01: {Q, Qn} <= {1'b0, 1'b1}; // Reset
        2'b10: {Q, Qn} <= {1'b1, 1'b0}; // Set
        2'b11: {Q, Qn} <= {~Q, ~Qn}; // Toggle
      endcase
    end
  end

endmodule
