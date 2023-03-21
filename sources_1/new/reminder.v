module reminder(
    input _CR,
    input CP_1Hz,
    input start_light_hour,
    input start_light_alarm,
    input show_hour,
    input active_alarm,
    output reg [15:0] start_light   //[15:2] alarm [1:0] clock
);
    reg[7:0] clock_cnt;
    reg[4:0] alarm_cnt;
    always @(posedge CP_1Hz, negedge _CR) begin
        if(~_CR) begin
            start_light = 0;    
            clock_cnt = 0;
            alarm_cnt = 0;
        end
        else begin
            if(start_light_hour | clock_cnt)begin
                if(clock_cnt == show_hour) clock_cnt = 0;
                else if(clock_cnt % 2 == 0) start_light[1:0] = 2'b01;
                else if(clock_cnt % 2 == 1) start_light[1:0] = 2'b10;

                clock_cnt = clock_cnt + 1;
            end
            else begin clock_cnt = 0; start_light[1:0] = 0; end

            if(active_alarm & (start_light_alarm | alarm_cnt)) begin
                case (alarm_cnt)
                    5'd0: start_light = 16'b1000000000000100;
                    5'd1: start_light = 16'b1100000000001100;
                    5'd2: start_light = 16'b1110000000011100;
                    5'd3: start_light = 16'b1111000000111100;
                    5'd4: start_light = 16'b1111100001111100;
                    5'd5: start_light = 16'b1111110011111100;
                    5'd6: start_light = 16'b1111111111111100;
                    5'd7: start_light = 16'b1011111111110100;
                    5'd8: start_light = 16'b1001111111100100;
                    5'd9: start_light = 16'b1000111111000100;
                    5'd10: start_light = 16'b1000111100000100;
                    5'd11: start_light = 16'b1000011000000100;
                    5'd12: start_light = 16'b1100110011001100;
                    5'd13: start_light = 16'b0011001100110000;
                    5'd14: start_light = 16'b0101010101010100;
                    5'd15: start_light = 16'b1010101010101000;
                    5'd16: start_light = 16'b0000001111110000;
                    5'd17: start_light = 16'b1111110000001100;
                    5'd18: start_light = 16'b1010100111110100;
                    5'd19: start_light = 16'b0101011000001000;
                    5'd20: start_light = 16'b0000111111000000;
                    5'd21: start_light = 16'b1111000000111100;
                    5'd22: start_light = 16'b1100001110000100;
                    5'd23: start_light = 16'b0110011001100000;
                    5'd24: start_light = 16'b1001100110011100;
                    5'd25: start_light = 16'b0001111000001100;
                    5'd26: start_light = 16'b1110000111110000;
                    5'd27: start_light = 16'b0101011110101000;
                    5'd28: start_light = 16'b1010100001010100;
                    5'd29: start_light = 16'b0111110000011100;
                    5'd30: start_light = 16'b1111111111111100;
                    default: begin start_light[15:2] = 0; alarm_cnt = 0; end
                endcase
                alarm_cnt = alarm_cnt + 1;
            end
            else begin
                alarm_cnt = 0;
                start_light[15:2] = 0;
            end 

        end

    end
endmodule