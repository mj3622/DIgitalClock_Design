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
    output reg [63:0] display_time,
    output reg [31:0] set_time,
    output reg [3:0]index,
    output reg PE
    );

    // in
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
    // out
    parameter L0 = 8'b11000000,
              L1 = 8'b11111001,
              L2 = 8'b10100100,
              L3 = 8'b10110000,
              L4 = 8'b10011001,
              L5 = 8'b10010010,
              L6 = 8'b10000010,
              L7 = 8'b11111000,
              L8 = 8'b10000000,
              L9 = 8'b10010000,
              LA = 8'b10001000,
              LP = 8'b10001100,
              LB = 8'b10000011,
              LE = 8'b10000110,
              LL = 8'b11000111,
              LExcept = 8'b11111111;
     
    reg[31:0] temp_time;

    always@(posedge CP_1KHz, negedge _CR) begin
        if(~_CR) begin
            PE = 0;
            display_time = 64'hffffffff;
            set_time = 0;
            index = 0;
            temp_time = 0;
        end
        else begin
            if(adjust) begin    // adjust mode
                

                // outer control
                if(left) begin
                    case(index)
                        4'd0: begin if(mode) index = 4'd4; else index = time_mode ? 4'd5 : 4'd7; end
                        4'd1: begin index = 4'd0; end
                        4'd2: begin index = 4'd1; end
                        4'd3: begin index = 4'd2;  end
                        4'd4: begin index = 4'd3;  end
                        4'd5: begin index = 4'd4;  end
                        4'd7: begin index = 4'd5;  end
                        default begin index = 0; end
                    endcase
                end
                else if(right) begin
                    case(index)
                        4'd0: begin index = 4'd1; end
                        4'd1: begin index = 4'd2; end
                        4'd2: begin index = 4'd3; end
                        4'd3: begin if(mode) index = 4'd0; else index = 4'd4;  end
                        4'd4: begin index = 4'd5;  end
                        4'd5: begin index = time_mode ? 4'd0 : 4'd7;  end
                        4'd7: begin index = 4'd0;  end
                        default begin index = 0; end
                    endcase
                end
                else if(up) begin
                    case(index)
                        4'd0:begin  if(mode || time_mode)begin
                                        if(temp_time[27:24] < 4) temp_time[31:28] = temp_time[31:28] == s2 ? s0 : temp_time[31:28] +1; 
                                        else temp_time[31:28] = temp_time[31:28] == s1 ? s0 : temp_time[31:28] +1; 
                                    end
                                    else begin
                                        if(temp_time[27:24] > 2) temp_time[31:28] = 0;
                                        else temp_time[31:28] = temp_time[31:28] == s1 ? s0 : s1; 
                                    end 
                            end
                        4'd1:begin 
                            if(mode || time_mode) begin
                                if(temp_time[31:28] == 4'd2)begin temp_time[27:24] = temp_time[27:24] == s3 ? s0 : temp_time[27:24] + 4'd1;end 
                                else temp_time[27:24] = temp_time[27:24] == s9 ? s0 : temp_time[27:24] +4'd1;
                            end
                            else begin
                                if(temp_time[31:28] == 4'd1)begin 
                                    temp_time[27:24] = temp_time[27:24] == s2 ? s0 : temp_time[27:24] + 1;
                                end 
                                else temp_time[27:24] = temp_time[27:24] == s9 ? s0 : temp_time[27:24] +1;
                            end
                            end
                        4'd2:begin temp_time[23:20] = temp_time[23:20] == s5 ? s0 : temp_time[23:20] +1;end 
                        4'd3:begin temp_time[19:16] = temp_time[19:16] == s9 ? s0 : temp_time[19:16] +1;end
                        4'd4:if(~mode)begin temp_time[15:12] = temp_time[15:12] == s5 ? s0 : temp_time[15:12] +1;end
                        4'd5:if(~mode)begin temp_time[11:8]  = temp_time[11:8]  == s9 ? s0 : temp_time[11:8]  +1;end
                        4'd7:begin temp_time[3:0] = temp_time[3:0] == sA ? sP : sA;end
                        default: ;
                    endcase
                end
                else if(down) begin
                    case(index)
                        4'd0:begin  if(mode || time_mode)begin
                                        if(temp_time[27:24] < 4) temp_time[31:28] = temp_time[31:28] == s0 ? s2 : temp_time[31:28] - 1; 
                                        else temp_time[31:28] = temp_time[31:28] == s0 ? s1 : temp_time[31:28] - 1; 
                                    end
                                    else begin
                                        if(temp_time[27:24] > 2) temp_time[31:28] = 0;
                                        else temp_time[31:28] = temp_time[31:28] == s1 ? s0 : s1; 
                                    end 
                            end
                        4'd1:begin 
                            if(mode || time_mode) begin
                                if(temp_time[31:28] == 4'd2)begin temp_time[27:24] = temp_time[27:24] == s0 ? s3 : temp_time[27:24] - 4'd1;end 
                                else temp_time[27:24] = temp_time[27:24] == s0 ? s9 : temp_time[27:24] - 4'd1;
                            end
                            else begin
                                if(temp_time[31:28] == 4'd1)begin 
                                    temp_time[27:24] = temp_time[27:24] == s0 ? s2 : temp_time[27:24] - 1;
                                end 
                                else temp_time[27:24] = temp_time[27:24] == s0 ? s9 : temp_time[27:24] - 1;
                            end
                            end
                        4'd2:begin temp_time[23:20] = temp_time[23:20] == s0 ? s5 : temp_time[23:20] -1;end 
                        4'd3:begin temp_time[19:16] = temp_time[19:16] == s0 ? s9 : temp_time[19:16] -1;end
                        4'd4:if(~mode)begin temp_time[15:12] = temp_time[15:12] == s0 ? s5 : temp_time[15:12] -1;end
                        4'd5:if(~mode)begin temp_time[11:8]  = temp_time[11:8]  == s0 ? s9 : temp_time[11:8]  -1;end
                        4'd7:begin temp_time[3:0] = temp_time[3:0] == sA ? sP : sA;end
                        default: ;
                    endcase
                end

            if(mode) begin  // alarm mode
                    // set higher hour
                    case(temp_time[31:28]) 
                        s0:begin set_time[31:28] = s0; display_time[63:56] = L0; end
                        s1:begin set_time[31:28] = s1; display_time[63:56] = L1; end
                        s2:begin set_time[31:28] = s2; display_time[63:56] = L2; end
                        default:begin set_time[31:28] = s0; display_time[63:56] = L0; end
                    endcase
                    
                    // set lower hour
                    case(temp_time[27:24]) 
                        s0:begin set_time[27:24] = s0; display_time[55:48] = L0; end
                        s1:begin set_time[27:24] = s1; display_time[55:48] = L1; end
                        s2:begin set_time[27:24] = s2; display_time[55:48] = L2; end
                        s3:begin set_time[27:24] = s3; display_time[55:48] = L3; end
                        s4:begin set_time[27:24] = s4; display_time[55:48] = L4; end
                        s5:begin set_time[27:24] = s5; display_time[55:48] = L5; end
                        s6:begin set_time[27:24] = s6; display_time[55:48] = L6; end
                        s7:begin set_time[27:24] = s7; display_time[55:48] = L7; end
                        s8:begin set_time[27:24] = s8; display_time[55:48] = L8; end
                        s9:begin set_time[27:24] = s9; display_time[55:48] = L9; end
                        default:begin set_time[27:24] = s0; display_time[55:48] = L0; end
                    endcase

                    // set higher minute
                    case(temp_time[23:20]) 
                        s0:begin set_time[23:20] = s0; display_time[47:40] = L0; end
                        s1:begin set_time[23:20] = s1; display_time[47:40] = L1; end
                        s2:begin set_time[23:20] = s2; display_time[47:40] = L2; end
                        s3:begin set_time[23:20] = s3; display_time[47:40] = L3; end
                        s4:begin set_time[23:20] = s4; display_time[47:40] = L4; end
                        s5:begin set_time[23:20] = s5; display_time[47:40] = L5; end
                        default:begin set_time[23:20] = s0; display_time[47:40] = L0; end
                    endcase

                    // set lower minute
                    case(temp_time[19:16]) 
                        s0:begin set_time[19:16] = s0; display_time[39:32] = L0; end
                        s1:begin set_time[19:16] = s1; display_time[39:32] = L1; end
                        s2:begin set_time[19:16] = s2; display_time[39:32] = L2; end
                        s3:begin set_time[19:16] = s3; display_time[39:32] = L3; end
                        s4:begin set_time[19:16] = s4; display_time[39:32] = L4; end
                        s5:begin set_time[19:16] = s5; display_time[39:32] = L5; end
                        s6:begin set_time[19:16] = s6; display_time[39:32] = L6; end
                        s7:begin set_time[19:16] = s7; display_time[39:32] = L7; end
                        s8:begin set_time[19:16] = s8; display_time[39:32] = L8; end
                        s9:begin set_time[19:16] = s9; display_time[39:32] = L9; end
                        default:begin set_time[19:16] = s0; display_time[39:32] = L0; end
                    endcase

                    // set left part
                    set_time[15:0] = {sB,sE,sL,sL};
                    display_time[31:0] = {LB,LE,LL,LL};
            end
            else begin      // clock mode
                    if(time_mode) display_time[15:0] = {LExcept,LExcept};
                    else  begin
                        set_time[7:0] = temp_time[7:0];
                        display_time[16:0] = {LExcept,temp_time[3:0] == sA ? LA : LP};
                    end

                    // set higher hour
                    case(temp_time[31:28]) 
                        s0:begin set_time[31:28] = s0; display_time[63:56] = L0; end
                        s1:begin set_time[31:28] = s1; display_time[63:56] = L1; end
                        s2:begin set_time[31:28] = s2; display_time[63:56] = L2; end
                        default:begin set_time[31:28] = s0; display_time[63:56] = L0; end
                    endcase
                    
                    // set lower hour
                    case(temp_time[27:24]) 
                        s0:begin set_time[27:24] = s0; display_time[55:48] = L0; end
                        s1:begin set_time[27:24] = s1; display_time[55:48] = L1; end
                        s2:begin set_time[27:24] = s2; display_time[55:48] = L2; end
                        s3:begin set_time[27:24] = s3; display_time[55:48] = L3; end
                        s4:begin set_time[27:24] = s4; display_time[55:48] = L4; end
                        s5:begin set_time[27:24] = s5; display_time[55:48] = L5; end
                        s6:begin set_time[27:24] = s6; display_time[55:48] = L6; end
                        s7:begin set_time[27:24] = s7; display_time[55:48] = L7; end
                        s8:begin set_time[27:24] = s8; display_time[55:48] = L8; end
                        s9:begin set_time[27:24] = s9; display_time[55:48] = L9; end
                        default:begin set_time[27:24] = s0; display_time[55:48] = L0; end
                    endcase

                    // set higher minute
                    case(temp_time[23:20]) 
                        s0:begin set_time[23:20] = s0; display_time[47:40] = L0; end
                        s1:begin set_time[23:20] = s1; display_time[47:40] = L1; end
                        s2:begin set_time[23:20] = s2; display_time[47:40] = L2; end
                        s3:begin set_time[23:20] = s3; display_time[47:40] = L3; end
                        s4:begin set_time[23:20] = s4; display_time[47:40] = L4; end
                        s5:begin set_time[23:20] = s5; display_time[47:40] = L5; end
                        default:begin set_time[23:20] = s0; display_time[47:40] = L0; end
                    endcase

                    // set lower minute
                    case(temp_time[19:16]) 
                        s0:begin set_time[19:16] = s0; display_time[39:32] = L0; end
                        s1:begin set_time[19:16] = s1; display_time[39:32] = L1; end
                        s2:begin set_time[19:16] = s2; display_time[39:32] = L2; end
                        s3:begin set_time[19:16] = s3; display_time[39:32] = L3; end
                        s4:begin set_time[19:16] = s4; display_time[39:32] = L4; end
                        s5:begin set_time[19:16] = s5; display_time[39:32] = L5; end
                        s6:begin set_time[19:16] = s6; display_time[39:32] = L6; end
                        s7:begin set_time[19:16] = s7; display_time[39:32] = L7; end
                        s8:begin set_time[19:16] = s8; display_time[39:32] = L8; end
                        s9:begin set_time[19:16] = s9; display_time[39:32] = L9; end
                        default:begin set_time[19:16] = s0; display_time[39:32] = L0; end
                    endcase

                    // set higher second
                    case(temp_time[15:12]) 
                        s0:begin set_time[15:12] = s0; display_time[31:24] = L0; end
                        s1:begin set_time[15:12] = s1; display_time[31:24] = L1; end
                        s2:begin set_time[15:12] = s2; display_time[31:24] = L2; end
                        s3:begin set_time[15:12] = s3; display_time[31:24] = L3; end
                        s4:begin set_time[15:12] = s4; display_time[31:24] = L4; end
                        s5:begin set_time[15:12] = s5; display_time[31:24] = L5; end
                        default:begin set_time[15:12] = s0; display_time[31:24] = L0; end
                    endcase

                    // set lower second
                    case(temp_time[11:8]) 
                        s0:begin set_time[11:8] = s0; display_time[23:16] = L0; end
                        s1:begin set_time[11:8] = s1; display_time[23:16] = L1; end
                        s2:begin set_time[11:8] = s2; display_time[23:16] = L2; end
                        s3:begin set_time[11:8] = s3; display_time[23:16] = L3; end
                        s4:begin set_time[11:8] = s4; display_time[23:16] = L4; end
                        s5:begin set_time[11:8] = s5; display_time[23:16] = L5; end
                        s6:begin set_time[11:8] = s6; display_time[23:16] = L6; end
                        s7:begin set_time[11:8] = s7; display_time[23:16] = L7; end
                        s8:begin set_time[11:8] = s8; display_time[23:16] = L8; end
                        s9:begin set_time[11:8] = s9; display_time[23:16] = L9; end
                        default:begin set_time[11:8] = s0; display_time[23:16] = L0; end
                    endcase
                end    

            end

            // don't in adjust mode
            else begin
                index = 0;          
                if(mode) begin  // alarm mode
                    temp_time = set_time;
                    // set higher hour
                    case(alarm_time[31:24] / 10) 
                        s0:begin set_time[31:28] = s0; display_time[63:56] = L0; end
                        s1:begin set_time[31:28] = s1; display_time[63:56] = L1; end
                        s2:begin set_time[31:28] = s2; display_time[63:56] = L2; end
                        default:begin set_time[31:28] = s0; display_time[63:56] = L0; end
                    endcase
                    
                    // set lower hour
                    case(alarm_time[31:24] % 10) 
                        s0:begin set_time[27:24] = s0; display_time[55:48] = L0; end
                        s1:begin set_time[27:24] = s1; display_time[55:48] = L1; end
                        s2:begin set_time[27:24] = s2; display_time[55:48] = L2; end
                        s3:begin set_time[27:24] = s3; display_time[55:48] = L3; end
                        s4:begin set_time[27:24] = s4; display_time[55:48] = L4; end
                        s5:begin set_time[27:24] = s5; display_time[55:48] = L5; end
                        s6:begin set_time[27:24] = s6; display_time[55:48] = L6; end
                        s7:begin set_time[27:24] = s7; display_time[55:48] = L7; end
                        s8:begin set_time[27:24] = s8; display_time[55:48] = L8; end
                        s9:begin set_time[27:24] = s9; display_time[55:48] = L9; end
                        default:begin set_time[27:24] = s0; display_time[55:48] = L0; end
                    endcase

                    // set higher minute
                    case(alarm_time[23:16] / 10) 
                        s0:begin set_time[23:20] = s0; display_time[47:40] = L0; end
                        s1:begin set_time[23:20] = s1; display_time[47:40] = L1; end
                        s2:begin set_time[23:20] = s2; display_time[47:40] = L2; end
                        s3:begin set_time[23:20] = s3; display_time[47:40] = L3; end
                        s4:begin set_time[23:20] = s4; display_time[47:40] = L4; end
                        s5:begin set_time[23:20] = s5; display_time[47:40] = L5; end
                        default:begin set_time[23:20] = s0; display_time[47:40] = L0; end
                    endcase

                    // set lower minute
                    case(alarm_time[23:16] % 10) 
                        s0:begin set_time[19:16] = s0; display_time[39:32] = L0; end
                        s1:begin set_time[19:16] = s1; display_time[39:32] = L1; end
                        s2:begin set_time[19:16] = s2; display_time[39:32] = L2; end
                        s3:begin set_time[19:16] = s3; display_time[39:32] = L3; end
                        s4:begin set_time[19:16] = s4; display_time[39:32] = L4; end
                        s5:begin set_time[19:16] = s5; display_time[39:32] = L5; end
                        s6:begin set_time[19:16] = s6; display_time[39:32] = L6; end
                        s7:begin set_time[19:16] = s7; display_time[39:32] = L7; end
                        s8:begin set_time[19:16] = s8; display_time[39:32] = L8; end
                        s9:begin set_time[19:16] = s9; display_time[39:32] = L9; end
                        default:begin set_time[19:16] = s0; display_time[39:32] = L0; end
                    endcase

                    // set left part
                    set_time[15:0] = {sB,sE,sL,sL};
                    display_time[31:0] = {LB,LE,LL,LL};
                end
                else begin      // clock mode
                    if(time_mode) begin
                        // set higher hour
                        display_time[15:0] = {LExcept,LExcept};
                        set_time[7:0] = 0;
                        case(show_time[31:24] / 10) 
                            s0:begin set_time[31:28] = s0; display_time[63:56] = L0; end
                            s1:begin set_time[31:28] = s1; display_time[63:56] = L1; end
                            s2:begin set_time[31:28] = s2; display_time[63:56] = L2; end
                            default:begin set_time[31:28] = s0; display_time[63:56] = L0; end
                        endcase
                        
                        // set lower hour
                        case(show_time[31:24] % 10) 
                            s0:begin set_time[27:24] = s0; display_time[55:48] = L0; end
                            s1:begin set_time[27:24] = s1; display_time[55:48] = L1; end
                            s2:begin set_time[27:24] = s2; display_time[55:48] = L2; end
                            s3:begin set_time[27:24] = s3; display_time[55:48] = L3; end
                            s4:begin set_time[27:24] = s4; display_time[55:48] = L4; end
                            s5:begin set_time[27:24] = s5; display_time[55:48] = L5; end
                            s6:begin set_time[27:24] = s6; display_time[55:48] = L6; end
                            s7:begin set_time[27:24] = s7; display_time[55:48] = L7; end
                            s8:begin set_time[27:24] = s8; display_time[55:48] = L8; end
                            s9:begin set_time[27:24] = s9; display_time[55:48] = L9; end
                            default:begin set_time[27:24] = s0; display_time[55:48] = L0; end
                        endcase
                    end
                    else begin
                        if(show_time[31:24] == 8'd12) begin set_time[31:24] = {s1,s2}; display_time[63:48] = {L1,L2}; display_time[7:0] = LP; set_time[7:0] = {s0,sP}; end
                        else if(show_time[31:24] == 8'd0) begin set_time[31:24] = {s1,s2}; display_time[63:48] = {L1,L2}; display_time[7:0] = LA; set_time[7:0] = {s0,sA};end
                        else begin
                            display_time[7:0] = show_time[31:24] > 8'd12 ? LP : LA;
                            set_time[7:0] = {s0,show_time[31:24] > 8'd12 ? sP : sA};
                        // set higher hour
                        case((show_time[31:24] % 12) / 10) 
                            s0:begin set_time[31:28] = s0; display_time[63:56] = L0; end
                            s1:begin set_time[31:28] = s1; display_time[63:56] = L1; end
                            default:begin set_time[31:28] = s0; display_time[63:56] = L0; end
                        endcase
                        
                        // set lower hour
                        case((show_time[31:24] % 12) % 10) 
                            s0:begin set_time[27:24] = s0; display_time[55:48] = L0; end
                            s1:begin set_time[27:24] = s1; display_time[55:48] = L1; end
                            s2:begin set_time[27:24] = s2; display_time[55:48] = L2; end
                            s3:begin set_time[27:24] = s3; display_time[55:48] = L3; end
                            s4:begin set_time[27:24] = s4; display_time[55:48] = L4; end
                            s5:begin set_time[27:24] = s5; display_time[55:48] = L5; end
                            s6:begin set_time[27:24] = s6; display_time[55:48] = L6; end
                            s7:begin set_time[27:24] = s7; display_time[55:48] = L7; end
                            s8:begin set_time[27:24] = s8; display_time[55:48] = L8; end
                            s9:begin set_time[27:24] = s9; display_time[55:48] = L9; end
                            default:begin set_time[27:24] = s0; display_time[55:48] = L0; end
                        endcase
                        end
                    end

                    // set higher minute
                    case(show_time[23:16] / 10) 
                        s0:begin set_time[23:20] = s0; display_time[47:40] = L0; end
                        s1:begin set_time[23:20] = s1; display_time[47:40] = L1; end
                        s2:begin set_time[23:20] = s2; display_time[47:40] = L2; end
                        s3:begin set_time[23:20] = s3; display_time[47:40] = L3; end
                        s4:begin set_time[23:20] = s4; display_time[47:40] = L4; end
                        s5:begin set_time[23:20] = s5; display_time[47:40] = L5; end
                        default:begin set_time[23:20] = s0; display_time[47:40] = L0; end
                    endcase

                    // set lower minute
                    case(show_time[23:16] % 10) 
                        s0:begin set_time[19:16] = s0; display_time[39:32] = L0; end
                        s1:begin set_time[19:16] = s1; display_time[39:32] = L1; end
                        s2:begin set_time[19:16] = s2; display_time[39:32] = L2; end
                        s3:begin set_time[19:16] = s3; display_time[39:32] = L3; end
                        s4:begin set_time[19:16] = s4; display_time[39:32] = L4; end
                        s5:begin set_time[19:16] = s5; display_time[39:32] = L5; end
                        s6:begin set_time[19:16] = s6; display_time[39:32] = L6; end
                        s7:begin set_time[19:16] = s7; display_time[39:32] = L7; end
                        s8:begin set_time[19:16] = s8; display_time[39:32] = L8; end
                        s9:begin set_time[19:16] = s9; display_time[39:32] = L9; end
                        default:begin set_time[19:16] = s0; display_time[39:32] = L0; end
                    endcase

                    // set higher second
                    case(show_time[15:8] / 10) 
                        s0:begin set_time[15:12] = s0; display_time[31:24] = L0; end
                        s1:begin set_time[15:12] = s1; display_time[31:24] = L1; end
                        s2:begin set_time[15:12] = s2; display_time[31:24] = L2; end
                        s3:begin set_time[15:12] = s3; display_time[31:24] = L3; end
                        s4:begin set_time[15:12] = s4; display_time[31:24] = L4; end
                        s5:begin set_time[15:12] = s5; display_time[31:24] = L5; end
                        default:begin set_time[15:12] = s0; display_time[31:24] = L0; end
                    endcase

                    // set lower second
                    case(show_time[15:8] % 10) 
                        s0:begin set_time[11:8] = s0; display_time[23:16] = L0; end
                        s1:begin set_time[11:8] = s1; display_time[23:16] = L1; end
                        s2:begin set_time[11:8] = s2; display_time[23:16] = L2; end
                        s3:begin set_time[11:8] = s3; display_time[23:16] = L3; end
                        s4:begin set_time[11:8] = s4; display_time[23:16] = L4; end
                        s5:begin set_time[11:8] = s5; display_time[23:16] = L5; end
                        s6:begin set_time[11:8] = s6; display_time[23:16] = L6; end
                        s7:begin set_time[11:8] = s7; display_time[23:16] = L7; end
                        s8:begin set_time[11:8] = s8; display_time[23:16] = L8; end
                        s9:begin set_time[11:8] = s9; display_time[23:16] = L9; end
                        default:begin set_time[11:8] = s0; display_time[23:16] = L0; end
                    endcase
                    display_time[15:8] = LExcept;
                    temp_time = set_time;
                end
            end
            PE = adjust & apply;
        end
    end
endmodule
