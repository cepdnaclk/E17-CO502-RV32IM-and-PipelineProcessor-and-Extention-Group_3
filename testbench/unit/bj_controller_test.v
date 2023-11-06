`include "../../code/bj_controller/bj_controller.v"
module bj_controller_tb;

    // Inputs
    reg [31:0] PC, IMM;
    reg [1:0] BJ_CTRL;
    reg [2:0] FUNC3;
    reg ZERO, SIGN_BIT, SLTU_BIT;

    // Outputs
    wire [31:0] B_PC;
    wire BRANCH_SEL;

    // Instantiate the bj_controller module
    bj_controller bj_inst (
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

    // Initial stimulus
    initial begin
        // Test 1: BEQ (Branch if Equal)
        PC = 10;
        IMM = 0;
        BJ_CTRL = 2'b00; // BEQ control
        FUNC3 = 3'b000; // BEQ condition
        ZERO = 1;
        SIGN_BIT = 0;
        SLTU_BIT = 0;

        #10; // Simulate for some time
        $display("Test 1 - BEQ: B_PC = %d, BRANCH_SEL = %b", B_PC, BRANCH_SEL);

        // Test 2: BNE (Branch if Not Equal)
        IMM = -5; // Different immediate value for inequality
        BJ_CTRL = 2'b00; // BNE control
        FUNC3 = 3'b001; // BNE condition
        ZERO = 0;

        #10;
        $display("Test 2 - BNE: B_PC = %d, BRANCH_SEL = %b", B_PC, BRANCH_SEL);

        // Test 3: BGE (Branch if Greater or Equal)
        IMM = 5; // Positive immediate value
        BJ_CTRL = 2'b00; // BGE control
        FUNC3 = 3'b011; // BGE condition
        SIGN_BIT = 0;

        #10;
        $display("Test 3 - BGE: B_PC = %d, BRANCH_SEL = %b", B_PC, BRANCH_SEL);

        // Test 4: BLT (Branch if Less Than)
        PC = -10; // Negative PC value
        IMM = -5; // Negative immediate value
        BJ_CTRL = 2'b00; // BLT control
        FUNC3 = 3'b100; // BLT condition
        SIGN_BIT = 1;

        #10;
        $display("Test 4 - BLT: B_PC = %d, BRANCH_SEL = %b", B_PC, BRANCH_SEL);

        // Test 5: BLTU (Branch if Less Than Unsigned)
        PC = 0;
        IMM = 5; // Positive immediate value
        BJ_CTRL = 2'b00; // BLTU control
        FUNC3 = 3'b101; // BLTU condition
        ZERO = 0;
        SLTU_BIT = 1;

        #10;
        $display("Test 5 - BLTU: B_PC = %d, BRANCH_SEL = %b", B_PC, BRANCH_SEL);

        // Test 6: BGEU (Branch if Greater or Equal Unsigned)
        IMM = 0; // Zero immediate value
        BJ_CTRL = 2'b00; // BGEU control
        FUNC3 = 3'b111; // BGEU condition
        SLTU_BIT = 0;

        #10;
        $display("Test 6 - BGEU: B_PC = %d, BRANCH_SEL = %b", B_PC, BRANCH_SEL);

        $finish; // End simulation
    end
endmodule
