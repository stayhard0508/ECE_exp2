`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 2016440097 ������

module half_adder_case( sum, carry, a);
output sum, carry;
input [1:0] a; //2 bit input a

reg sum, carry; //���� ������ �ִ� ���� ����(�������Ϳ� ����)
//wire�� ���� �����ϴ� ���� ���
always @(a) //simulation level sentence
    case(a)
    2'b00: begin sum = 0; carry =0 ; end //2��Ʈ 2����
    2'b01: begin sum = 1; carry =0 ; end
    2'b10: begin sum = 1; carry =0 ; end
    2'b11: begin sum = 0; carry =1 ; end
    endcase

endmodule
