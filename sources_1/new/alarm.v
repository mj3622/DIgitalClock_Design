module alarm(
    input _CR,
    input PE,
    input [7:0] pre_min,
    input [7:0] pre_hour,
    input active_alarm,
    input [7:0] show_hour,
    input [7:0] show_min,
    input [7:0] show_sec,
    output start_light_alarm,
    output [31:0] alarm_time
    );
endmodule
