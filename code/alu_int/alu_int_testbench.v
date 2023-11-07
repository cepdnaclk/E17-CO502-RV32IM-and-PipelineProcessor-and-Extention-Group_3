`include "../../code/alu_int/alu_int.v"
`timescale 1ns/1ps

`timescale 1ns/100ps

module test_bench_alu_int;

    // Inputs
    reg [31:0] OP1, OP2;
    reg [4:0] ALU_OP;

    // Outputs
    wire [31:0] RESULT;
    wire ZERO, SIGN_BIT, SLTU_BIT;

    // Instantiate the ALU module
    alu_int uut (
        .OP1(OP1),
        .OP2(OP2),
        .ALU_OP(ALU_OP),
        .RESULT(RESULT),
        .ZERO(ZERO),
        .SIGN_BIT(SIGN_BIT),
        .SLTU_BIT(SLTU_BIT)
    );

    // Initial block to apply inputs and test cases
    initial begin
        // Test case 1: ALU_OP=0 (ADD)
        OP1 = 10;
        OP2 = 5;
        ALU_OP = 5'b00000; // Set ALU_OP to 0 (ADD)
        #10; // Wait for a few time units
        // Check the expected results
        if (RESULT === 15 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0) begin
            $display("Test case 1 (ADD): PASSED");
        end else begin
            $display("Test case 1 (ADD): FAILED");
        end

        // Test case 2: ALU_OP=1 (SLL)
        OP1 = 5;
        OP2 = 2;
        ALU_OP = 5'b00001; // Set ALU_OP to 1 (SLL)
        #10; // Wait for a few time units
        // Check the expected results
        if (RESULT === 20 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0) begin
            $display("Test case 2 (SLL): PASSED");
        end else begin
            $display("Test case 2 (SLL): FAILED");
        end

        // Test case 3: ALU_OP=2 (SLT)
        OP1 = 5;
        OP2 = 8;
        ALU_OP = 5'b00010; // Set ALU_OP to 2 (SLT)
        #10; // Wait for a few time units
        // Check the expected results
        if (RESULT === 1 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0) begin
            $display("Test case 3 (SLT): PASSED");
        end else begin
            $display("Test case 3 (SLT): FAILED");
        end

        // Test case 4: ALU_OP=3 (SLTU)
        OP1 = 4294967295; // Maximum unsigned 32-bit value
        OP2 = 2;
        ALU_OP = 5'b00011; // Set ALU_OP to 3 (SLTU)
        #10; // Wait for a few time units
        // Check the expected results
        if (RESULT === 1 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 1) begin
            $display("Test case 4 (SLTU): PASSED");
        end else begin
            $display("Test case 4 (SLTU): FAILED");
        end

        // Test case 5: ALU_OP=4 (XOR)
        OP1 = 16'hAAAA; // Binary: 1010101010101010
        OP2 = 16'h5555; // Binary: 0101010101010101
        ALU_OP = 5'b00100; // Set ALU_OP to 4 (XOR)
        #10; // Wait for a few time units
        // Check the expected results
        if (RESULT === 16'hFFFF && ZERO === 0 && SIGN_BIT === 1 && SLTU_BIT === 0) begin
            $display("Test case 5 (XOR): PASSED");
        end else begin
            $display("Test case 5 (XOR): FAILED");
        end

        // Test case 6: ALU_OP=5 (SRL)
        OP1 = 16; // Binary: 00010000
        OP2 = 2;
        ALU_OP = 5'b00101; // Set ALU_OP to 5 (SRL)
        #10; // Wait for a few time units
        // Check the expected results
        if (RESULT === 4 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0) begin
            $display("Test case 6 (SRL): PASSED");
        end else begin
            $display("Test case 6 (SRL): FAILED");
        end

        // Test case 7: ALU_OP=13 (SRA)
        OP1 = -8; // Binary: 11111111111111111111111111111000
        OP2 = 3;
        ALU_OP = 5'b01101; // Set ALU_OP to 13 (SRA)
        #10; // Wait for a few time units
        // Check the expected results
        if (RESULT === -1 && ZERO === 0 && SIGN_BIT === 1 && SLTU_BIT === 0) begin
            $display("Test case 7 (SRA): PASSED");
        end else begin
            $display("Test case 7 (SRA): FAILED");
        end

        // Test case 8: ALU_OP=6 (OR)
        OP1 = 16'hAAAA; // Binary: 1010101010101010
        OP2 = 16'h5555; // Binary: 0101010101010101
        ALU_OP = 5'b00110; // Set ALU_OP to 6 (OR)
        #10; // Wait for a few time units
        // Check the expected results
        if (RESULT === 16'hFFFF && ZERO === 0 && SIGN_BIT === 1 && SLTU_BIT === 0) begin
            $display("Test case 8 (OR): PASSED");
        end else begin
            $display("Test case 8 (OR): FAILED");
        end

        // Test case 9: ALU_OP=7 (AND)
        OP1 = 16'hAAAA; // Binary: 1010101010101010
        OP2 = 16'h5555; // Binary: 0101010101010101
        ALU_OP = 5'b00111; // Set ALU_OP to 7 (AND)
        #10; // Wait for a few time units
        // Check the expected results
        if (RESULT === 16'hAAAA && ZERO === 0 && SIGN_BIT === 1 && SLTU_BIT === 0) begin
            $display("Test case 9 (AND): PASSED");
        end else begin
            $display("Test case 9 (AND): FAILED");
        end

        // Test case 10: ALU_OP=16 (FORWARD)
        OP1 = 123;
        OP2 = 456;
        ALU_OP = 5'b10000; // Set ALU_OP to 16 (FORWARD)
        #10; // Wait for a few time units
        // Check the expected results
        if (RESULT === 456 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0) begin
            $display("Test case 10 (FORWARD): PASSED");
        end else begin
            $display("Test case 10 (FORWARD): FAILED");
        end

        // Add more test cases as needed

        // Terminate the simulation
        $finish;
    end

endmodule
