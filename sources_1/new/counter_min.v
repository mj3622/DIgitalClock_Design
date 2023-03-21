module counter_min(
    input cin_sec,
    input [7:0] pre_min,
    input _CR,
    input PE,
    output reg cin_min,
    output reg [7:0] show_min
    );

    always@(negedge _CR, posedge cin_sec, posedge PE) begin
        if(~_CR) begin  // reset
            show_min = 0;
            cin_min = 0;
        end 
        else if(PE) begin   // set min we want
            show_min = pre_min;
            cin_min = 0;
        end
        else begin          //start work
            begin
            show_min = show_min + 1;
            cin_min = 0;
            if(show_min == 8'd60) begin
                show_min = 0;
                cin_min = 1;
            end
            end
        end
    end

endmodule
