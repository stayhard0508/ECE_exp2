`timescale 10ns / 100ps

module testbench();

reg [1:0] d0;
reg [1:0] d1;
reg [1:0] d2;
reg [1:0] d3;

reg [1:0] s; //���� �����Ҽ��ִ� reg ��������

wire [1:0] z; //���� ���Ḹ ����

mux_4x1_4in u1(d0,d1,d2,d3,s,z);

initial begin
    d0 = 2'b11;
    d1 = 2'b00;
    d2 = 2'b01;
    d3 = 2'b10;
    #20 s = 2'b00;
    #20 s = 2'b01;
    #20 s = 2'b10;
    #20 s = 2'b11;
end


endmodule
