`timescale 1ns / 1ps

module clock_sim(

    );
reg CP, _CR, mode, adjust, time_mode, active_alarm, left, right, up, down, apply;
wire [15:0] start_light;
wire [7:0] select_light, display_char;
wire [7:0] pre_sec;
wire [7:0] pre_min;
wire [7:0] pre_hour;

clock uut(
    .CP(CP),
    ._CR(_CR),
    .mode(mode),
    .adjust(adjust),
    .time_mode(time_mode),
    .active_alarm(active_alarm),
    .left(left),
    .right(right),
    .up(up),
    .down(down),
    .apply(apply),
    .start_light(start_light),
    .select_light(select_light),
    .display_char(display_char),
    .pre_sec(presec),
    .pre_min(pre_min),
    .pre_hour(pre_hour)
);
always #5 CP = ~CP;
initial begin
    CP = 1'b0;
    _CR = 1'b0;
    mode = 1'b0;
    adjust = 1'b0;
    time_mode = 1'b0;
    active_alarm = 1'b0;
    left = 1'b0;
    right = 1'b0;
    up = 1'b0;
    down = 1'b0;
    apply = 1'b0;
   #10;
   _CR = 1;
   #200;
   $stop;
end
endmodule
