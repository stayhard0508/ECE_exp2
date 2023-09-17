`timescale 10ns / 100ps

module testbench();

reg [3:0] i;
reg [1:0] s; //���� �����Ҽ��ִ� reg ��������

wire z; //���� ���Ḹ ����

mux_4x1 u1(i,s,z);

initial begin
    i=0; s=0;
    #20 s = 2'b01;
    #20 s = 2'b10;
    #20 s = 2'b11;
end

always  #1 i[3] = ~i[3];
always  #2 i[2] = ~i[2];
always  #4 i[1] = ~i[1];
always  #8 i[0] = ~i[0]; 

endmodule
