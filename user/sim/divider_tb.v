`timescale 1ns / 1ps

module divider_tb;

    reg clk;
    reg start;
    reg signed_div;
    reg [31:0] dividend;
    reg [31:0] divisor;

    wire done;
    wire [31:0] quotient;
    wire [31:0] remainder;

    divider uut (
                .clk(clk),
                .start(start),
                .signed_div(signed_div),
                .dividend(dividend),
                .divisor(divisor),
                .done(done),
                .quotient(quotient),
                .remainder(remainder)
            );

    initial begin
        clk = 0;
        forever
            #10 clk = ~clk;
    end

    initial begin
        $dumpfile("divider_tb.vcd");
        $dumpvars(0, divider_tb);

        start = 0;
        signed_div = 0;
        dividend = 0;
        divisor = 0;

        #100;

        start = 1;
        signed_div = 0;
        dividend = 32'h00000200;
        divisor = 32'h00000100;
        #20;
        start = 0;
        wait(done);
        #20;

        #100;
        start = 1;
        signed_div = 0;
        dividend = 32'hffffffff;
        divisor = 32'h1;
        #20;
        start = 0;
        wait(done);
        #20;

        #100;
        start = 1;
        signed_div = 0;
        dividend = 32'h80000001;
        divisor = 32'h2;
        #20;
        start = 0;
        wait(done);
        #20;

        #100;
        start = 1;
        signed_div = 1;
        dividend = 32'h00000200;
        divisor = -32'h00000100;
        #20;
        start = 0;
        wait(done);
        #20;

        #100;
        start = 1;
        signed_div = 1;
        dividend = -32'h00000200;
        divisor = -32'h00000100;
        #20;
        start = 0;
        wait(done);
        #20;

        #100;
        start = 1;
        signed_div = 1;
        dividend = -32'h00000200;
        divisor = 32'h00000100;
        #20;
        start = 0;
        wait(done);
        #20;

        #100;
        start = 1;
        signed_div = 1;
        dividend = -32'h11451419;
        divisor = -32'h19810fff;
        #20;
        start = 0;
        wait(done);
        #20;

        #100;
        $finish;
    end

endmodule
