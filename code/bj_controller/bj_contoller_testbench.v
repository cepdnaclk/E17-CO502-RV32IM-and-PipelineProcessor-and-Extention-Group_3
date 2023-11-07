`timescale 1ns/100ps
`include "./bj_controller.v"

module test_bench_bj_controller;

    // Inputs
    reg [31:0] PC, IMM;
    reg [1:0] BJ_CTRL;
    reg [2:0] FUNC3;
    reg ZERO, SIGN_BIT, SLTU_BIT;

    // Outputs
    wire [31:0] B_PC;
    wire BRANCH_SEL;

    // Instantiate the bj_controller module
    bj_controller uut (
        .PC(PC),
        .IMM(IMM),
        .BJ_CTRL(BJ_CTRL),
        .FUNC3(FUNC3),
        .ZERO(ZERO),
        .SIGN_BIT(SIGN_BIT),
        .SLTU_BIT(SLTU_BIT),
        .B_PC(B_PC),
        .BRANCH_SEL(BRANCH_SEL)
    );

    // Initial block to apply inputs and test cases
    initial begin
        // Test case 1: BEQ
        PC = 32'h00000000;
        IMM = 32'h00000004;
        BJ_CTRL = 2'b00;
        FUNC3 = 3'b000;
        ZERO = 1'b1;
        SIGN_BIT = 1'b0;
        SLTU_BIT = 1'b0;
        #10; // Wait for a few time units
        // Check the expected results
        if (B_PC === 32'h00000004 && BRANCH_SEL === 1'b0) begin
            $display("Test case 1 (BEQ): PASSED");
        end else begin
            $display("Test case 1 (BEQ): FAILED");
        end

        // Test case 2: BNE
        PC = 32'h00000000;
        IMM = 32'h00000008;
        BJ_CTRL = 2'b00;
        FUNC3 = 3'b001;
        ZERO = 1'b0;
        SIGN_BIT = 1'b0;
        SLTU_BIT = 1'b0;
        #10; // Wait for a few time units
        // Check the expected results
        if (B_PC === 32'h00000008 && BRANCH_SEL === 1'b0) begin
            $display("Test case 2 (BNE): PASSED");
        end else begin
            $display("Test case 2 (BNE): FAILED");
        end

        // Test case 3: BGE
        PC = 32'h00000000;
        IMM = 32'h0000000C;
        BJ_CTRL = 2'b00;
        FUNC3 = 3'b100;
        ZERO = 1'b0;
        SIGN_BIT = 1'b0;
        SLTU_BIT = 1'b0;
        #10; // Wait for a few time units
        // Check the expected results
        if (B_PC === 32'h0000000C && BRANCH_SEL === 1'b0) begin
            $display("Test case 3 (BGE): PASSED");
        end else begin
            $display("Test case 3 (BGE): FAILED");
        end

        // Test case for BLT
        PC = 32'h00000000;
        IMM = 32'h00000008; // Positive offset
        BJ_CTRL = 2'b00;
        FUNC3 = 3'b100;
        ZERO = 1'b0;
        SIGN_BIT = 1'b0;
        SLTU_BIT = 1'b0;
        #10; // Wait for a few time units
        // Check the expected results
        if (B_PC === 32'h00000008 && BRANCH_SEL === 1'b0) begin
            $display("Test case for BLT (Positive Offset): PASSED");
        end else begin
            $display("Test case for BLT (Positive Offset): FAILED");
        end

        // Test case for BLTU
        PC = 32'h00000000;
        IMM = 32'h0000000C; // Positive offset
        BJ_CTRL = 2'b00;
        FUNC3 = 3'b110;
        ZERO = 1'b0;
        SIGN_BIT = 1'b0;
        SLTU_BIT = 1'b0;
        #10; // Wait for a few time units
        // Check the expected results
        if (B_PC === 32'h0000000C && BRANCH_SEL === 1'b0) begin
            $display("Test case for BLTU (Positive Offset): PASSED");
        end else begin
            $display("Test case for BLTU (Positive Offset): FAILED");
        end


        // Test case 6: BGEU
        PC = 32'h00000000;
        IMM = 32'h00000010;
        BJ_CTRL = 2'b00;
        FUNC3 = 3'b110;
        ZERO = 1'b1;
        SIGN_BIT = 1'b0;
        SLTU_BIT = 1'b1;
        #10; // Wait for a few time units
        // Check the expected results
        if (B_PC === 32'h00000010 && BRANCH_SEL === 1'b0) begin
            $display("Test case 6 (BGEU): PASSED");
        end else begin
            $display("Test case 6 (BGEU): FAILED");
        end

        // Terminate the simulation
        $finish;
    end

endmodule
