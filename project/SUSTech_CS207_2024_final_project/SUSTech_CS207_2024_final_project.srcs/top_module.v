module TopModule(
    input wire light_switch,     
    input wire menu_button,      
    input wire query_time,    
    input wire set_work_limit,   
    input wire set_gesture_time, 
    input wire set_current_time, 
    output reg standby_led,      
    output reg light,           
    
    output [7:0] sel_en,
    output [7:0] seg1,
    output [7:0] seg2,
    
    input wire clk,             
    input wire rst_n,            
    input wire left_or_clean_button,    
    input wire right_button,     
    
    input wire power_button_or_select_or_mode3,  
    
    input wire mode1_button,
    input wire add_one_or_mode2_button,
    output reg [3:0] current_state, // Debug
    output reminder,
    
    output  buzzer,
    output  buzzer_m6,
    output  buzzer_t1
);

localparam IDLE                 = 4'b0000; // 0
localparam STANDBY              = 4'b0001; // 1
localparam MENU                 = 4'b0011; // 3
localparam SETTING_GESTURE_TIME = 4'b0111; // 7
localparam SETTING_WORK_LIMIT   = 4'b0101; // 5
localparam SETTING_TIME         = 4'b0100; // 4
localparam QUERY_TIME           = 4'b1100; // 12


wire power_on;
wire power_on_pos;
wire power_on_neg;
wire[31:0] working_time;
wire clk_div;
wire return_standby;
// wire [4:0] hour;
// wire [5:0] min;
// wire [5:0] sec;
//SetWorkLimit
wire [31:0] work_time_limit;
wire [5:0] work_limit_an;
wire [7:0] work_limit_seg1;
wire [7:0] work_limit_seg2;
//gesture_setting
wire [3:0] gesture_time;
wire [7:0] gesture_sel_en;
wire [7:0] gesture_seg1;
//Clock
wire [5:0]clock_an;
wire [7:0] working_seg1;
wire [7:0] working_seg2;
wire [4:0] working_hour;
wire [5:0] working_min;
wire [5:0] working_sec;
//SetTimeDisplay
wire [5:0] set_time_an;
wire [7:0] set_time_seg1;
wire [7:0] set_time_seg2;
wire [4:0] time_display_hour;
wire [5:0] time_display_min;
wire [5:0] time_display_sec;
//mode_switch
wire [7:0] mode;
wire [7:0] mode_name;
wire [1:0] tubsel;
wire [1:0] number_select;
wire [2:0] clean_select;
buzz buzz_inst(
    .clk(clk),
    .start_signal(power_on_pos),
    .buzzer(buzzer),
    .m6(buzzer_m6),
    .t1(buzzer_t1)
);
PosEdgeDetection edge_detection_inst(
    .clk(clk),
    .edge_din(power_on),
    .rst_n(rst_n),
    .edge_out(power_on_pos)
);
NegeEdgeDetection nedge_detection_inst(
     .clk(clk),
   .edge_din(power_on),
   .rst_n(rst_n),
   .edge_out(power_on_neg)
);
LimitTimeSettingDisplay limit_time_setting_display_inst(
    .clk(clk),
    .rst_n(rst_n),
    .AddOne(add_one_or_mode2_button),
   .Confirm(power_button_or_select_or_mode3),
    .SettingLimit(current_state==SETTING_WORK_LIMIT),
    .work_time_limit(work_time_limit),
    .an(work_limit_an),
    .seg(work_limit_seg1),
    .seg2(work_limit_seg2)
);
// Power control module instantiation
powerControl power_control_inst (
    .clk(clk),
    .rst_n(rst_n),
    .power(power_on),
    .button(power_button_or_select_or_mode3),
    .button_left(left_or_clean_button),
    .button_right(right_button),
    .gesture_time(gesture_time)
);
WorkingTimeQuery working_time_query_inst(
    .clk(clk),
    .rst_n(rst_n),
    .en(current_state==QUERY_TIME),
    .hour(working_hour),
    .min(working_min),
    .sec(working_sec),
    .an(clock_an),
    .seg1(working_seg1),
    .seg2(working_seg2)
);

mode_switch mode_switch_inst(
    .clk(clk),
    .rst_n(rst_n),
    .enable(menu_button),
    .first(mode1_button),
    .second(add_one_or_mode2_button),
    .third(power_button_or_select_or_mode3),
    .clean_button(left_or_clean_button),
    .mode(mode),
    .mode_name(mode_name),
   .hour(working_hour),
   .min(working_min),
   .sec(working_sec),
    .tubsel(tubsel),
    .number_select(number_select),
    .clean_select(clean_select),
    .reminder(reminder),
    .power_on_pos(power_on_pos),
    .power_on(power_on),
    .standby(return_standby),
    .work_time_limit(work_time_limit)
);

gesture_setting gesture_setting_inst(
    .clk(clk),
    .rst_n(rst_n),
    .set_gesture_time_en(current_state==SETTING_GESTURE_TIME),
    .button(add_one_or_mode2_button),
    .gesture_time(gesture_time),
    .sel_en(gesture_sel_en),
    .seg1(gesture_seg1)
);

OverAllClock over_all_clock(
   .clk(clk),
   .rst_n(rst_n),
   .Working(power_on&&(current_state!=SETTING_TIME)),
   .AddOne(add_one_or_mode2_button),
   .Confirm(power_button_or_select_or_mode3),
   .Setting(set_current_time),
//   .hour(time_display_hour),
//   .min(time_display_min),
//   .sec(time_display_sec),
   .an(set_time_an),
   .seg(set_time_seg1),
    .seg2(set_time_seg2),
    .power_on_pos(power_on_pos)
);
Show show_inst(
    .clk(clk),
    .rst_n(rst_n),
    .state(current_state),
    .gesture_sel_en(gesture_sel_en),
    .gesture_seg1(gesture_seg1),
    .work_limit_an(work_limit_an),
    .work_limit_seg1(work_limit_seg1),
    .work_limit_seg2(work_limit_seg2),
    .clock_an(clock_an),
    .working_seg1(working_seg1),
    .working_seg2(working_seg2),
    .mode(mode),
    .mode_name(mode_name),
    .tubsel(tubsel),
    .number_select(number_select),
    .clean_select(clean_select),
    .reminder(reminder),
    .set_time_an(set_time_an),
    .set_time_seg1(set_time_seg1),
    .set_time_seg2(set_time_seg2),
    .sel_en(sel_en),
    .seg1(seg1),
    .seg2(seg2)
);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        light <= 0;
    end else if (power_on) begin
        if (light_switch) begin
            light <= 1'b1;
        end else begin
            light <= 0;
        end
    end else begin
        light <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        standby_led <= 0;
    end else if (power_on) begin
        if (current_state == STANDBY) begin
            standby_led <= 1'b1;
        end else begin
            standby_led <= 1'b0;
        end
    end else begin
        standby_led <= 0;
    end
end
// State machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        //working_time <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                
                if (power_on) begin
                    current_state <= STANDBY;
                end
            end
            STANDBY: begin
                

                if (!power_on) begin
                    current_state <= IDLE;
                end else if (menu_button) begin
                    current_state <= MENU;
                end else if (set_gesture_time) begin
                    current_state <= SETTING_GESTURE_TIME;
                end else if (set_current_time) begin
                    current_state <= SETTING_TIME;
                end else if (set_work_limit) begin
                    current_state <= SETTING_WORK_LIMIT;
                end else if (query_time) begin
                    current_state <= QUERY_TIME;
                end
            end
            MENU: begin
                if (return_standby) begin
                    current_state <= STANDBY;
                end
            end
            SETTING_GESTURE_TIME: begin
                if (!set_gesture_time) begin
                    current_state <= STANDBY;
                end 
            end
            SETTING_WORK_LIMIT: begin
                if (!set_work_limit) begin
                    current_state <= STANDBY;
                end
            end
            SETTING_TIME: begin
                if (!set_current_time) begin
                    current_state <= STANDBY;
                end 
            end
            QUERY_TIME: begin
                if (!query_time) begin
                    current_state <= STANDBY;
                end 
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

endmodule