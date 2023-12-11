module TimeExample;

  reg [31:0] current_time;
  reg [5:0] hours;
  reg [5:0] minutes;
  reg [5:0] seconds;

  initial begin
    current_time = 32'h0; // Initialize time to zero
    hours = 6'b0; // Initialize hours to zero
    minutes = 6'b0; // Initialize minutes to zero
    seconds = 6'b0; // Initialize seconds to zero

    // Simulation loop
    repeat (3600) begin
      #1; // Simulate 1 time unit passing
      current_time = current_time + 32'h1; // Increment time by 1 unit

      // Increment seconds and reset to zero when reaching 60
      if (seconds == 6'b59) begin
        seconds = 6'b0;
        
        // Increment minutes and reset to zero when reaching 60
        if (minutes == 6'b59) begin
          minutes = 6'b0;
          
          // Increment hours and reset to zero when reaching 24
          if (hours == 6'b23) begin
            hours = 6'b0;
          end else begin
            hours = hours + 6'b1;
          end
        end else begin
          minutes = minutes + 6'b1;
        end
      end else begin
        seconds = seconds + 6'b1;
      end
      
      $display("Current Time: %0d:%0d:%0d", hours, minutes, seconds);
    end

    $finish; // End the simulation
  end

endmodule
