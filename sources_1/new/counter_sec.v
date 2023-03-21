module counter_sec(
    input CP_1Hz,
    input adjust,
    input _CR,
    input mode,
    input PE,
    input [7:0] pre_sec,
    output reg [7:0] show_sec,
    output reg cin_sec
    );

    always @(posedge CP_1Hz, negedge _CR, posedge PE) begin
        if(~_CR) begin  // reset
            show_sec = 0;
            cin_sec = 0;
        end 
        else if(PE) begin   // set sec we want
            show_sec = pre_sec;
            cin_sec = 0;
        end
        else if(~adjust || mode)begin   //stuo increase
            show_sec = show_sec + 1;
            cin_sec = 0;
            if(show_sec == 8'd60) begin
                show_sec = 0;
                cin_sec = 1;
            end
        end
    end
endmodule
