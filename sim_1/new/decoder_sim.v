`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/23 08:40:55
// Design Name: 
// Module Name: decoder_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decoder_sim(

    );
      // Inputs
  reg _CR;
  reg [63:0] display_time;
  reg [3:0] index;
  reg adjust;
  reg CP_1KHz;

  // Outputs
  wire [7:0] select_light;
  wire [7:0] display_char;
  wire [3:0] cnt_normal;

  decoder decoder_s (
    ._CR(_CR),
    .display_time(display_time),
    .index(index),
    .adjust(adjust),
    .CP_1KHz(CP_1KHz),
    .select_light(select_light),
    .display_char(display_char),
    .cnt_normal(cnt_normal)
  );
    always #5 CP_1KHz = ~ CP_1KHz;
    initial begin
        CP_1KHz = 0;
        _CR  = 0;
        adjust = 0;
        #10;
        
        _CR = 1;
        display_time = 64'b1100000011111001101001001011000010011001100100101000001011111000;
        #160;
        $stop;
    end
endmodule
