module module3(
    input clk,         // ����ʱ���ź� 100 MHz
    input rst_n,         // ��λ�ź�
    input rst_standby,   //���˵�ǿ���˳�
    input enable,
    output reg [1:0]seg_en,
    output reg [7:0] seg_out,
    input  jumpout,
    output reg jumpout_out=1'b0
    );
    reg [3:0]ge_wei;//��λ
    reg [3:0]shi_wei;//ʮλ
    // �����Ƶ����??100 MHz -> 1 Hz���� 100,000,000 ��ʱ����??
    reg [26:0] counter;  // 27 λ���������Ա�ʾ?? 100,000,000??2^27 > 100,000,000??
    wire rst_standby_pos;    //���˵�ǿ���˳�  ������
    PosEdgeDetection(
        .clk(clk),
        .rst_n(rst_n),
        .edge_din(rst_standby),
        .edge_out(rst_standby_pos)
    );
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)begin
            counter <= 27'b0;
            ge_wei <= 4'b0;
            shi_wei <= 4'b0;
            jumpout_out <= 1'b0;
        end
        else if(enable)begin
            if (rst_standby_pos) begin
                counter <= 27'b0;
                ge_wei <= 4'b0;
                shi_wei <= 4'b0;
            end 
            else begin
                if (counter == 27'd99_999_999) begin  // �ﵽ��Ƶ����ʱ�л���??
                    if(ge_wei==4'b1001)begin
                        if(shi_wei==4'b0101)begin
                            shi_wei <=4'b0000 ;
                            jumpout_out <=1'b1;
                        end
                        else begin
                        shi_wei <= shi_wei+1;
                        end
                        ge_wei <= 4'b0;
                    end
                    else begin
                        ge_wei <= ge_wei+1;  // ��ת�ź�
                    end
                    counter <= 27'b0;    // ��λ����??
                
                end 
                else begin
                counter <= counter + 1;  // �������� 1
                end
            end
        end
        else begin
            counter <= 27'b0;
            ge_wei <= 4'b0;
            shi_wei <= 4'b0;
            jumpout_out <= 1'b0;
        end
    end
    wire[3:0]ge_wei_inverse;//��λ
    wire[3:0]shi_wei_inverse;//ʮλ
    assign ge_wei_inverse = 4'b1001-ge_wei;
    assign shi_wei_inverse = 4'b0101-shi_wei;
    reg [7:0] seg_out_temp1;//��λ
    reg [7:0] seg_out_temp2;//ʮλ
    always @* begin
        if (!rst_n|rst_standby_pos)begin
            seg_out_temp1 = 8'b0000_0000;
        end 
        else if(enable)begin
            case (ge_wei_inverse)
                4'b0000: seg_out_temp1 = 8'b1111_1100; // 0
                4'b0001: seg_out_temp1 = 8'b0110_0000; // 1
                4'b0010: seg_out_temp1 = 8'b1101_1010; // 2
                4'b0011: seg_out_temp1 = 8'b1111_0010; // 3
                4'b0100: seg_out_temp1 = 8'b0110_0110; // 4
                4'b0101: seg_out_temp1 = 8'b1011_0110; // 5
                4'b0110: seg_out_temp1 = 8'b1011_1110; // 6
                4'b0111: seg_out_temp1 = 8'b1110_0000; // 7
                4'b1000: seg_out_temp1 = 8'b1111_1110; // 8
                4'b1001: seg_out_temp1 = 8'b1111_0110; // 9
                default: seg_out_temp1 = 8'b0000_0001; // Ĭ�Ϲر�??�ж�
            endcase
        end
        else begin
            seg_out_temp1 = 8'b0000_0000;
        end
    end
        always @* begin
            if (!rst_n|rst_standby_pos)begin
                seg_out_temp2 = 8'b0000_0000;
            end
            else if(enable)begin
                case (shi_wei_inverse)
                4'b0000: seg_out_temp2 = 8'b1111_1100; // 0
                4'b0001: seg_out_temp2 = 8'b0110_0000; // 1
                4'b0010: seg_out_temp2 = 8'b1101_1010; // 2
                4'b0011: seg_out_temp2 = 8'b1111_0010; // 3
                4'b0100: seg_out_temp2 = 8'b0110_0110; // 4
                4'b0101: seg_out_temp2 = 8'b1011_0110; // 5
                4'b0110: seg_out_temp2 = 8'b1011_1110; // 6
                4'b0111: seg_out_temp2 = 8'b1110_0000; // 7
                4'b1000: seg_out_temp2 = 8'b1111_1110; // 8
                4'b1001: seg_out_temp2 = 8'b1111_0110; // 9
                default: seg_out_temp2 = 8'b0000_0001; // Ĭ�Ϲر�??�ж�
                endcase
            end
            else begin
                seg_out_temp2 = 8'b0000_0000;
            end
    end

    reg clkout;
    reg [31:0] cnt;
    reg scan_cnt;
    parameter period=200000;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)begin
            cnt <=0;
            clkout <=0;
        end
        else if(enable)begin
            if(!rst_n|rst_standby_pos)begin
                cnt <=0;
                clkout <=0;
            end
            else begin 
                if(cnt == (period >> 1)-1) begin
                    clkout <= ~clkout;
                    cnt <=0;
                end
                else cnt <=cnt+1;
            end
        end
        else begin
            cnt <=0;
            clkout <=0;
        end
    end


    always @(posedge clkout ,negedge rst_n)begin
        if (!rst_n)begin
            scan_cnt <=0;
        end
        else
        if(enable)begin
            if(!rst_n|rst_standby_pos)begin
                scan_cnt <=0;
            end
            else begin
                if(scan_cnt==1'b1)begin
                    scan_cnt <=0;
                end
                else scan_cnt <=scan_cnt+1;
            end
        end
        else begin
            scan_cnt <=0;
        end
    end


    always @(scan_cnt)begin
        if (!rst_n)begin
            seg_en=2'b00;
            seg_out=8'b0000_0000;
        end
        else
        if(enable)begin
            if(scan_cnt)begin
                seg_en=2'b10;
                seg_out=seg_out_temp2;
            end
            else begin
                seg_en=2'b01;
                seg_out=seg_out_temp1;
            end
        end
        else begin
         seg_en=2'b00;
         seg_out=8'b0000_0000;
        end
    end
endmodule
