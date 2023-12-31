module TrafficLight (
    input wire clk,
    input wire rst,
    input wire [5:0] hours,
    input wire [5:0] minutes,
    input wire [5:0] seconds,  
    input wire btn_speed,
    input wire btn_1h,
    input wire btn_stop, 
    
    //input wire [31:0] current_time, // 32-bit 현재 시간 입력
    output reg [3:0] led_red,
    output reg [3:0] led_yellow,
    output reg [3:0] led_green,
    output reg [3:0] led_left,
    output reg [3:0] led_walk_red,
    output reg [3:0] led_walk_green,
    output reg [3:0] count,        // 카운터
    //clock parameter
      
    output reg [3:0] state         // 현재 상태
);
// 주간 상태 정의
parameter [3:0] A = 4'b0001;
parameter [3:0] B = 4'b0010;
parameter [3:0] C = 4'b0011;
parameter [3:0] D = 4'b0100;
parameter [3:0] E = 4'b0101;

// 야간 상태 정의
parameter [3:0] F = 4'b0110;
parameter [3:0] G = 4'b0111;
parameter [3:0] H = 4'b1000;



reg [3:0] pedestrianCount; // 보행자 신호 카운터
reg A_count; // count state A in night
reg E_count; // count state E in day

reg [5:0] seconds_reg; //clock ck2(clk,rst, btn_speed,btn_1h, hours,minutes,seconds);

reg [5:0] down_count; //for stop button
reg [5:0] down_count_reg; //for stop button
reg [3:0] state_reg; //for stop button  
wire btn_stop_trig;

oneshot_universal #(.WIDTH(1)) O2(clk, rst, btn_stop, btn_stop_trig);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        down_count <= 0;
        down_count_reg <= 0;
        state <= A;
        A_count <= 0;
        led_yellow <= 4'b0000;
        led_red <= 4'b0000; 
        led_green <= 4'b0000; 
        led_left <= 4'b0000; 
        led_walk_red <= 4'b0000;
        led_walk_green <= 4'b0000; 
        pedestrianCount <= 0;
        
                
    end
    else begin
        //stop button
        if (btn_stop_trig == 1) begin //if press button stop 
            down_count = 15; 
            state_reg <= state;
            state <= A;
        end
        else if (down_count > 0 && seconds > seconds_reg) begin
            down_count_reg <= down_count;
            down_count = down_count - 1;
        end 
        else if (down_count > 0 && seconds_reg == 60) begin
            down_count_reg <= down_count;
            down_count = down_count - 1;
        end      
        else if ( down_count == 0 && down_count_reg > down_count ) begin
            down_count_reg <= down_count;
            state <= state_reg;
        end  
        // 주간/야간 상태 전이
        else if (count == 10) begin // 5초 50000000            
            if (hours >= 8 && hours < 23) // 주간
                case (state)
                    A: //if(down_count == 0) 
                    state <= D;
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
                        if(down_count == 0)
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
always @(posedge clk or negedge rst) 
begin
    if(!rst) count <= 4'b0000;  
    else begin
        if(count >= 10) count <= 0;
        else if(seconds > seconds_reg) count <= count + 1; //|| seconds == 60
        seconds_reg <= seconds;    
        // 상태별 신호 출력
        case (state)
            A: 
                begin
                led_red <= 4'b0111; //0011
                led_green <= 4'b0000; //1100
                led_left <= 4'b1111; // 0000
                
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
                if (count == 0)
                    led_walk_green <= 4'b0011;                   
                // 보행자 신호 처리
                if (count >= 5 && seconds > seconds_reg) begin // 2.5초 25000000
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
                led_left <= 4'b1100;
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
                if (count == 0)
                    led_walk_green <= 4'b1000;
                // 보행자 신호 처리
                if (count >= 5 && seconds > seconds_reg) begin // 2.5초
                    led_walk_green[3] <= ~led_walk_green[3];
                    end
                //else if (pedestrianCount >= 5) 
                    //pedestrianCount <= 0;                    
                //pedestrianCount <= pedestrianCount + 1;
                end
            E: 
                begin
                led_red <= 4'b1100;
                led_green <= 4'b0011;
                led_left <= 4'b0000;
                if (hours >= 8 && hours < 23) // 주간
                    if( E_count == 1) begin // 황색 신호 처리
                        if (count == 8) // 4초
                            led_yellow <= 4'b0010;
                        else if (count == 10) // 5초
                            led_yellow <= 4'b0000;
                    end                      
                led_walk_red <= 4'b0011;
                if (count == 0)
                    led_walk_green <= 4'b1100;    
                // 보행자 신호 처리
                if (count >= 5 && seconds > seconds_reg) begin // 2.5초
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
                if (count == 0)
                    led_walk_green <= 4'b0100;
                // 보행자 신호 처리
                if (count >= 5 && seconds > seconds_reg) begin // 2.5초
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
                if (count == 0)
                    led_walk_green <= 4'b0001;
                // 보행자 신호 처리
                if (count >= 5 && seconds > seconds_reg) begin // 2.5초
                    led_walk_green[0] <= ~led_walk_green[0];
                    end
                //else if (pedestrianCount >= 5) 
                    //pedestrianCount <= 0;                    
                //pedestrianCount <= pedestrianCount + 1;
                end
            C: 
                begin
                led_red <= 4'b1011; //stop
                led_green <= 4'b0100; // Straight
                led_left <= 4'b0100;
                led_walk_red <= 4'b1101;
                if (count == 0)
                    led_walk_green <= 4'b0010;
                // 보행자 신호 처리
                if (count >= 5 && seconds > seconds_reg) begin // 2.5초
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
   
end  
endmodule

