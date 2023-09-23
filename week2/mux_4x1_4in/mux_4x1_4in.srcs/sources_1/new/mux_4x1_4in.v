
module mux_4x1_4in(d0,d1,d2,d3,s,z);
input [1:0] d0;
input [1:0] d1;
input [1:0] d2;
input [1:0] d3;

input [1:0] s;

output [1:0] z;

reg [1:0] z; //���� �����ϴ� ����

always  @(d0,d1,d2,d3,s)
    case(s)
        2'b00: z <= d0; //00�ϰ�� z�� i[3]�� ����
        2'b01: z <= d1;
        2'b10: z <= d2;
        2'b11: z <= d3;
        default : z <= 0;
    endcase 

endmodule
