module powerControl(
    input wire clk,
    input wire rst_n,
    input wire button,
    input wire button_left,
    input wire button_right,
    input wire [3:0]gesture_time,
    output reg power
    //output reg[2:0] current_state,
    //output reg[2:0] next_state
);

    // 状�?�编�?
    parameter OFF = 3'b111, ON = 3'b001, WAIT_OFF = 3'b010, WAIT_RELEASE = 3'b000,WAIT_RIGHT=3'b100,WAIT_LEFT=3'b011;
    reg[2:0]current_state;
    reg [2:0] next_state;
    reg [31:0] counter; // 用于计时的计数器
    // 状�?�寄存器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= OFF;
            counter <= 32'b0;
        end else begin
            current_state <= next_state;
            if ((current_state == WAIT_OFF&&button)||current_state==WAIT_RIGHT||current_state==WAIT_LEFT) begin
                counter <= counter + 1;
            end else begin
                counter <= 32'b0;
            end
        end
    end

    // 状�?�转移�?�辑
    always @(*) begin
        next_state = current_state;
        case (current_state)
            OFF: begin
                if (button) begin
                    next_state = ON;
                end
                else if(button_left)begin
                    next_state=WAIT_RIGHT;
                end
            end
            WAIT_RIGHT:begin
                if(counter >=gesture_time*100_000_000)begin
                 //if(counter >=32'd500_000_000)begin
                    next_state=OFF;
                end
                else if(button_right)begin
                    next_state= ON;
                end
            end
            WAIT_LEFT:begin
                if(counter>=gesture_time*100_000_000)begin
                //if(counter >=32'd500_000_000)begin
                    next_state= ON;
                end
                else if(button_left)begin
                    next_state=OFF;
                end
            end
            ON: begin
                if (button) begin
                    next_state = WAIT_OFF;
                end
                else if(button_right)begin
                    next_state=WAIT_LEFT;
                end
            end
            WAIT_OFF: begin
                 if (counter >=32'd300_000_000) begin 
                    next_state = WAIT_RELEASE;
                end
            end
            WAIT_RELEASE: begin
                if (!button) begin
                    next_state = OFF;
                end
                // else if(!button_right)begin
                // next_state=ON;
                // end
                // else if(!button_left)begin
                //     next_state=OFF;
                // end
            end
        endcase
    end

    // 输出逻辑
    always @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin
            power <= 1'b0;
        end else begin
            case (current_state)
                OFF: power <= 1'b0;
                ON: power <= 1'b1;
                WAIT_OFF: power <= 1'b1;
                WAIT_RELEASE: power <= 1'b0;
                WAIT_LEFT:power<=1'b1;
                WAIT_RIGHT:power<=1'b0;
            endcase
        end
    end

endmodule