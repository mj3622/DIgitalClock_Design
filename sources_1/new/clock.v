`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/18 20:54:22
// Design Name: 
// Module Name: clock
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


module clock(
    input CP,
    input _CR,
    input mode,
    input adjust,
    input time_mode,
    input active_alarm,
    input left,
    input right,
    input up,
    input down,
    output [15:0] start_light,
    output [7:0] select_light,
    output [7:0] display_char
    );
endmodule
