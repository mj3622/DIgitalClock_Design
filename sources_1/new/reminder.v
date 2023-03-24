module reminder(
    input _CR,
    input CP_1Hz,
    input start_light_hour,
    input start_light_alarm,
    input [7:0] show_sec,
    input[7:0] show_hour,
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
            if(((start_light_hour && show_sec == 0) | clock_cnt) && (show_hour != 0))begin
                if(clock_cnt == show_hour) begin clock_cnt = 0; start_light[1:0] = 0; end
                else if(clock_cnt % 2 == 0)begin start_light[1:0] = 2'b01; clock_cnt = clock_cnt + 1; end
                else if(clock_cnt % 2 == 1)begin start_light[1:0] = 2'b10; clock_cnt = clock_cnt + 1; end
            end
            else begin clock_cnt = 0; start_light[1:0] = 0; end

            if(active_alarm & (start_light_alarm || (alarm_cnt != 0))) begin
                    alarm_cnt = alarm_cnt + 1;
                case (alarm_cnt)
                    5'd1: start_light[15:2] = 16'b10000000000001;
                    5'd2: start_light[15:2] = 16'b11000000000011;
                    5'd3: start_light[15:2] = 16'b11100000000111;
                    5'd4: start_light[15:2] = 16'b11110000001111;
                    5'd5: start_light[15:2] = 16'b11111000011111;
                    5'd6: start_light[15:2] = 16'b11111100111111;
                    5'd7: start_light[15:2] = 16'b11111111111111;
                    5'd8: start_light[15:2] = 16'b10111111111101;
                    5'd9: start_light[15:2] = 16'b10011111111001;
                    5'd10: start_light[15:2] =16'b10001111110001; 
                    5'd11: start_light[15:2] = 16'b10001111000001;
                    5'd12: start_light[15:2] = 16'b10000110000001;
                    5'd13: start_light[15:2] = 16'b11001100110011;
                    5'd14: start_light[15:2] = 16'b00110011001100;
                    5'd15: start_light[15:2] = 16'b01010101010101;
                    5'd16: start_light[15:2] = 16'b10101010101010;
                    5'd17: start_light[15:2] = 16'b00000011111100;
                    5'd18: start_light[15:2] = 16'b11111100000011;
                    5'd19: start_light[15:2] = 16'b10101001111101;
                    5'd20: start_light[15:2] = 16'b01010110000010;
                    5'd21: start_light[15:2] = 16'b00001111110000;
                    5'd22: start_light[15:2] = 16'b11110000001111;
                    5'd23: start_light[15:2] = 16'b11000011100001;
                    5'd24: start_light[15:2] = 16'b01100110011000;
                    5'd25: start_light[15:2] = 16'b10011001100111;
                    5'd26: start_light[15:2] = 16'b00011110000011;
                    5'd27: start_light[15:2] = 16'b11100001111100;
                    5'd28: start_light[15:2] = 16'b01010111101010;
                    5'd29: start_light[15:2] = 16'b10101000010101;
                    5'd30: start_light[15:2] = 16'b01111100000111;
                    5'd31: start_light[15:2] = 16'b11111111111111;
                    default: begin start_light[15:2] = 0; alarm_cnt = 0; end
                endcase
            end
            else begin
                alarm_cnt = 0;
                start_light[15:2] = 0;
            end 

        end

    end
endmodule