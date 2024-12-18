module mode_switch(
    input clk,            // 时钟信号
    input rst_n,          // 复位信号，低有效
    input first,second,third,clean_button,
    // output reg mode_output,   // 测试用的灯

    output [7:0] mode,
    output [7:0] mode_name,
    output [1:0]tubsel,
    
    output [1:0]number_select,
    
    output [2:0]clean_select,
    
//    input [31:0]work_time_limit,   //工作时间上限
//    output reg [31:0] work_time_out,  //工作时间
    output reg reminder               //智能提醒，如果工作时间过长就提醒

);
    wire[7:0] mode1 , mode_name1;
    wire [1:0]tubsel_mode1;
    wire[7:0] mode2 , mode_name2;  
    wire [1:0]tubsel_mode2;
    wire [7:0]mode3;
    wire [1:0]tubsel_mode3;
    wire [7:0]mode_clean;
    wire [2:0]tubsel_clean;

    // 去抖动信号
    wire first_stable,second_stable,third_stable,clean_stable;
     // 为每个按键实例化消抖模块
    debounce debounce_0 (
        .clk(clk),
        .rst_n(~rst_n),
        .key_in(first),
        .key_stable(first_stable)
    );

    debounce debounce_1 (
        .clk(clk),
        .rst_n(~rst_n),
        .key_in(second),
        .key_stable(second_stable)
    );

    debounce debounce_2 (
        .clk(clk),
        .rst_n(~rst_n),
        .key_in(third),
        .key_stable(third_stable)
    );

    debounce debounce_3 (
        .clk(clk),
        .rst_n(~rst_n),
        .key_in(clean_button),
        .key_stable(clean_stable)
    );

    reg first_enable;
    reg second_enable;
    reg third_enable;
    reg clean_enable;

    parameter S0=3'b0;
     parameter S1=3'b001;
     parameter S2=3'b010;
     parameter S3=3'b011;
     parameter S4=3'b100;



  parameter defult_work_time_limit=16'd36000; //默认工作时长，10小时，36000秒
  reg [31:0]work_time=32'd0;   
  reg judge=1'b1;                             //当触发智能提醒的时候让灯一直亮
//此处用来增加工作时间，这里是分频器生成1s    
     initial reminder=1'b0;
      reg [26:0] counter;  // 27 位计数器可以表示到 100,000,000（2^27 > 100,000,000）
      always @(posedge clk) begin
        if (counter == 27'd99_999_999) begin
            work_time<=work_time+1;         //工作时间
            if(work_time==defult_work_time_limit)begin
                reminder<=1'b1;
                judge<=1'b0;
            end
            else begin
                if(judge)begin
                    reminder<=1'b0;
                end
                else begin
                    reminder<=reminder;
                end
            end
            counter <= 27'b0;
        end
        else begin
            case(state)
                S1:begin counter<=counter+1;end
                S2:begin counter<=counter+1;end
                S3:begin counter<=counter+1;end
                default:begin counter<=counter;end
        endcase
        end
      end
     
     
    reg jumpout=1'b0;
    wire jumpout_out;
    
    reg jumpout_clean=1'b0;
    wire jumpout_out_clean;
    reg [2:0]state=S0;
    always @(posedge clk)begin
        case (state)
            S0:begin 
                first_enable<=1'b0;
                second_enable<=1'b0;
                third_enable<=1'b0;
                clean_enable<=1'b0;
                 if(first_stable)begin state<=S1; end
                else if(second_stable)begin state<=S2;end
                else if(third_stable)begin                  //这里的作用是判断挡位三是否只使用了一次
                    if(~jumpout)begin
                        state<=S3;
                    end
                    else begin
                        state<=state;
                    end
                end
                else if(clean_stable)begin state<=S4;end
                else begin state<=state ;end
               end
             S1:begin
                    first_enable<=1'b1;
                    second_enable<=1'b0;
                    third_enable<=1'b0;
                    clean_enable<=1'b0;
                     if(second_stable)begin state<=S2;end
                    else begin state<=state ;end                  //一档模式下只可以切换到二档
                  end
              S2:begin
                    first_enable<=1'b0;
                    second_enable<=1'b1;
                    third_enable<=1'b0;
                    clean_enable<=1'b0;
                    if(first_stable)begin state<=S1; end
                    else begin state<=state ;end                 //二档模式下只可以切换到一档
                  end
               S3:begin
                    first_enable<=1'b0;
                    second_enable<=1'b0;
                    third_enable<=1'b1;
                    clean_enable<=1'b0;
                    if(jumpout_out)begin state<=S2;
                        // mode_output<=1'b1;
                        jumpout<=1'b1;
                    end                             //三档模式只有等待60秒之后回到二档
                    else begin state<=state ;end
                   end
                S4:begin
                    first_enable<=1'b0;
                    second_enable<=1'b0;
                    third_enable<=1'b0;
                    clean_enable<=1'b1;
//                    work_time<=32'b0;                       //工作时间清0
                    if(jumpout_out_clean)begin 
                        state<=S0;                      //理论上这里应该切换回省电模式，但这里切回了S0，需后续结合菜单键
                    end
                    else begin state<=state ;end
                    end
                default begin state<=S0;end
                                
        endcase
    end
    assign mode=mode1|mode2|mode_clean ;
    assign mode_name=mode_name1|mode_name2|mode3;
    assign tubsel=tubsel_mode1|tubsel_mode2;
//    assign mode_output=1'b0;
    assign number_select=tubsel_mode3;
    assign clean_select=tubsel_clean;


module1 model1(.mode(mode1),.one(mode_name1),.tubsel_mode(tubsel_mode1[1]),.tubsel_one(tubsel_mode1[0]),.enable(first_enable));
module2 model2(.mode(mode2),.two(mode_name2),.tubsel_mode(tubsel_mode2[1]),.tubsel_two(tubsel_mode2[0]),.enable(second_enable));
module3 model3(.clk(clk),.rst(rst),.seg_out(mode3),.seg_en(tubsel_mode3),.jumpout(jumpout),.enable(third_enable),.jumpout_out(jumpout_out));
clean cleans(.clk(clk),.rst_n(rst),.seg(mode_clean),.an(tubsel_clean),.enable(clean_enable),.jumpout(jumpout_clean),.jumpout_out(jumpout_out_clean));


endmodule

    