module select_control(
    input _CR,
    input mode,
    input CP_1KHz,
    input adjust,
    input [31:0] show_time,
    input [31:0] alarm_time,
    input left,
    input right,
    input up,
    input down,
    input apply,
    input time_mode,
    output [31:0] display_time,
    output [7:0] index,
    output PE
    );
endmodule
