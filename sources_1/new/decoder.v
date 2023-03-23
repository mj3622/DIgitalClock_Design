module decoder(
    input _CR,
    input [63:0] display_time,
    input [3:0]index,    // the li
    input adjust,
    input CP_1KHz,
    output reg [7:0] select_light,
    output reg [7:0] display_char
    );

    reg [31:0] cnt_normal;
    reg [31:0] cnt_adjust;
    reg twinkle;

    always@(posedge CP_1KHz, negedge _CR)begin
        if(~_CR) begin
            select_light = 0;
            display_char = 8'hff;
            cnt_normal = 0;
            cnt_adjust = 0;
            twinkle = 0;
        end
        else begin
            if(adjust) begin    
                cnt_adjust = cnt_adjust + 1;
                if(cnt_adjust >= 9'd500) begin
                    cnt_adjust = 0;
                    twinkle = ~twinkle;
                end 
            end
            else twinkle = 0;
         
            cnt_normal = cnt_normal + 1;
            if(cnt_normal == index && twinkle) cnt_normal = cnt_normal + 1;
            if(cnt_normal >= 4'd8) cnt_normal = 0; 
            case(cnt_normal)
                4'd0:begin select_light = 8'b10000000; display_char = display_time[63:56]; end
                4'd1:begin select_light = 8'b01000000; display_char = display_time[55:48]; end
                4'd2:begin select_light = 8'b00100000; display_char = display_time[47:40]; end
                4'd3:begin select_light = 8'b00010000; display_char = display_time[39:32]; end
                4'd4:begin select_light = 8'b00001000; display_char = display_time[31:24]; end
                4'd5:begin select_light = 8'b00000100; display_char = display_time[23:16]; end
                4'd6:begin select_light = 8'b00000010; display_char = display_time[15:8]; end
                4'd7:begin select_light = 8'b00000001; display_char = display_time[7:0]; end
                default:begin select_light = 8'b00000000; display_char = 8'b11111111; end
            endcase
        end
   end

endmodule
