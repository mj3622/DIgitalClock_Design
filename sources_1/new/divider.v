module divider(
    input CP,           // Input signal with a frequency of 100MHz
    input _CR,          // Low-active reset signal
    output reg CP_1Hz,  // Output signal with a frequency of 1Hz
    output reg CP_1KHz, // Output signal with a frequency of 1KHz
    output reg CP_10Hz  // Output signal with a frequency of 10Hz
    );
  
  reg [31:0] counter_1Hz = 32'h0; // Counter for 1Hz signal, initialized to 0
  reg [31:0] counter_1KHz = 32'h0; // Counter for 1KHz signal, initialized to 0
    reg [31:0] counter_10Hz = 32'h0; // Counter for 10Hz signal, initialized to 0

  parameter CLK_Freq_1Hz = 100000000, CLK_Freq_1KHz = 100000, CLK_Freq_10Hz = 15000000;
  parameter CLK_Freq_1Hz_test = 4000, CLK_Freq_1KHz_test = 4;   // for test

  always @(posedge CP or negedge _CR) begin
    if (~_CR) begin      // If reset signal is active, reset the counters
      counter_1Hz <= 32'h0;
      counter_10Hz <= 32'h0;
      counter_1KHz <= 32'h0;
      CP_1Hz = 0;
      CP_1KHz = 0;
    end else begin
      if (counter_1Hz == CLK_Freq_1Hz/2 - 1) begin 
        CP_1Hz = ~CP_1Hz;
        counter_1Hz <= 32'h0;
      end else begin
        counter_1Hz <= counter_1Hz + 1; // Increment the 1Hz counter every clock cycle
      end
      
      if (counter_10Hz == CLK_Freq_10Hz/2 - 1) begin 
        CP_10Hz = ~CP_10Hz;
        counter_10Hz <= 32'h0;
      end else begin
        counter_10Hz <= counter_10Hz + 1; // Increment the 10Hz counter every clock cycle
      end

      if (counter_1KHz == CLK_Freq_1KHz/2 - 1) begin 
        CP_1KHz = ~CP_1KHz;
        counter_1KHz <= 32'h0;
      end else begin
        counter_1KHz <= counter_1KHz + 1; // Increment the 1KHz counter every clock cycle
      end
    end
  end
endmodule
