module alarm(
    input _CR,
    input PE,
    input [7:0] pre_min,
    input [7:0] pre_hour,
    input active_alarm,
    input [7:0] show_hour,
    input [7:0] show_min,
    output [15:0] start_light,
    output [31:0] alarm_time
    );
endmodule
