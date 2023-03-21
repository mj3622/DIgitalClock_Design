module clock(
    input CP,                   // 100MHz
    input _CR,                  // reset
    input mode,                 // switch between alarm and clock
    input adjust,               // begin adjust displayed digital
    input time_mode,            // switch between 12-hour and 24-hour format
    input active_alarm,         // make the alarm clock module work
    input left,                 // cursor move left 
    input right,                // cursor move right
    input up,                   // add 
    input down,                 // reduce
    input apply,                // make sure the change
    output [15:0] start_light,  // alarm work signals
    output [7:0] select_light,  // select one tube work 
    output [7:0] display_char   // the char displayed
    );

    wire CP_1Hz, CP_1KHz;               // 1Hz & 1KHz signals
    wire PE;                            // apply the changes to splitter
    wire cin_sec, cin_min, cin_hour;    // Carry signals
    wire PE_alarm, PE_counter;            // determine apply to whitch
    wire [7:0] index;                   // the index selected

    wire [7:0] pre_sec;
    wire [7:0] pre_min;
    wire [7:0] pre_hour;    // the prepared time
    
    wire [7:0] show_sec;
    wire [7:0] show_min;
    wire [7:0] show_hour;   // the counter time

    wire[31:0] alarm_time;  // the alarm time  
    wire[31:0] display_time;// the final code char 

    wire start_light_alarm, start_light_hour;   //provide info  

    divider divider_u0(         
        ._CR(_CR),
        .CP(CP),
        .CP_1Hz(CP_1KHz),
        .CP_1KHz(CP_1KHz)
    );

    counter_sec counter_sec_u0(
        .CP_1Hz(CP_1Hz),
        .adjust(adjust),
        ._CR(_CR),
        .mode(mode),
        .PE(PE_counter),
        .pre_sec(pre_sec),
        .show_sec(show_sec),
        .cin_sec(cin_sec)
    );

    counter_min counter_min_u0(
        .cin_sec(cin_sec),
        .pre_min(pre_min),
        ._CR(_CR),
        .PE(PE_counter),
        .cin_min(cin_min),
        .show_min(show_min)
    );

    counter_hour counter_hour_u0(
        .cin_min(cin_min),
        .pre_hour(pre_hour),
        .PE(PE_counter),
        ._CR(_CR),
        .show_hour(show_hour),
        .cin_hour(cin_hour)
    );

    alarm alarm_u0(
        ._CR(_CR),
        .PE(PE_alarm),
        .pre_min(pre_min),
        .pre_hour(pre_hour),
        .active_alarm(active_alarm),
        .show_hour(show_hour),
        .show_min(show_min),
        .show_sec(show_sec),
        .start_light_alarm(start_light_alarm),
        .alarm_time(alarm_time)
    );

    select_control select_control_u0(
        ._CR(_CR),
        .mode(mode),
        .CP_1KHz(CP_1Hz),
        .adjust(adjust),
        .show_time({show_hour,show_min,show_sec}),
        .alarm_time(alarm_time),
        .left(left),
        .right(right),
        .up(up),
        .down(down),
        .apply(apply),
        .time_mode(time_mode),
        .display_time(display_time),
        .index(index),
        .PE(PE)
    );

    splitter splitter_u0(
        ._CR(_CR),
        .display_time(display_char),
        .time_mode(time_mode),
        .mode(mode),
        .PE(PE),
        .pre_sec(pre_sec),
        .pre_min(pre_min),
        .pre_sec(pre_sec),
        .PE_alarm(PE_alarm),
        .PE_counter(PE_counter)
    );

    decoder decoder_u0(
        ._CR(_CR),
        .display_time(display_time),
        .index(index),
        .adjust(adjust),
        .CP_1KHz(CP_1KHz),
        .select_light(select_light),
        .display_char(display_char)
    );

    reminder reminder_u0(
        ._CR(_CR),
        .CP_1Hz(CP_1Hz),
        .start_light_hour(cin_hour),
        .start_light_alarm(start_light_alarm),
        .show_hour(show_hour),
        .start_light(start_light)
    );
    
endmodule
