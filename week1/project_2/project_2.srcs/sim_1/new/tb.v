`timescale 10ns / 100ps

module tb();
    reg t_DIP1, t_DIP2;
    wire AND,OR,NOR,NAND,XOR;
    
    logic_gate dut(
    .DIP1(t_DIP1),.DIP2(t_DIP2)
    , .LED1(AND), .LED2(OR),.LED3(NOR), .LED4(NAND), .LED5(XOR)
    );
    
    initial begin
        t_DIP1=0;t_DIP2=0;
        #10
        t_DIP1=1;t_DIP2=0;
        #10
        t_DIP1=0;t_DIP2=1;
        #10
        t_DIP1=1;t_DIP2=1;
        #10
        $stop;
    end
   
endmodule
