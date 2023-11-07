`timescale 1ns/100ps

module bj_controller(
    // inputs
    PC,
    IMM,
    BJ_CTRL,
    FUNC3,
    ZERO,
    SIGN_BIT,
    SLTU_BIT,
    // outputs
    B_PC,
    BRANCH_SEL
);

    input [31:0] PC, IMM;
    input [1:0] BJ_CTRL;
    input [2:0] FUNC3;
    input ZERO, SIGN_BIT, SLTU_BIT;

    output reg [31:0] B_PC;
    output reg BRANCH_SEL;

    wire BEQ, BGE, BNE, BLT, BLTU, BGEU;

    // assign BRANCH_ADDRESS = PC + IMM; // Get the branch address using pc and immediate value

    // Branch if equal
    assign BEQ = (~FUNC3[2]) & (~FUNC3[1]) &  (~FUNC3[0]) & ZERO;
    // Branch if not equal
    assign BNE = (~FUNC3[2]) & (~FUNC3[1]) &  (FUNC3[0]) & (~ZERO);
    // Branch if greater than
    assign BGE = (FUNC3[2]) & (~FUNC3[1]) &  (FUNC3[0]) & (~SIGN_BIT);
    // Branch if less than
    assign BLT = (FUNC3[2]) & (~FUNC3[1]) &  (~FUNC3[0]) & (~ZERO) & SIGN_BIT;
    // Branch less than for unsign
    assign BLTU = (FUNC3[2]) & (FUNC3[1]) &  (~FUNC3[0]) & (~ZERO) & SLTU_BIT;
    // Branch greater than for unsign
    assign BGEU = (FUNC3[2]) & (FUNC3[1]) &  (FUNC3[0]) & (~SLTU_BIT);

    always @(*)begin
        BRANCH_SEL <= #1 (BJ_CTRL[0] &(BEQ|BNE|BGE|BLT|BLTU|BGEU)) | (BJ_CTRL[1]) | 1'b0;
    end

    always @(*) begin
        B_PC <= PC+IMM;
    end

endmodule