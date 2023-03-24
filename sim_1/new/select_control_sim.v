`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/23 09:05:16
// Design Name: 
// Module Name: select_control_design
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


module select_control_sim(

    );
    reg _CR;
    reg mode;
    reg CP_1KHz;
    reg adjust;
    reg [31:0] show_time;
    reg [31:0] alarm_time;
    reg left;
    reg right;
    reg up;
    reg down;
    reg apply;
    reg time_mode;

    wire [63:0] display_time;
    wire [31:0] set_time;
    wire [3:0] index;
    wire PE;

    select_control select_control_s (
        ._CR(_CR),
        .mode(mode),
        .CP_1KHz(CP_1KHz),
        .adjust(adjust),
        .show_time(show_time),
        .alarm_time(alarm_time),
        .left(left),
        .right(right),
        .up(up),
        .down(down),
        .apply(apply),
        .time_mode(time_mode),
        .display_time(display_time),
        .set_time(set_time),
        .index(index),
        .PE(PE)
    );

    always #5 CP_1KHz = ~CP_1KHz;

    initial begin
        _CR = 0;
        adjust = 0;
        mode = 0;
        CP_1KHz = 0;
        time_mode = 0;
        #10;

        _CR = 1;
        show_time = 32'h10360000;
        #10;
        show_time = 32'h10360100;
        #10;
        show_time = 32'h10360200;
        #10;
        show_time = 32'h10360300;
        #10;
        $stop;
    end

endmodule
