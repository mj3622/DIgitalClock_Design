`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/18 20:54:22
// Design Name: 
// Module Name: splitter
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


module splitter(
    input _CR,
    input [31:0] display_time,
    input time_mode,
    input mode,
    output [7:0] pre_sec,
    output [7:0] pre_min,
    output [7:0] pre_hour,
    output PE_alarm,
    output PE_counter
    );
endmodule
