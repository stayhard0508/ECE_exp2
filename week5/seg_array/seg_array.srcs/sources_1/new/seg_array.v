
module seg_array(clk, rst, btn, seg_data, seg_sel);

input clk, rst;
input btn;
wire btn_trig;
reg [3:0] state_bin;
wire [7:0] state_bcd;
output reg [7:0] seg_data;
output reg [7:0] seg_sel;
reg[3:0] bcd;

oneshot_universal #(.WIDTH(1)) O1(clk, rst, btn, btn_trig);
bin2bcd b2(clk,rst, state_bin[3:0], state_bcd[7:0]);

always  @(negedge rst or posedge clk) begin
    if(!rst) state_bin <= 4'b0000;
    else if(state_bin == 4'b1111 && btn_trig == 1) state_bin <= 4'b0000;
    else if(btn_trig == 1) state_bin <= state_bin + 1;
end
//count ����

always  @(negedge rst or posedge clk) begin
    if(!rst) seg_sel <= 8'b11111110;
    else begin 
        seg_sel <= {seg_sel[6:0], seg_sel[7]};
    end
end
// segment array ��Ŭ������ ����

always @(*) begin
    case(bcd[3:0])
        0 : seg_data <= 8'b11111100;
        1 : seg_data <= 8'b01100000;
        2 : seg_data <= 8'b11011010;
        3 : seg_data <= 8'b11110010;
        4 : seg_data <= 8'b01100110;
        5 : seg_data <= 8'b10110110;
        6 : seg_data <= 8'b10111110;
        7 : seg_data <= 8'b11100000;
        8 : seg_data <= 8'b11111110;
        9 : seg_data <= 8'b11110110;
        default  : seg_data <= 8'b00000000;
    endcase   
end

always @(*) begin
    case(seg_sel)
        8'b11111110 : bcd = state_bcd[3:0];
        8'b11111101 : bcd = state_bcd[7:4];
        8'b11111011 : bcd = 4'b0000;
        8'b11110111 : bcd = 4'b0000;
        8'b11101111 : bcd = 4'b0000;
        8'b11011111 : bcd = 4'b0000;
        8'b10111111 : bcd = 4'b0000;
        8'b01111111 : bcd = 4'b0000;
        default  : bcd = 4'b0000;
    endcase   
end
endmodule
