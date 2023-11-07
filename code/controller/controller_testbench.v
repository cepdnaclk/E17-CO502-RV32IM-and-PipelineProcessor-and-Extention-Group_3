`timescale 1ns/100ps
`include "./controller.v"

module test_bench_controller;

    // Inputs
    reg [6:0] OPCODE;
    reg [2:0] FUNC3;
    reg [6:0] FUNC7;

    // Outputs
    wire [4:0] ALU_OP;
    wire [2:0] IMM_SEL;
    wire [1:0] BJ_CTRL;
    wire [1:0] WB_VALUE_SEL;
    wire REG_WRITE_EN, MEM_READ_EN, MEM_WRITE_EN, COMP_SEL, OP2_SEL, OP1_SEL;

    // Instantiate the controller module
    controller uut (
        .OPCODE(OPCODE),
        .FUNC3(FUNC3),
        .FUNC7(FUNC7),
        .ALU_OP(ALU_OP),
        .IMM_SEL(IMM_SEL),
        .BJ_CTRL(BJ_CTRL),
        .WB_VALUE_SEL(WB_VALUE_SEL),
        .REG_WRITE_EN(REG_WRITE_EN),
        .MEM_READ_EN(MEM_READ_EN),
        .MEM_WRITE_EN(MEM_WRITE_EN),
        .COMP_SEL(COMP_SEL),
        .OP2_SEL(OP2_SEL),
        .OP1_SEL(OP1_SEL)
    );

    // Initial block to apply inputs and test cases
    initial begin
        // Test case 1: LUI
        OPCODE = 7'b0110111;
        FUNC3 = 3'b000;
        FUNC7 = 7'b0000000;
        #10;
        if (ALU_OP === 5'b10000 &&
            IMM_SEL === 3'b011 &&
            BJ_CTRL === 2'b00 &&
            REG_WRITE_EN === 1'b1 &&
            MEM_READ_EN === 1'b0 &&
            MEM_WRITE_EN === 1'b0 &&
            COMP_SEL === 1'b0 &&
            WB_VALUE_SEL === 2'd0 &&
            OP2_SEL === 1'b1 &&
            OP1_SEL === 1'b0) begin
            $display("Test case 1 (LUI): PASSED");
        end else begin
            $display("Test case 1 (LUI): FAILED");
        end

        // Test case 2: AUIPC
        OPCODE = 7'b0010111;
        FUNC3 = 3'b000;
        FUNC7 = 7'b0000000;
        #10;
        if (ALU_OP === 5'd0 &&
            IMM_SEL === 3'b011 &&
            BJ_CTRL === 2'b00 &&
            REG_WRITE_EN === 1'b1 &&
            MEM_READ_EN === 1'b0 &&
            MEM_WRITE_EN === 1'b0 &&
            COMP_SEL === 1'b0 &&
            WB_VALUE_SEL === 2'd0 &&
            OP2_SEL === 1'b1 &&
            OP1_SEL === 1'b1) begin
            $display("Test case 2 (AUIPC): PASSED");
        end else begin
            $display("Test case 2 (AUIPC): FAILED");
        end

        // Test case 3: JAL
        OPCODE = 7'b1101111;
        FUNC3 = 3'b000;
        FUNC7 = 7'b0000000;
        #10;
        if (ALU_OP === 5'd0 &&
            IMM_SEL === 3'd1 &&
            BJ_CTRL === 2'b01 &&
            REG_WRITE_EN === 1'b1 &&
            MEM_READ_EN === 1'b0 &&
            MEM_WRITE_EN === 1'b0 &&
            COMP_SEL === 1'b0 &&
            WB_VALUE_SEL === 2'd2 &&
            OP2_SEL === 1'b1 &&
            OP1_SEL === 1'b1) begin
            $display("Test case 3 (JAL): PASSED");
        end else begin
            $display("Test case 3 (JAL): FAILED");
        end

        // Test case 4: JALR
        OPCODE = 7'b1100111;
        FUNC3 = 3'b000;
        FUNC7 = 7'b0000000;
        #10;
        if (ALU_OP === 5'd0 &&
            IMM_SEL === 3'd4 &&
            BJ_CTRL === 2'b01 &&
            REG_WRITE_EN === 1'b1 &&
            MEM_READ_EN === 1'b0 &&
            MEM_WRITE_EN === 1'b0 &&
            COMP_SEL === 1'b0 &&
            WB_VALUE_SEL === 2'd0 &&
            OP2_SEL === 1'b1 &&
            OP1_SEL === 1'b0) begin
            $display("Test case 4 (JALR): PASSED");
        end else begin
            $display("Test case 4 (JALR): FAILED");
        end

        // Test case 5: BEQ
        OPCODE = 7'b1100011;
        FUNC3 = 3'b000;
        FUNC7 = 7'b0000000;
        #10;
        if (ALU_OP === 5'd0 &&
            IMM_SEL === 3'd0 &&
            BJ_CTRL === 2'b10 &&
            REG_WRITE_EN === 1'b0 &&
            MEM_READ_EN === 1'b0 &&
            MEM_WRITE_EN === 1'b0 &&
            COMP_SEL === 1'b1 &&
            WB_VALUE_SEL === 2'd0 &&
            OP2_SEL === 1'b0 &&
            OP1_SEL === 1'b0) begin
            $display("Test case 5 (BEQ): PASSED");
        end else begin
            $display("Test case 5 (BEQ): FAILED");
        end

        // Test case 6: LB
        OPCODE = 7'b0000011;
        FUNC3 = 3'b000;
        FUNC7 = 7'b0000000;
        #10;
        if (ALU_OP === 5'd0 &&
            IMM_SEL === 3'd4 &&
            BJ_CTRL === 2'b00 &&
            REG_WRITE_EN === 1'b1 &&
            MEM_READ_EN === 1'b1 &&
            MEM_WRITE_EN === 1'b0 &&
            COMP_SEL === 1'b0 &&
            WB_VALUE_SEL === 2'd1 &&
            OP2_SEL === 1'b1 &&
            OP1_SEL === 1'b0) begin
            $display("Test case 6 (LB): PASSED");
        end else begin
            $display("Test case 6 (LB): FAILED");
        end

        // Test case 7: SB
        OPCODE = 7'b0100011;
        FUNC3 = 3'b000;
        FUNC7 = 7'b0000000;
        #10;
        if (ALU_OP === 5'd0 &&
            IMM_SEL === 3'd2 &&
            BJ_CTRL === 2'b00 &&
            REG_WRITE_EN === 1'b1 &&
            MEM_READ_EN === 1'b0 &&
            MEM_WRITE_EN === 1'b1 &&
            COMP_SEL === 1'b0 &&
            WB_VALUE_SEL === 2'd0 &&
            OP2_SEL === 1'b1 &&
            OP1_SEL === 1'b0) begin
            $display("Test case 7 (SB): PASSED");
        end else begin
            $display("Test case 7 (SB): FAILED");
        end

        // Test case 8: ADDI
        OPCODE = 7'b0010011;
        FUNC3 = 3'b000;
        FUNC7 = 7'b0000000;
        #10;
        if (ALU_OP === 5'b00000 &&
            IMM_SEL === 3'd4 &&
            BJ_CTRL === 2'b00 &&
            REG_WRITE_EN === 1'b1 &&
            MEM_READ_EN === 1'b0 &&
            MEM_WRITE_EN === 1'b0 &&
            COMP_SEL === 1'b0 &&
            WB_VALUE_SEL === 2'd0 &&
            OP2_SEL === 1'b1 &&
            OP1_SEL === 1'b0) begin
            $display("Test case 8 (ADDI): PASSED");
        end else begin
            $display("Test case 8 (ADDI): FAILED");
        end

        // Test case 9: SUB
        OPCODE = 7'b0110011;
        FUNC3 = 3'b000;
        FUNC7 = 7'b0100000;
        #10;
        if (ALU_OP === 5'b10000 &&
            IMM_SEL === 3'd0 &&
            BJ_CTRL === 2'b00 &&
            REG_WRITE_EN === 1'b1 &&
            MEM_READ_EN === 1'b0 &&
            MEM_WRITE_EN === 1'b0 &&
            COMP_SEL === 1'b0 &&
            WB_VALUE_SEL === 2'd0 &&
            OP2_SEL === 1'b0 &&
            OP1_SEL === 1'b0) begin
            $display("Test case 9 (SUB): PASSED");
        end else begin
            $display("Test case 9 (SUB): FAILED");
        end

        // Add more test cases as needed

        
        // Terminate the simulation
        $finish;
    end

endmodule
