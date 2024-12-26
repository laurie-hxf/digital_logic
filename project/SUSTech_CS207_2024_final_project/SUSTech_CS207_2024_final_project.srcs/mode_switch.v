module mode_switch(
    input clk,            // ʱ���ź�
    input rst_n,          // ��λ�źţ�����Ч
    input first,second,third,clean_button,
     output reg mode_output,   // �����õ�????????
    input enable,               //�˵���
    input power_on_pos, 
    input power_on,       
    output [7:0] mode,
    output [7:0] mode_name,
    output [1:0]tubsel,
    
    output [1:0]number_select,
    
    output [2:0]clean_select,                     //���²˵�����ģʽ����
    output reg standby,              //�������??
   input [31:0]work_time_limit,   //����ʱ������
    output reg [31:0] work_time,  //����ʱ��
    output reg reminder,               //�������ѣ��������ʱ�����������
    output reg [4:0]hour, 
    output reg[5:0]min, 
    output reg[5:0]sec,
      output reg state1,
      output reg state2,
      output reg state3,
      output reg state4,
      output reg state0
);
    wire[7:0] mode1 , mode_name1;
    wire [1:0]tubsel_mode1;
    wire[7:0] mode2 , mode_name2;  
    wire [1:0]tubsel_mode2;
    wire [7:0]mode3;
    wire [1:0]tubsel_mode3;
    wire [7:0]mode_clean;
    wire [2:0]tubsel_clean;

    // ȥ������????????
    wire first_stable,second_stable,third_stable,clean_stable;
    wire enable_neg;
    NegeEdgeDetection negeEdgeDetection(
        .clk(clk),
        .rst_n(rst_n),
        .edge_din(enable),
        .edge_out(enable_neg)
     );
     // Ϊÿ������ʵ��������ģ��
    debounce debounce_0 (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(first),
        .key_stable(first_stable)
    );

    debounce debounce_1 (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(second),
        .key_stable(second_stable)
    );

    debounce debounce_2 (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(third),
        .key_stable(third_stable)
    );

    debounce debounce_3 (
        .clk(clk),
        .rst_n(rst_n),
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



// reg defult_work_time_limit=work_time_limit; //Ĭ�Ϲ���ʱ��????????10Сʱ????????36000????????
//reg defult_work_time_limit=2'b11; 
reg judge;                             //�����ѵĵ�һֱ����


////�˴��������ӹ���ʱ�䣬�����Ƿ�Ƶ����????????1s    
     //�������������ѵ�ʱ???�õ�һֱ��
      reg [26:0] counter;  // 27 λ���������Ա�ʾ???????? 100,000,000????????2^27 > 100,000,000????????
      always @(posedge clk or negedge rst_n) begin
        if (!rst_n|power_on_pos) begin
            counter <= 27'b0;
            sec <= 6'd0;
            min <= 6'd0;
            hour <= 5'd0;
            work_time<=32'd0;
            judge<=1'b1;
            reminder<=1'b0;
        end
        else if(!power_on)begin
            counter <= 27'b0;
            sec <= 6'd0;
            min <= 6'd0;
            hour <= 5'd0;
            work_time<=32'd0;
            judge<=1'b1;
            reminder<=1'b0;
        end
        else if (counter == 27'd99_999_999) begin
            work_time<=work_time+1;
            if (sec == 59) begin
                sec <= 0;
                if (min == 59) begin
                    min <= 0;
                    hour <= hour + 1;
                end else begin
                    min <= min + 1;
                end
            end else begin
                sec <= sec + 1;
            end
            if(work_time==work_time_limit)begin
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
                S4:begin
                    work_time<=0;
                    judge<=1'b1; 
                    sec <= 6'd0;
                    min <= 6'd0;
                    hour <= 5'd0;
                    reminder<=1'b0;
                end
                default:begin counter<=counter;end
        endcase
        end         
      end

    reg jumpout=1'b0;                   //�ж�ģʽ���Ƿ�ʹ��һ��
    wire jumpout_out;                   //�ж�ģʽ���Ƿ�����
    reg rst_standby;                    //�ж��Ƿ�ص�����״�?
    reg jumpout_clean=1'b0;
    wire jumpout_out_clean;
    reg [2:0]state=S0;
    reg decide;
    always @(posedge clk) begin
    if(!rst_n)begin         //add
         state=S0;
         first_enable<=1'b0;
         second_enable<=1'b0;
         third_enable<=1'b0;
         clean_enable<=1'b0;
         jumpout=1'b0;
         standby<=1'b1;
          rst_standby<=1'b0;
    end
    else begin
        case (state)
            S0:begin 
                state0<=1'b1;
                state1<=1'b0;
                state2<=1'b0;
                state3<=1'b0;
                state4<=1'b0;
                first_enable<=1'b0;
                second_enable<=1'b0;
                third_enable<=1'b0;
                clean_enable<=1'b0;
                standby <= 1'b0;
                if(first_stable)begin state<=S1; end
                else if(second_stable)begin state<=S2;end
                else if(third_stable)begin                  //������������жϵ�λ���Ƿ�ֻʹ�����?????????
                    if(!jumpout)begin
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
               state0<=1'b0;
               state1<=1'b1;
               state2<=1'b0;
               state3<=1'b0;
               state4<=1'b0;
                    first_enable<=1'b1;
                    second_enable<=1'b0;
                    third_enable<=1'b0;
                    clean_enable<=1'b0;
                    standby <= 1'b0;
                    if(second_stable)begin state<=S2;end
                    else begin state<=state ;end                  //????????��ģʽ��ֻ�����л�������
                  end
              S2:begin
                state0<=1'b0;
                state1<=1'b0;
                state2<=1'b1;
                state3<=1'b0;
                state4<=1'b0;
                    first_enable<=1'b0;
                    second_enable<=1'b1;
                    third_enable<=1'b0;
                    clean_enable<=1'b0;
                    standby <= 1'b0;
                    if(first_stable)begin state<=S1; end
                    else begin state<=state ;end                 //����ģʽ��ֻ�����л���һ????????
                  end
               S3:begin
                 state0<=1'b0;
                 state1<=1'b0;
                 state2<=1'b0;
                 state3<=1'b1;
                 state4<=1'b0;
                    first_enable<=1'b0;
                    second_enable<=1'b0;
                    third_enable<=1'b1;
                    clean_enable<=1'b0;
                    standby <= 1'b0;
                    if(jumpout_out)begin 
                        if(!decide)begin
                            state<=S2;
                            // mode_output<=1'b1;
                            jumpout<=1'b1;              //������ֻ�ܽ���һ��
                        end
                        else begin
                            rst_standby<=1'b0;
                            state=S0;
//                            decide=1'b0;
                            jumpout<=1'b1;
                            standby<=1'b1;
                        end
                    end                             //����ģʽֻ�еȴ�60��֮��ص���??????????
                    else begin 
                        if(enable_neg)begin
                            rst_standby<=1'b1;
                            decide=1'b1;
                            state<=state;
                        end
                        else begin
//                        if(jumpout_out)begin
//                             rst_standby<=1'b0;
//                             state<=S0;
//                             jumpout<=1'b1;
//                             standby<=1'b1;
//                         end
                            state<=state;
                            end
                        end
                   end
                S4:begin
                  state0<=1'b0;
                  state1<=1'b0;
                  state2<=1'b0;
                  state3<=1'b0;
                  state4<=1'b1;
                    first_enable<=1'b0;
                    second_enable<=1'b0;
                    third_enable<=1'b0;
                    clean_enable<=1'b1;                     //����ʱ��????????0
                    standby <= 1'b0;
                    if(jumpout_out_clean)begin 
                        standby<=1'b1;                  //�лش���
                        state<=S0;                      //����������Ӧ���л���ʡ��ģʽ���������л���S0���������ϲ˵�????
                    end
                    else begin state<=state ;end
                    end
                default begin state<=S0;end                    
            endcase
            end
             if(!enable)begin
                if(state==S3)begin
                    state<=state;
                    mode_output<=1'b0;
                 end
//                 else if(state==S4)begin
//                    state<=state;
//                 end
                 else begin
                  mode_output<=1'b1;
                  state<=S0;
                  first_enable<=1'b0;
                  second_enable<=1'b0;
                  third_enable<=1'b0;
                  clean_enable<=1'b0;
                  standby<=1'b1;
                  end
             end
             else if(enable_neg&&(state!=S4)&&(state!=S3))begin
                 standby<=1'b1;
             end
//             else begin
//                state<=state;
//             end
             
    end
    assign mode=mode1|mode2|mode_clean ;
    assign mode_name=mode_name1|mode_name2|mode3;
    assign tubsel=tubsel_mode1|tubsel_mode2;
    assign number_select=tubsel_mode3;
    assign clean_select=tubsel_clean;
    // assign working=state||3'b000;

module1 model1(.mode(mode1),.one(mode_name1),.tubsel_mode(tubsel_mode1[1]),.tubsel_one(tubsel_mode1[0]),.enable(first_enable));
module2 model2(.mode(mode2),.two(mode_name2),.tubsel_mode(tubsel_mode2[1]),.tubsel_two(tubsel_mode2[0]),.enable(second_enable));
module3 model3(.clk(clk),.rst_n(rst_n),.seg_out(mode3),.seg_en(tubsel_mode3),.jumpout(jumpout),.enable(third_enable),.jumpout_out(jumpout_out),.rst_standby(rst_standby));
clean cleans(.clk(clk),.rst_n(rst_n),.seg(mode_clean),.an(tubsel_clean),.enable(clean_enable),.jumpout(jumpout_clean),.jumpout_out(jumpout_out_clean));


endmodule
