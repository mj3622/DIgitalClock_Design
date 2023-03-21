`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/21 21:44:25
// Design Name: 
// Module Name: counter_hour_sim
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


module counter_hour_sim(

    );
    
    // Inputs
    reg cin_min;
    reg PE;
    reg _CR;
    reg [7:0] pre_hour;

    // Outputs
    wire [7:0] show_hour;
    wire cin_hour;

    counter_hour counter_hour_s (
        .cin_min(cin_min),
        .PE(PE),
        ._CR(_CR),
        .pre_hour(pre_hour),
        .show_hour(show_hour),
        .cin_hour(cin_hour)
    );
        always #5 cin_min = ~cin_min;
    
    initial begin
        // tset reset
        _CR = 0;
        cin_min = 0;
        #10;
        
        //test set
        _CR = 1;
        PE = 1;
        pre_hour = 8'd55;
        #5;
        
        //start work
        PE = 0;
        #105;
        $stop;
    end
    
endmodule
