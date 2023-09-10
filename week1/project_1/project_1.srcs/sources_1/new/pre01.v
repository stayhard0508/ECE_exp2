`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/05 21:25:28
// Design Name: 
// Module Name: pre01
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//

module pre01(
    input DIP1, // DIP switch 1
    input DIP2, // DIP switch 2

    
    output LED1, // LED 1
    output LED2, // LED 2
    output LED3, // LED 3
    output LED4, // LED 4
    output LED5  // LED 5
    );

assign LED1 = DIP1 & DIP2; // AND gate
assign LED2 = DIP1 | DIP2; // OR gate
assign LED3 = DIP1 ^ DIP2; // XOR gate

assign LED4 = ~(DIP1 | DIP2); // NOR gate
assign LED5 = ~(DIP1 & DIP2); // NAND gate

endmodule
