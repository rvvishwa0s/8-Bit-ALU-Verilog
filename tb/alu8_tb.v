`timescale 1ns/1ps
`default_nettype none

module alu8_tb;

    reg  [7:0] A;
    reg  [7:0] B;
    reg  [2:0] OP;
    wire [7:0] RESULT;
    wire ZERO, CARRY, OVERFLOW, NEGATIVE;

    integer errors;
    integer tests;

    alu8 dut (
        .A(A), .B(B), .OP(OP),
        .RESULT(RESULT),
        .ZERO(ZERO), .CARRY(CARRY),
        .OVERFLOW(OVERFLOW), .NEGATIVE(NEGATIVE)
    );

    task check_result;
        input [7:0] expected_result;
        input expected_carry;
        input expected_overflow;
        input [8*40-1:0] label_text;
        begin
            #1;
            tests = tests + 1;
            if (RESULT !== expected_result ||
                CARRY !== expected_carry ||
                OVERFLOW !== expected_overflow ||
                ZERO !== (expected_result == 8'h00) ||
                NEGATIVE !== expected_result[7]) begin
                errors = errors + 1;
                $display("FAIL: %0s", label_text);
                $display("  A=%02h B=%02h OP=%03b RESULT=%02h C=%b V=%b Z=%b N=%b",
                         A, B, OP, RESULT, CARRY, OVERFLOW, ZERO, NEGATIVE);
                $display("  Expected RESULT=%02h C=%b V=%b",
                         expected_result, expected_carry, expected_overflow);
            end else begin
                $display("PASS: %0s", label_text);
            end
        end
    endtask

    initial begin
        errors = 0;
        tests = 0;
        $dumpfile("build/alu8.vcd");
        $dumpvars(0, alu8_tb);

        // Addition
        A=8'd10; B=8'd20; OP=3'b000;
        check_result(8'd30, 1'b0, 1'b0, "ADD 10 + 20");

        A=8'hFF; B=8'h01; OP=3'b000;
        check_result(8'h00, 1'b1, 1'b0, "ADD unsigned carry");

        A=8'h7F; B=8'h01; OP=3'b000;
        check_result(8'h80, 1'b0, 1'b1, "ADD signed positive overflow");

        A=8'h80; B=8'h80; OP=3'b000;
        check_result(8'h00, 1'b1, 1'b1, "ADD signed negative overflow");

        // Subtraction: CARRY is defined as borrow
        A=8'd25; B=8'd10; OP=3'b001;
        check_result(8'd15, 1'b0, 1'b0, "SUB no borrow");

        A=8'd5; B=8'd9; OP=3'b001;
        check_result(8'hFC, 1'b1, 1'b0, "SUB borrow");

        A=8'h80; B=8'h01; OP=3'b001;
        check_result(8'h7F, 1'b0, 1'b1, "SUB signed overflow");

        // Logical operations
        A=8'hF0; B=8'h0F; OP=3'b010;
        check_result(8'h00, 1'b0, 1'b0, "AND");

        A=8'hF0; B=8'h0F; OP=3'b011;
        check_result(8'hFF, 1'b0, 1'b0, "OR");

        A=8'hAA; B=8'hFF; OP=3'b100;
        check_result(8'h55, 1'b0, 1'b0, "XOR");

        A=8'h55; B=8'h00; OP=3'b101;
        check_result(8'hAA, 1'b0, 1'b0, "NOT");

        // Shifts
        A=8'h81; B=8'h00; OP=3'b110;
        check_result(8'h02, 1'b1, 1'b0, "Logical left shift");

        A=8'h81; B=8'h00; OP=3'b111;
        check_result(8'h40, 1'b1, 1'b0, "Logical right shift");

        if (errors == 0)
            $display("\nRESULT: ALL %0d TESTS PASSED", tests);
        else
            $display("\nRESULT: %0d OF %0d TESTS FAILED", errors, tests);

        $finish;
    end

endmodule

`default_nettype wire
