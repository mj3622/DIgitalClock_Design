`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/18 20:54:22
// Design Name: 
// Module Name: select_control
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


module select_control(
    input _CR,
    input mode,
    input CP_1KHz,
    input adjust,
    input [31:0] show_time,
    input [31:0] alarm_time,
    input left,
    input right,
    input up,
    input down,
    input apply,
    input time_mode,
    output [31:0] display_time,
    output [7:0] index,
    output PE
    );
endmodule
