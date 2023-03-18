`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/18 20:54:22
// Design Name: 
// Module Name: alarm
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


module alarm(
    input _CR,
    input PE,
    input [7:0] pre_min,
    input [7:0] pre_hour,
    input active_alarm,
    input [7:0] show_hour,
    input [7:0] show_min,
    output [15:0] start_light,
    output [31:0] alarm_time
    );
endmodule
