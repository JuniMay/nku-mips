`timescale 1ns / 1ps

/// This is a FSM-based divider module.
/// I don't know if this is the best implementation or if this is perfect, but the testbench passed.
module divider(
        input wire clk,
        input wire start,
        input wire signed_div,
        input wire [31:0] dividend,
        input wire [31:0] divisor,
        output wire done,
        output wire [31:0] quotient,
        output wire [31:0] remainder
    );

    reg dividend_sign;
    reg divisor_sign;

    reg [31:0] dividend_abs;
    reg [31:0] divisor_abs;

    always @(*) begin
        dividend_abs = (dividend[31] && signed_div) ? ((~dividend) + 1) : dividend;
        divisor_abs = (divisor[31] && signed_div) ? ((~divisor) + 1) : divisor;

        dividend_sign = dividend[31];
        divisor_sign = divisor[31];
    end

    wire remainder_sign = dividend_sign && signed_div;
    wire result_sign = (remainder_sign ^ divisor_sign) && signed_div;

    reg [63:0] remainder_quotient;

    assign remainder = remainder_sign ? ((~remainder_quotient[63:32]) + 1) : remainder_quotient[63:32];
    assign quotient = result_sign ? ((~remainder_quotient[31:0]) + 1) : remainder_quotient[31:0];

    reg [5:0] counter;

    /// State parameters
    localparam IDLE = 0, SUBSTRACT = 1, SHIFT = 2, FINISH = 3;

    reg [1:0] state;

    reg set_bit;

    initial begin
        state = IDLE;
        counter = 0;
        set_bit = 0;
        remainder_quotient = 0;
    end

    assign done = (state == FINISH);

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                counter <= 0;
                if (start) begin
                    remainder_quotient <= {31'd0, dividend_abs, 1'b0};
                    state <= SUBSTRACT;
                end
                else begin
                    remainder_quotient <= 0;
                    state <= IDLE;
                end
            end
            SUBSTRACT: begin
                if (remainder_quotient[63:32] >= divisor_abs) begin
                    remainder_quotient[63:32] <= remainder_quotient[63:32] - divisor_abs;
                    set_bit <= 1'b1;
                end
                else begin
                    remainder_quotient[63:32] <= remainder_quotient[63:32];
                    set_bit <= 1'b0;
                end
                state <= SHIFT;
            end
            SHIFT: begin
                if (counter == 31) begin
                    remainder_quotient <= {1'b0, remainder_quotient[62:32], remainder_quotient[30:0], set_bit};
                    state <= FINISH;
                end
                else begin
                    remainder_quotient <= {remainder_quotient[62:0], set_bit};
                    state <= SUBSTRACT;
                end
                counter <= counter + 1;
            end
            FINISH: begin
                state <= IDLE;
            end
        endcase
    end
endmodule
