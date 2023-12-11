module TrafficLight (
    input wire clk,
    input wire rst,
    //input wire [31:0] current_time, // 32-bit 현재 시간 입력
    output reg [3:0] led_red,
    output reg [3:0] led_yellow,
    output reg [3:0] led_green,
    output reg [3:0] led_left,
    output reg [3:0] led_walk_red,
    output reg [3:0] led_walk_green,
    output reg [3:0] count,        // 카운터
    //clock parameter
    output wire [5:0] hours,
    output wire [5:0] minutes,
    output wire [5:0] seconds
    
    
);
// 주간 상태 정의
parameter [2:0] A = 3'b001;
parameter [2:0] D = 3'b010;
parameter [2:0] F = 3'b011;
parameter [2:0] E = 3'b100;
parameter [2:0] G = 3'b101;

// 야간 상태 정의
parameter [2:0] B = 3'b110;
parameter [2:0] C = 3'b111;
parameter [2:0] H = 3'b000;

reg [2:0] state;         // 현재 상태

reg [3:0] pedestrianCount; // 보행자 신호 카운터
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
        // 주간/야간 상태 전이
        if (count == 10) begin // 5초 50000000
            if (hours >= 8 && hours < 23) // 주간
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
            else // 야간                           
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
        // 상태별 신호 출력
        case (state)
            A: 
                begin
                led_red <= 4'b0011;
                led_green <= 4'b1000;
                led_left <= 4'b0000;
                if (hours < 8 || hours >= 23) begin// 야간
                    
                    if (A_count == 0) begin // 야간 황색 신호 처리1
                        if (count == 8) // 4.9초 49000000
                            led_yellow <= 4'b1000;
                        else if (count == 10) // 5초
                            led_yellow <= 4'b0000;
                    end
                    else begin // 야간 황색 신호 처리2
                        if (count == 8) // 4.9초
                            led_yellow <= 4'b1100;
                        else if (count == 10) // 5초
                            led_yellow <= 4'b0000;
                    end
                end        
                led_walk_red <= 4'b1100;
                led_walk_green <= 4'b0011;                   
                // 보행자 신호 처리
                if (count >= 5) begin // 2.5초 25000000
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
                if (hours >= 8 && hours < 23) // 주간
                // 주간 황색 신호 처리
                    if (count == 8) begin// 4초
                        led_green <= 4'b0000;
                        led_left <= 4'b0000;
                        led_yellow <= 4'b1100;
                    end
                    else if (count == 10) // 5초
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
                    // 보행자 신호 처리
                    if (count >= 5) begin // 2.5초
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
                if (hours >= 8 && hours < 23) // 주간
                    if( E_count == 1) begin // 황색 신호 처리
                        if (count == 8) // 4초
                            led_yellow <= 4'b0010;
                        else if (count == 10) // 5초
                            led_yellow <= 4'b0000;
                    end                      
                led_walk_red <= 4'b0011;
                led_walk_green <= 4'b1100;    
                // 보행자 신호 처리
                if (count >= 5) begin // 2.5초
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
                    // 보행자 신호 처리
                    if (count >= 5) begin // 2.5초
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
                if (hours < 8 || hours >= 23) begin// 야간
                    // 야간 황색 신호 처리
                    if (count == 8) begin// 4초
                        led_yellow <= 4'b0100;
                    end
                    else if (count == 10) // 5초
                        led_yellow <= 4'b0000;
                end  
                
                led_walk_red <= 4'b1110;
                led_walk_green <= 4'b0001;
                    // 보행자 신호 처리
                    if (count >= 5) begin // 2.5초
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
                    // 보행자 신호 처리
                    if (count >= 5) begin // 2.5초
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
