module buzz(
    input wire clk,          // 100MHz clock input
    input wire start_signal, // Signal to start the sound
    output reg buzzer,        // Buzzer output
    output m6,
    output t1
);

    reg [23:0] counter = 0; // Counter for frequency division
    reg [2:0] state = 0;    // State for note sequence
    reg [23:0] divisor;     // Current divisor for frequency
    reg [31:0] duration_counter = 0; // Duration counter for each note
    reg active = 0;         // Active flag for sound sequence

    // Frequencies for do, re, mi (in Hz)
    parameter DO_FREQ = 262; // C4
    parameter RE_FREQ = 294; // D4
    parameter MI_FREQ = 330; // E4

    // Calculate divisors for each note
    parameter DO_DIV = 100000000 / (2 * DO_FREQ);
    parameter RE_DIV = 100000000 / (2 * RE_FREQ);
    parameter MI_DIV = 100000000 / (2 * MI_FREQ);

    // Duration for each note (in clock cycles)
    parameter NOTE_DURATION = 100000000; // 1 second
    assign m6=1'b1;
    assign t1=1'b0;
    always @(posedge clk) begin
        if (start_signal) begin
            active <= 1; // Activate sound sequence on start signal
            state <= 0;  // Reset state
            duration_counter <= 0;
        end

        if (active) begin
            // Handle frequency division
            if (counter < divisor) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
                buzzer <= ~buzzer; // Toggle the buzzer output
            end

            // Handle note duration
            if (duration_counter < NOTE_DURATION) begin
                duration_counter <= duration_counter + 1;
            end else begin
                duration_counter <= 0;
                state <= state + 1; // Move to the next note

                // Set the divisor based on the current state
                case (state)
                    0: divisor <= DO_DIV;
                    1: divisor <= RE_DIV;
                    2: divisor <= MI_DIV;
                    default: active <= 0; // Deactivate after last note
                endcase
            end
        end else begin
            buzzer <= 0; // Turn off buzzer when not active
        end
    end
endmodule
