// 8-bit Arithmetic Logic Unit
// Project: RTL-to-GDSII implementation using open-source VLSI tools
// License: MIT

`default_nettype none

module alu8 #(
    parameter integer WIDTH = 8
) (
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire [2:0]       OP,
    output reg  [WIDTH-1:0] RESULT,
    output reg              ZERO,
    output reg              CARRY,
    output reg              OVERFLOW,
    output reg              NEGATIVE
);

    reg [WIDTH:0] arithmetic_temp;

    always @* begin
        RESULT          = {WIDTH{1'b0}};
        CARRY           = 1'b0;
        OVERFLOW        = 1'b0;
        arithmetic_temp = {(WIDTH+1){1'b0}};

        case (OP)
            3'b000: begin // ADD
                arithmetic_temp = {1'b0, A} + {1'b0, B};
                RESULT = arithmetic_temp[WIDTH-1:0];
                CARRY = arithmetic_temp[WIDTH];
                OVERFLOW = (~(A[WIDTH-1] ^ B[WIDTH-1])) &
                           (RESULT[WIDTH-1] ^ A[WIDTH-1]);
            end

            3'b001: begin // SUB; CARRY indicates borrow (A < B)
                arithmetic_temp = {1'b0, A} - {1'b0, B};
                RESULT = arithmetic_temp[WIDTH-1:0];
                CARRY = (A < B);
                OVERFLOW = (A[WIDTH-1] ^ B[WIDTH-1]) &
                           (RESULT[WIDTH-1] ^ A[WIDTH-1]);
            end

            3'b010: RESULT = A & B;
            3'b011: RESULT = A | B;
            3'b100: RESULT = A ^ B;
            3'b101: RESULT = ~A;

            3'b110: begin // Logical left shift by one
                RESULT = A << 1;
                CARRY = A[WIDTH-1];
            end

            3'b111: begin // Logical right shift by one
                RESULT = A >> 1;
                CARRY = A[0];
            end

            default: begin
                RESULT = {WIDTH{1'b0}};
            end
        endcase

        ZERO     = (RESULT == {WIDTH{1'b0}});
        NEGATIVE = RESULT[WIDTH-1];
    end

endmodule

`default_nettype wire
