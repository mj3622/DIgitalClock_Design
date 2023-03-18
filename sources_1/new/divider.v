module divider(
    input CP,           // Input signal with a frequency of 100MHz
    input _CR,          // Low-active reset signal
    output reg CP_1Hz,  // Output signal with a frequency of 1Hz
    output reg CP_1KHz  // Output signal with a frequency of 1KHz
    );
  
  reg [31:0] counter_1Hz = 32'h0; // Counter for 1Hz signal, initialized to 0
  reg [31:0] counter_1KHz = 32'h0; // Counter for 1KHz signal, initialized to 0

  always @(posedge CP or negedge _CR) begin
    if (~_CR) begin      // If reset signal is active, reset the counters
      counter_1Hz <= 32'h0;
      counter_1KHz <= 32'h0;
    end else begin
      counter_1Hz <= counter_1Hz + 1; // Increment the 1Hz counter every clock cycle
      counter_1KHz <= counter_1KHz + 1; // Increment the 1KHz counter every clock cycle

      // When the 1Hz counter reaches 99,999,999, set the 1Hz signal high and reset the counter
      if (counter_1Hz == 99_999_999) begin 
        CP_1Hz <= 1'b1;
        counter_1Hz <= 32'h0;
      end else begin
        CP_1Hz <= 1'b0;
      end
      
      // When the 1KHz counter reaches 99,999, set the 1KHz signal high and reset the counter
      if (counter_1KHz == 99_999) begin 
        CP_1KHz <= 1'b1;
        counter_1KHz <= 32'h0;
      end else begin
        CP_1KHz <= 1'b0;
      end
    end
  end
endmodule
