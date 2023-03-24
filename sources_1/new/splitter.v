module splitter(
    input _CR,
    input [31:0] display_time,
    input time_mode,
    input mode,
    input PE,
    output reg [7:0] pre_sec,
    output reg [7:0] pre_min,
    output reg [7:0] pre_hour,
    output reg PE_alarm,
    output reg PE_counter
    );

    parameter s0 = 4'b0000,
              s1 = 4'b0001,
              s2 = 4'b0010,
              s3 = 4'b0011,
              s4 = 4'b0100,
              s5 = 4'b0101,
              s6 = 4'b0110,
              s7 = 4'b0111,
              s8 = 4'b1000,
              s9 = 4'b1001,
              sA = 4'b1010,
              sP = 4'b1011,
              sB = 4'b1100,
              sE = 4'b1101,
              sL = 4'b1110,
              sExcept = 4'b1111;

    always @(*) begin
        if(~_CR) begin
            pre_sec <= 0;
            pre_min <= 0;
            pre_hour <= 0;
            PE_alarm <= 0;
            PE_counter <= 0;
        end
        else if(PE) begin
            if(mode) begin  //alarm mode
                pre_hour <= display_time[31:28]*10 + display_time[27:24];
                pre_min <= display_time[23:20]*10 + display_time[19:16];
                PE_counter <= 0;
                PE_alarm <= 1;
            end
            else begin      //clock mode
                if(time_mode) begin     //24 hour
                    pre_hour <= display_time[31:28]*10 + display_time[27:24];
                end
                else begin              //12 hour
                    if(display_time[31:24] == {s1,s2}) begin
                        pre_hour <= display_time[3:0] == sP ? 4'd12 : 4'd0;
                    end
                    else begin
                        pre_hour <= display_time[31:28]*10 + display_time[27:24] + (display_time[3:0] == sP ? 4'd12 : 4'd0);
                    end
                end
                // set min and sec
                pre_min <= display_time[23:20]*10 + display_time[19:16];
                pre_sec <= display_time[15:12]*10 + display_time[11:8];
                PE_alarm <= 0;
                PE_counter <= 1;
            end
        end
        else begin
            PE_alarm <= 0;
            PE_counter <= 0;
        end
    end

endmodule
