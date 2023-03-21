`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/21 22:20:53
// Design Name: 
// Module Name: alarm_sim
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


module alarm_sim(

    );
    // Inputs
    reg _CR;
    reg PE;
    reg [7:0] pre_min;
    reg [7:0] pre_hour;
    reg active_alarm;
    reg [7:0] show_hour;
    reg [7:0] show_min;
    reg [7:0] show_sec;
    
    // Outputs
    wire start_light_alarm;
    wire [31:0] alarm_time;

    // Instantiate the module
    alarm uut(
        ._CR(_CR),
        .PE(PE),
        .pre_min(pre_min),
        .pre_hour(pre_hour),
        .active_alarm(active_alarm),
        .show_hour(show_hour),
        .show_min(show_min),
        .show_sec(show_sec),
        .start_light_alarm(start_light_alarm),
        .alarm_time(alarm_time)
    );
    
    initial begin
        active_alarm = 1;
        _CR = 0;
        {show_hour,show_min,show_sec} = 24'h123137;
        #10;
        
        _CR = 1;
        PE = 1;
        {pre_hour,pre_min} = 16'h1232;
        {show_hour,show_min,show_sec} = 24'h123138;
        #10;
        
        PE = 0;
        {show_hour,show_min,show_sec} = 24'h123139;
        #10;
        {show_hour,show_min,show_sec} = 24'h12313a;
        #10;
        {show_hour,show_min,show_sec} = 24'h12313b;
        #10;
        {show_hour,show_min,show_sec} = 24'h123200;
        #5;
        active_alarm = 0;
        #5;
        active_alarm = 1;
        {show_hour,show_min,show_sec} = 24'h123201;
        #10;
        $stop;
    end
    
endmodule
