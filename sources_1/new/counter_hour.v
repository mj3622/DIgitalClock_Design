module counter_hour(
    input cin_min,
    input PE,
    input _CR,
    input [7:0] pre_hour,
    output reg [7:0] show_hour,
    output reg cin_hour
    );

    always@(posedge cin_min, negedge _CR, posedge PE)begin
        if(~_CR) begin  // reset
            show_hour = 0;
            cin_hour = 0;
        end 
        else if(PE) begin   // set hour we want
            show_hour = pre_hour;
            cin_hour = 0;
        end
        else begin          //start work
            begin   
            show_hour = show_hour + 1;
            cin_hour = 0;
            if(show_hour == 8'd24) begin
                show_hour = 0;
                cin_hour = 1;
            end
            end
        end
    end

endmodule
