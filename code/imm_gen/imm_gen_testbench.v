`timescale 1ns/100ps
`include "./imm_gen.v"

module test_bench_imm_gen;

    // Inputs
    reg [31:0] INSTRUCTION;
    reg [2:0] IMM_SEL;

    // Outputs
    wire [31:0] IMM;

    // Instantiate the imm_gen module
    imm_gen uut (
        .INSTRUCTION(INSTRUCTION),
        .IMM_SEL(IMM_SEL),
        .IMM(IMM)
    );

    // Initial block to apply inputs and test cases
    initial begin
        // Test case 1: B type
        INSTRUCTION = 32'b00000000001100110100100010010011; // Example B type instruction
        IMM_SEL = 3'b000; // B_IMM
        #10; // Wait for a few time units
        // Check the expected results
        if (IMM === 32'b00000000000000000000100000010000) begin
            $display("Test case 1 (B type): PASSED");
        end else begin
            $display("Test case 1 (B type): FAILED");
        end

        // Test case 2: J type
        INSTRUCTION = 32'b10000010000000011001100100000011; // Example J type instruction
        IMM_SEL = 3'b001; // J_IMM
        #10; // Wait for a few time units
        // Check the expected results
        if (IMM === 32'b11111111111100011001000000100000) begin
            $display("Test case 2 (J type): PASSED");
        end else begin
            $display("Test case 2 (J type): FAILED");
        end

        // Test case 3: S type
        INSTRUCTION = 32'b00001001110111010000100100100011; // Example S type instruction
        IMM_SEL = 3'b010; // S_IMM
        #10; // Wait for a few time units
        // Check the expected results
        if (IMM === 32'b0000000000000000000000010010010) begin
            $display("Test case 3 (S type): PASSED");
        end else begin
            $display("Test case 3 (S type): FAILED");
        end

        // Test case 4: U type
        INSTRUCTION = 32'b11111111111100000000000000010011; // Example U type instruction
        IMM_SEL = 3'b011; // U_IMM
        #10; // Wait for a few time units
        // Check the expected results
        if (IMM === 32'b11111111111100000000000000000000) begin
            $display("Test case 4 (U type): PASSED");
        end else begin
            $display("Test case 4 (U type): FAILED");
        end

        // Test case 5: I type (Default)
        INSTRUCTION = 32'b00000000000100111010110010010011; // Example I type instruction
        IMM_SEL = 3'b111; // Default (I_IMM)
        #10; // Wait for a few time units
        // Check the expected results
        if (IMM === 32'b00000000000000000000000000000001) begin
            $display("Test case 5 (I type - Default): PASSED");
        end else begin
            $display("Test case 5 (I type - Default): FAILED");
        end

        // Add more test cases as needed

        // Terminate the simulation
        $finish;
    end

endmodule
