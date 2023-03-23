module alarm(
    input _CR,
    input PE,
    input [7:0] pre_min,
    input [7:0] pre_hour,
    input active_alarm,
    input [7:0] show_hour,
    input [7:0] show_min,
    input [7:0] show_sec,
    output reg start_light_alarm,
    output reg [31:0] alarm_time
    );

    always@(*)begin
        if(~_CR) begin
            alarm_time = 0;
            start_light_alarm = 0;
        end
        else if(PE)begin
            // set alarm time
            start_light_alarm = 0;
            alarm_time = {pre_hour,pre_min,16'b0};
        end
        else if(active_alarm)begin
            //Arrive at the scheduled time of the alarm clock and start to light up
            if(alarm_time == {show_hour,show_min,show_sec,8'b0}) start_light_alarm = 1;
            else start_light_alarm = 0;
        end
        else start_light_alarm = 0;
    end

endmodule
