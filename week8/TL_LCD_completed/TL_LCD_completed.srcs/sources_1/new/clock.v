module clock(
    input wire clk,
    input wire rst,
    input wire btn_speed,
    input wire btn_1h,
    output reg [5:0] hours,
    output reg [5:0] minutes,
    output reg [5:0] seconds
);

wire btn_speed_trig;
wire btn_1h_trig;
reg [12:0] CLK_FREQUENCY; // 1 MHz
reg [3:0] clk_speed;
reg [31:0] timer;

// Clock frequency setting (1 MHz as an example)
//reg CLK_FREQUENCY; // 1 MHz

oneshot_universal #(.WIDTH(1)) O1(clk, rst, btn_speed, btn_speed_trig);
oneshot_universal #(.WIDTH(1)) O2(clk, rst, btn_1h, btn_1h_trig);

always  @(negedge rst or posedge clk) begin
    if(!rst) clk_speed <= 0;
    else begin
        if (btn_1h_trig == 1) begin
        hours <= hours + 1;
            if (hours == 24) begin
                  hours <= 0;
            end
        end 
        if(clk_speed == 3 && btn_speed_trig == 1) begin
        clk_speed <= 0;
        timer = 0;
        //seconds = 0;
        end
        else if(btn_speed_trig == 1) begin
        clk_speed <= clk_speed + 1;
        timer = 0;
        //seconds = 0;
        end   
    end
end

always @(*) begin
    case(clk_speed)
        0 : CLK_FREQUENCY = 5000; // 1 time
        1 : CLK_FREQUENCY = 500; // 10times
        2 : CLK_FREQUENCY = 50; // 100times
        3 : CLK_FREQUENCY = 25; // 200times
        default  : CLK_FREQUENCY = 5000; 
    endcase   
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
      timer <= 0;
      hours <= 6'b0;
      minutes <= 6'b0;
      seconds <= 6'b0;
    end else begin
      // 1초마다 타이머 값을 증가
      if (timer == CLK_FREQUENCY - 1) begin
        timer <= 0;
        // 시, 분, 초 업데이트
        seconds <= seconds + 1;
        if (seconds == 60) begin
          seconds <= 0;
          minutes <= minutes + 1;
          if (minutes == 60) begin
            minutes <= 0;
            hours <= hours + 1;
            if (hours == 24) begin
              hours <= 0;
            end
          end
        end
      end else begin
        timer <= timer + 1;
      end
    end
end

endmodule
