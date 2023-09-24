`timescale 1ns / 1ps

module JKFF_behav_test();

  reg clk;
  reg reset;
  reg [1:0] jk_data; // {J, K} data

  wire q;
  wire qn;
   // Instantiate the JK flip-flop
  JKFF FF(
    .J(jk_data[0]),
    .K(jk_data[1]),
    .CLK(clk),
    .RESET(reset),
    .Q(q),
    .Qn(qn)
  ); 
   // Clock generation
  always begin
    #5 clk = ~clk; // Toggle the clock every 5 time units
  end
// Initialize signals
  initial begin
    clk = 0;
    reset = 0;
    jk_data = 2'b00; // Initial {J, K} values

    #10 jk_data = 2'b01;
    #10 jk_data = 2'b00;
    #10 jk_data = 2'b10;
    #10 jk_data = 2'b00;
    #10 jk_data = 2'b11;
    #10 jk_data = 2'b00;
    
  end
endmodule
