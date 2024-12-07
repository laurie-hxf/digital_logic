module count_down(
    input clk,         // 输入时钟信号 100 MHz
    input rst,         // 复位信号
    output reg [1:0]seg_en,
    output reg [7:0] seg_out,
    output reg jumpout
    );
    initial jumpout =1'b0;
    reg [3:0]ge_wei;//个位
    reg [3:0]shi_wei;//十位
    // 计算分频因子，100 MHz -> 1 Hz，即 100,000,000 个时钟周期
    reg [26:0] counter;  // 27 位计数器可以表示到 100,000,000（2^27 > 100,000,000）
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 27'b0;
            ge_wei <= 4'b0;
            shi_wei <= 4'b0;
        end else begin
            if (counter == 27'd99_999_999) begin  // 达到分频因子时切换信号
                if(ge_wei==4'b1001)begin
                    if(shi_wei==4'b0101)begin
                        shi_wei <= 0;
                        jumpout <=1;
                    end
                    else begin
                        shi_wei <= shi_wei+1;
                    end
                      ge_wei <= 4'b0;
                end
                else begin
                    ge_wei <= ge_wei+1;  // 翻转信号
                end
                counter <= 27'b0;    // 复位计数器
                
            end else begin
                counter <= counter + 1;  // 计数器加 1
            end
        end
    end
    wire[3:0]ge_wei_inverse;//个位
    wire[3:0]shi_wei_inverse;//十位
    assign ge_wei_inverse = 4'b1001-ge_wei;
    assign shi_wei_inverse = 4'b0101-shi_wei;
    reg [7:0] seg_out_temp1;//个位
    reg [7:0] seg_out_temp2;//十位
    always @* begin
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
            default: seg_out_temp1 = 8'b0000_0001; // 默认关闭所有段
        endcase
    end
        always @* begin
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
            default: seg_out_temp2 = 8'b0000_0001; // 默认关闭所有段
        endcase
    end

    reg clkout;
    reg [31:0] cnt;
    reg scan_cnt;
    parameter period=200000;
    always @(posedge clk or posedge rst) begin
        if(rst)begin
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


    always @(posedge clkout ,negedge rst)begin
        if(rst)begin
            scan_cnt <=0;
        end
        else begin
            if(scan_cnt==1'b1)begin
                scan_cnt <=0;

            end
            else scan_cnt <=scan_cnt+1;
        end
    end


    always @(scan_cnt)begin
        if(scan_cnt)begin
            seg_en=2'b10;
            seg_out=seg_out_temp2;
        end
        else begin
            seg_en=2'b01;
            seg_out=seg_out_temp1;
        end
    end
endmodule