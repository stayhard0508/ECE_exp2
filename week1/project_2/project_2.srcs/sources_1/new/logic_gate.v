`timescale 10ns / 100ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 2023/09/07 19:00:10
// Design Name: 2016440097 ¿Ã¿Œ¿Á

//////////////////////////////////////////////////////////////////////////////////
// input a, b,
// output ow_and, ow_or, ow_nor, ow_nand, ow_xor);
// assign ow_and   = a & b;
// assign ow_or    = a | b;
// assign ow_xor   = a ^ b;
// assign ow_nor   = ~(a | b);
//   assign ow_nand  = ~(a & b);

module logic_gate(

    input DIP1, DIP2,
    output LED1, LED2, LED3, LED4, LED5);
    assign LED1   = DIP1 & DIP2;
    assign LED2    = DIP1 | DIP2;
    assign LED3   = DIP1 ^ DIP2;
    assign LED4   = ~(DIP1 | DIP2);
    assign LED5  = ~(DIP1 & DIP2);
endmodule
