`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/21 21:03:49
// Design Name: 
// Module Name: counter_sec_sim
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


module counter_sec_sim(

    );
    reg CP_1Hz;
    reg adjust;
    reg _CR;
    reg mode;
    reg PE;
    reg [7:0] pre_sec;

    wire [7:0] show_sec;
    wire cin_sec;

    counter_sec counter_sec_s (
        .CP_1Hz(CP_1Hz),
        .adjust(adjust),
        ._CR(_CR),
        .mode(mode),
        .PE(PE),
        .pre_sec(pre_sec),
        .show_sec(show_sec),
        .cin_sec(cin_sec)
    );
    always #5 CP_1Hz = ~CP_1Hz;
    initial begin
        // tset reset
        _CR = 0;
        CP_1Hz = 0;
        #10;
        
        // test set        
        _CR = 1;
        PE = 1;
        pre_sec = 8'd56;
        #10;
        
        // test stop
        PE = 0;
        adjust = 1;
        mode = 0;
        #20;
        
        // start work
        adjust = 0;
        #100;
        $stop;
    end
endmodule
