`include "alu_int.v"
`timescale 1ns/1ps

module alu_int_tb;
    reg [31:0] OP1, OP2;
    reg [4:0] ALU_OP;
    wire [31:0] RESULT;
    wire ZERO, SIGN_BIT, SLTU_BIT;

    // Instantiate the ALU module
    alu_int alu_inst (
        .OP1(OP1),
        .OP2(OP2),
        .ALU_OP(ALU_OP),
        .RESULT(RESULT),
        .ZERO(ZERO),
        .SIGN_BIT(SIGN_BIT),
        .SLTU_BIT(SLTU_BIT)
    );

    // Test cases
    initial begin
        // Test 1: ADD
        OP1 = 10;
        OP2 = 20;
        ALU_OP = 5'b00000; // ADD
        #10;
        if (RESULT === 30)
            $display("Test 1 (ADD) PASSED");
        else
            $display("Test 1 (ADD) FAILED");

        // Test 2: SLL
        OP1 = 5;
        OP2 = 2;
        ALU_OP = 5'b00001; // SLL
        #10;
        if (RESULT === 20 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
            $display("Test 2 (SLL) PASSED");
        else
            $display("Test 2 (SLL) FAILED");

        // Test 3: SLT
        OP1 = -5;
        OP2 = 10;
        ALU_OP = 5'b00010; // SLT
        #10;
        if (RESULT === 1 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
            $display("Test 3 (SLT) PASSED");
        else
            $display("Test 3 (SLT) FAILED");

        // Test 4: SLTU
        OP1 = 5;
        OP2 = 10;
        ALU_OP = 5'b00011; // SLTU
        #10;
        if (RESULT === 1 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 1)
            $display("Test 4 (SLTU) PASSED");
        else
            $display("Test 4 (SLTU) FAILED");

        // Test 5: XOR
        OP1 = 2'b01; // Decimal equivalent of 0xAAAA
        OP2 = 2'b10; // Decimal equivalent of 0x5555
        ALU_OP = 5'b00100; // XOR
        #10;
        if (RESULT === 2'b11)
            $display("Test 5 (XOR) PASSED");
        else
            $display("Test 5 (XOR) FAILED");

        // Test 6: SRL
        OP1 = 2147483648; // Decimal equivalent of 0x80000000
        OP2 = 1;
        ALU_OP = 5'b00101; // SRL
        #10;
        if (RESULT === 1073741824 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
            $display("Test 6 (SRL) PASSED");
        else
            $display("Test 6 (SRL) FAILED");

        // Test 7: SRA
        OP1 = 2147483648; // Decimal equivalent of 0x80000000
        OP2 = 1;
        ALU_OP = 5'b01101; // SRA
        #10;
        if (RESULT === 3221225472 && ZERO === 0 && SIGN_BIT === 1 && SLTU_BIT === 0)
            $display("Test 7 (SRA) PASSED");
        else
            $display("Test 7 (SRA) FAILED");

        // Test 8: OR
        OP1 = 2'b01; // Decimal equivalent of 0xAAAA
        OP2 = 2'b10; // Decimal equivalent of 0x5555
        ALU_OP = 5'b00110; // OR
        #10;
        if (RESULT === 2'b11)
            $display("Test 8 (OR) PASSED");
        else
            $display("Test 8 (OR) FAILED");

        // Test 9: AND
        OP1 = 2'b11; // Decimal equivalent of 0xAAAA
        OP2 = 2'b10; // Decimal equivalent of 0x5555
        ALU_OP = 5'b00111; // AND
        #10;
        if (RESULT === 2'b10 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
            $display("Test 9 (AND) PASSED");
        else
            $display("Test 9 (AND) FAILED");

        // // Test 11: DIV
        // OP1 = 100;
        // OP2 = 20;
        // ALU_OP = 5'b10000; // DIV
        // #10;
        // if (RESULT === 5 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
        //     $display("Test 11 (DIV) PASSED");
        // else
        //     $display("Test 11 (DIV) FAILED");

        // // Test 12: REM
        // OP1 = 100;
        // OP2 = 20;
        // ALU_OP = 5'b10100; // REM
        // #10;
        // if (RESULT === 0 && ZERO === 1 && SIGN_BIT === 0 && SLTU_BIT === 0)
        //     $display("Test 12 (REM) PASSED");
        // else
        //     $display("Test 12 (REM) FAILED");

        // // Test 13: MUL
        // OP1 = 10;
        // OP2 = 20;
        // ALU_OP = 5'b10001; // MUL
        // #10;
        // if (RESULT === 200 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
        //     $display("Test 13 (MUL) PASSED");
        // else
        //     $display("Test 13 (MUL) FAILED");

        // // Test 14: MULH
        // OP1 = 100;
        // OP2 = 20;
        // ALU_OP = 5'b10010; // MULH
        // #10;
        // if (RESULT === 2 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
        //     $display("Test 14 (MULH) PASSED");
        // else
        //     $display("Test 14 (MULH) FAILED");

        // // Test 15: MULHSU
        // OP1 = -100;
        // OP2 = 20;
        // ALU_OP = 5'b10011; // MULHSU
        // #10;
        // if (RESULT === 2 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
        //     $display("Test 15 (MULHSU) PASSED");
        // else
        //     $display("Test 15 (MULHSU) FAILED");

        // // Test 16: MULHU
        // OP1 = 100;
        // OP2 = 20;
        // ALU_OP = 5'b10100; // MULHU
        // #10;
        // if (RESULT === 2 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
        //     $display("Test 16 (MULHU) PASSED");
        // else
        //     $display("Test 16 (MULHU) FAILED");

        // // Test 17: DIVU
        // OP1 = 100;
        // OP2 = 20;
        // ALU_OP = 5'b10101; // DIVU
        // #10;
        // if (RESULT === 5 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
        //     $display("Test 17 (DIVU) PASSED");
        // else
        //     $display("Test 17 (DIVU) FAILED");

        // // Test 18: REMU
        // OP1 = 100;
        // OP2 = 20;
        // ALU_OP = 5'b10110; // REMU
        // #10;
        // if (RESULT === 0 && ZERO === 1 && SIGN_BIT === 0 && SLTU_BIT === 0)
        //     $display("Test 18 (REMU) PASSED");
        // else
        //     $display("Test 18 (REMU) FAILED");

        // // Test 19: FWD
        // OP1 = 42;
        // OP2 = 0;
        // ALU_OP = 5'b10000; // ADD
        // #10;
        // if (RESULT === 42 && ZERO === 0 && SIGN_BIT === 0 && SLTU_BIT === 0)
        //     $display("Test 19 (FWD) PASSED");
        // else
        //     $display("Test 19 (FWD) FAILED");

        // // Test 20: Negative FWD
        // OP1 = -42;
        // OP2 = 0;
        // ALU_OP = 5'b10000; // ADD
        // #10;
        // if (RESULT === -42 && ZERO === 0 && SIGN_BIT === 1 && SLTU_BIT === 0)
        //     $display("Test 20 (Negative FWD) PASSED");
        // else
        //     $display("Test 20 (Negative FWD) FAILED");

        // Finish simulation
        $finish;
    end
endmodule
