
module mux_4x1(i,s,z);

input [3:0] i;
input [1:0] s;

output z;

reg z; //값을 저장하는 변수

always  @(i ,s)
    case(s)
        2'b00: z <= i[3]; //00일경우 z에 i[3]값 대입
        2'b01: z <= i[2];
        2'b10: z <= i[1];
        2'b11: z <= i[0];
        default : z <= 0;
    endcase 
        
endmodule
