module clock(
    input CP,
    input _CR,
    input mode,
    input adjust,
    input time_mode,
    input active_alarm,
    input left,
    input right,
    input up,
    input down,
    output [15:0] start_light,
    output [7:0] select_light,
    output [7:0] display_char
    );

    wire CP_1Hz, CP_1KHz;

    divider divider_u0(
        ._CR(_CR),
        .CP(CP),
        .CP_1Hz(CP_1KHz),
        .CP_1KHz(CP_1KHz)
    );

    
endmodule
