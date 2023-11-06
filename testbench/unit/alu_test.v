`include "../../code/alu_int/alu_int.v"

`timescale 1ns / 1ps

module alu_int_tb;

    // Constants
    localparam CLK_PERIOD = 10; // Define your clock period here

    // Inputs
    reg [31:0] OP1_test, OP2_test;
    reg [4:0] ALU_OP_test;

    // Outputs
    wire [31:0] RESULT_test;
    wire ZERO_test, SIGN_BIT_test, SLTU_BIT_test;

    // Instantiate ALU module
    alu_int uut (
        .OP1(OP1_test),
        .OP2(OP2_test),
        .ALU_OP(ALU_OP_test),
        .RESULT(RESULT_test),
        .ZERO(ZERO_test),
        .SIGN_BIT(SIGN_BIT_test),
        .SLTU_BIT(SLTU_BIT_test)
    );

    // Clock generation
    reg clk = 0;
    always #((CLK_PERIOD) / 2) clk <= ~clk;

    // Testbench initialization
    initial begin
        // Loop through all ALU operations
        for (ALU_OP_test = 0; ALU_OP_test < 17; ALU_OP_test = ALU_OP_test + 1) begin
            // Loop through different inputs
            for (OP1_test = 0; OP1_test < 10; OP1_test = OP1_test + 1) begin
                for (OP2_test = 0; OP2_test < 10; OP2_test = OP2_test + 1) begin
                    #50; // Wait for a few clock cycles

                    // Display outputs for each operation and input combination
                    $display("ALU Operation: %d, OP1: %h, OP2: %h", ALU_OP_test, OP1_test, OP2_test);
                    $display("Result: %h", RESULT_test);
                    $display("ZERO Flag: %b", ZERO_test);
                    $display("SIGN Bit: %b", SIGN_BIT_test);
                    $display("SLTU Bit: %b", SLTU_BIT_test);
                end
            end
        end

        // End simulation
        $finish;
    end

endmodule

