module TrafficLight (
    input wire clk,
    input wire rst,
    //input wire [31:0] current_time, // 32-bit ���� �ð� �Է�
    output reg [3:0] led_red,
    output reg [3:0] led_yellow,
    output reg [3:0] led_green,
    output reg [3:0] led_left,
    output reg [3:0] led_walk_red,
    output reg [3:0] led_walk_green,
    output reg [3:0] count,        // ī����
    //clock parameter
    output wire [5:0] hours,
    output wire [5:0] minutes,
    output wire [5:0] seconds
    
    
);
// �ְ� ���� ����
parameter [2:0] A = 3'b001;
parameter [2:0] D = 3'b010;
parameter [2:0] F = 3'b011;
parameter [2:0] E = 3'b100;
parameter [2:0] G = 3'b101;

// �߰� ���� ����
parameter [2:0] B = 3'b110;
parameter [2:0] C = 3'b111;
parameter [2:0] H = 3'b000;

reg [2:0] state;         // ���� ����

reg [3:0] pedestrianCount; // ������ ��ȣ ī����
reg A_count; // count state A in night
reg E_count; // count state E in day

clock ck(clk,rst, hours,minutes,seconds);

always @(posedge clk or negedge rst) begin
    if (!rst) begin

        state <= A;
        A_count <= 0;
        led_yellow <= 4'b0000;
        pedestrianCount <= 0;        
    end
    else begin
        // �ְ�/�߰� ���� ����
        if (count == 10) begin // 5�� 50000000
            if (hours >= 8 && hours < 23) // �ְ�
                case (state)
                    A: state <= D;
                    D: state <= F;
                    F: 
                        begin
                            state <= E;
                            E_count <= 1; 
                        end
                    E: 
                        begin
                        if(A_count == 1) begin
                            state <= A;
                            A_count <= 0;                        
                        end
                        else
                            state <= G;                             
                        end   
                    G: 
                        begin
                        state <= E;
                        A_count <= 1;
                        E_count <= 0;
                        end
                endcase
            else // �߰�                           
                case (state)
                    B: 
                        begin
                        state <= A;
                        end
                    A:  
                        begin
                        if(A_count == 1)
                            state <= E; 
                        else
                            state <= C;
                        end                                      
                    C: 
                        begin
                        state <= A;
                        A_count <= 1;
                        end
                    E: state <= H;
                    H: 
                        begin
                        state <= B;
                        A_count <= 0;
                        end
                endcase
            end
        end
end     

always @(posedge clk or negedge  rst)
begin
    if(!rst)
        count <= 4'b0000;
    else 
    begin
        if(count >= 10) count <= 0;
         else count <= count + 1;
    end
end  

always @(posedge clk or negedge  rst) 
begin   
        // ���º� ��ȣ ���
        case (state)
            A: 
                begin
                led_red <= 4'b0011;
                led_green <= 4'b1000;
                led_left <= 4'b0000;
                if (hours < 8 || hours >= 23) begin// �߰�
                    
                    if (A_count == 0) begin // �߰� Ȳ�� ��ȣ ó��1
                        if (count == 8) // 4.9�� 49000000
                            led_yellow <= 4'b1000;
                        else if (count == 10) // 5��
                            led_yellow <= 4'b0000;
                    end
                    else begin // �߰� Ȳ�� ��ȣ ó��2
                        if (count == 8) // 4.9��
                            led_yellow <= 4'b1100;
                        else if (count == 10) // 5��
                            led_yellow <= 4'b0000;
                    end
                end        
                led_walk_red <= 4'b1100;
                led_walk_green <= 4'b0011;                   
                // ������ ��ȣ ó��
                if (count >= 5) begin // 2.5�� 25000000
                    led_walk_green[0] <= ~led_walk_green[0];
                    led_walk_green[1] <= ~led_walk_green[1];
                    end
                //else if (pedestrianCount >= 3) 
                    //pedestrianCount <= 0;                    
                //pedestrianCount <= pedestrianCount + 1;
                end
            D:
                begin
                led_red <= 4'b0011;
                led_green <= 4'b0000;
                led_left <= 4'b0110;
                if (hours >= 8 && hours < 23) // �ְ�
                // �ְ� Ȳ�� ��ȣ ó��
                    if (count == 8) begin// 4��
                        led_green <= 4'b0000;
                        led_left <= 4'b0000;
                        led_yellow <= 4'b1100;
                    end
                    else if (count == 10) // 5��
                        led_yellow <= 4'b0000;
                    
                led_walk_red <= 4'b1111;
                led_walk_green <= 4'b0000;                   
                end
            F: 
                begin
                led_red <= 4'b1101;
                led_green <= 4'b0010;
                led_left <= 4'b0010;
                led_walk_red <= 4'b0111;
                led_walk_green <= 4'b1000;
                    // ������ ��ȣ ó��
                    if (count >= 5) begin // 2.5��
                        led_walk_green[3] <= ~led_walk_green[3];
                        end
                    //else if (pedestrianCount >= 5) 
                        //pedestrianCount <= 0;                    
                    //pedestrianCount <= pedestrianCount + 1;
                end
            E: 
                begin
                led_red <= 4'b1100;
                led_green <= 4'b1100;
                led_left <= 4'b0011;
                if (hours >= 8 && hours < 23) // �ְ�
                    if( E_count == 1) begin // Ȳ�� ��ȣ ó��
                        if (count == 8) // 4��
                            led_yellow <= 4'b0010;
                        else if (count == 10) // 5��
                            led_yellow <= 4'b0000;
                    end                      
                led_walk_red <= 4'b0011;
                led_walk_green <= 4'b1100;    
                // ������ ��ȣ ó��
                if (count >= 5) begin // 2.5��
                    led_walk_green[3] <= ~led_walk_green[3];
                    led_walk_green[2] <= ~led_walk_green[2];
                    end
                //else if (pedestrianCount >= 5) 
                    //pedestrianCount <= 0;                    
                //pedestrianCount <= pedestrianCount + 1;
                end
            G: 
                begin
                led_red <= 4'b1110;
                led_green <= 4'b0001;
                led_left <= 4'b0001;
                led_walk_red <= 4'b1011;
                led_walk_green <= 4'b0100;
                    // ������ ��ȣ ó��
                    if (count >= 5) begin // 2.5��
                        led_walk_green[2] <= ~led_walk_green[2];
                        end
                    //else if (pedestrianCount >= 5) 
                        //pedestrianCount <= 0;                    
                    //pedestrianCount <= pedestrianCount + 1;
                end
            B: 
                begin
                led_red <= 4'b0111;
                led_green <= 4'b1000; // Straight
                led_yellow <= 4'b0000;
                led_left <= 4'b1000;
                if (hours < 8 || hours >= 23) begin// �߰�
                    // �߰� Ȳ�� ��ȣ ó��
                    if (count == 8) begin// 4��
                        led_yellow <= 4'b0100;
                    end
                    else if (count == 10) // 5��
                        led_yellow <= 4'b0000;
                end  
                
                led_walk_red <= 4'b1110;
                led_walk_green <= 4'b0001;
                    // ������ ��ȣ ó��
                    if (count >= 5) begin // 2.5��
                        led_walk_green[0] <= ~led_walk_green[0];
                        end
                    //else if (pedestrianCount >= 5) 
                        //pedestrianCount <= 0;                    
                    //pedestrianCount <= pedestrianCount + 1;
                end
            C: 
                begin
                led_red <= 4'b1110; //stop
                led_green <= 4'b0100; // Straight
                led_left <= 4'b0100;
                led_walk_red <= 4'b1101;
                led_walk_green <= 4'b0010;
                    // ������ ��ȣ ó��
                    if (count >= 5) begin // 2.5��
                        led_walk_green[1] <= ~led_walk_green[1];
                        end
                    //else if (pedestrianCount >= 5) 
                        //pedestrianCount <= 0;                    
                    //pedestrianCount <= pedestrianCount + 1;
                end
            H: 
                begin
                led_red <= 4'b1100;
                led_green <= 4'b0000;
                led_left <= 4'b0011;
                led_walk_red <= 4'b1111;
                led_walk_green <= 4'b0000;
                end
        endcase 
end

endmodule
