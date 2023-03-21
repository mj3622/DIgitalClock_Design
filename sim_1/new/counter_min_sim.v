`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/21 21:25:31
// Design Name: 
// Module Name: counter_min_sim
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


module counter_min_sim(

    );
    reg cin_sec;
    reg [7:0] pre_min;
    reg _CR;
    reg PE;
    wire cin_min;
    wire [7:0] show_min;
    
    counter_min counter_min_s(
        .cin_sec(cin_sec),
        .pre_min(pre_min),
        ._CR(_CR),
        .PE(PE),
        .cin_min(cin_min),
        .show_min(show_min)
    );

    always #5 cin_sec = ~cin_sec;
    
    initial begin
        // tset reset
        _CR = 0;
        cin_sec = 0;
        #10;
        
        //test set
        _CR = 1;
        PE = 1;
        pre_min = 8'd55;
        #5;
        
        //start work
        PE = 0;
        #105;
        $stop;
    end
endmodule
