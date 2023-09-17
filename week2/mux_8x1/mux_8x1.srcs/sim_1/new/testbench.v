`timescale 10ns / 100ps

module testbench();

reg [7:0] i;
reg [2:0] s;

wire z;

mux_8x1 u1(i,s,z);

initial begin 
    i=0; s=0;
    #5 s = 3'b000;
    #5 s = 3'b001;
    #5 s = 3'b010;
    #5 s = 3'b011;
    #5 s = 3'b100;
    #5 s = 3'b101;
    #5 s = 3'b110;
    #5 s = 3'b111;
    end
always #1 i[7]=~i[7];  // #1 초마다 실행
always #2 i[6]=~i[6];
always #3 i[5]=~i[5];
always #4 i[4]=~i[4];
always #5 i[3]=~i[3];
always #6 i[2]=~i[2];
always #7 i[1]=~i[1];
always #8 i[0]=~i[0];

endmodule
