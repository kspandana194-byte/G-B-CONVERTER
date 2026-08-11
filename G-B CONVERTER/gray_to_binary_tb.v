`timescale 1ns/1ps

module gray_to_binary_tb;

    reg  [3:0] gray;
    wire [3:0] binary;

    reg [3:0] expected_binary;
    integer i;
    integer errors;

    gray_to_binary uut (
        .gray(gray),
        .binary(binary)
    );

    // Function to calculate expected binary value
    function [3:0] gray2bin;
        input [3:0] g;
        begin
            gray2bin[3] = g[3];
            gray2bin[2] = gray2bin[3] ^ g[2];
            gray2bin[1] = gray2bin[2] ^ g[1];
            gray2bin[0] = gray2bin[1] ^ g[0];
        end
    endfunction

    initial begin

        $dumpfile("simulation/waveform.vcd");
        $dumpvars(0, gray_to_binary_tb);

        errors = 0;

        $display("==============================================");
        $display("       4-BIT GRAY TO BINARY CONVERTER");
        $display("                 TESTBENCH");
        $display("==============================================");
        $display("Time\tGray\tBinary\tExpected");
        $display("----------------------------------------------");

        // Test all 16 possible Gray inputs
        for (i = 0; i < 16; i = i + 1) begin

            gray = i;
            expected_binary = gray2bin(gray);

            #10;

            $display("%0t\t%b\t%b\t%b",
                     $time, gray, binary, expected_binary);

            if (binary !== expected_binary) begin

                $display("ERROR: Gray=%b Binary=%b Expected=%b",
                         gray, binary, expected_binary);

                errors = errors + 1;

            end
        end

        $display("----------------------------------------------");

        if (errors == 0)
            $display("RESULT: ALL 16 TESTS PASSED");
        else
            $display("RESULT: %0d TESTS FAILED", errors);

        $display("==============================================");

        $finish;
    end

endmodule