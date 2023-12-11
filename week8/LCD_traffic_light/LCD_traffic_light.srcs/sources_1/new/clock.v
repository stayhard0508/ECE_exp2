module clock(
  input wire clk,
  input wire rst,
  output reg [5:0] hours,
  output reg [5:0] minutes,
  output reg [5:0] seconds
);

  reg [31:0] timer;

  // Clock frequency setting (1 MHz as an example)
  parameter CLK_FREQUENCY = 50; // 1 MHz

always @(posedge clk or negedge rst) begin
    if (!rst) begin
      timer = 0;
      hours <= 6'b000000;
      minutes <= 6'b000000;
      seconds <= 6'b000000;
    end else begin
      // 1초마다 타이머 값을 증가
      if (timer == CLK_FREQUENCY - 1) begin
        timer = 0;
        // 시, 분, 초 업데이트
        seconds = seconds + 1;
        if (seconds == 60) begin
          seconds = 0;
          minutes = minutes + 1;
          if (minutes == 60) begin
            minutes = 0;
            hours = hours + 1;
            if (hours == 24) begin
              hours = 0;
            end
          end
        end
      end else begin
        timer = timer + 1;
      end
    end
end

endmodule
