`timescale 1ns/100ps
`include "./reg_file.v"

module test_bench_reg_file;

    // Inputs
    reg [31:0] WRITE_DATA;
    reg [4:0] WRITE_ADDR, ADDR_1, ADDR_2;
    reg WRITE_EN, CLK, RESET;

    // Outputs
    wire [31:0] DATA_1, DATA_2;
    wire [31:0] REG0, REG1, REG2, REG3, REG4, REG5, REG6;

    // Instantiate the reg_file module
    reg_file uut (
        .WRITE_DATA(WRITE_DATA),
        .WRITE_ADDR(WRITE_ADDR),
        .ADDR_1(ADDR_1),
        .ADDR_2(ADDR_2),
        .WRITE_EN(WRITE_EN),
        .CLK(CLK),
        .RESET(RESET),
        .DATA_1(DATA_1),
        .DATA_2(DATA_2),
        .REG0(REG0),
        .REG1(REG1),
        .REG2(REG2),
        .REG3(REG3),
        .REG4(REG4),
        .REG5(REG5),
        .REG6(REG6)
    );

    // Initial block to apply inputs and test cases
    initial begin
        // Reset the reg_file
        RESET = 1;
        #5; // Wait for a few time units
        RESET = 0;
        #5; // Wait for a few time units

        // Test case 1: Write to register 0
        WRITE_ADDR = 5'b00000;
        WRITE_DATA = 32'hA5A5A5A5;
        WRITE_EN = 1;
        CLK = 0;
        #10; // Wait for a few time units
        // Check if the data was written to the register
        if (REG0 === 32'hA5A5A5A5) begin
            $display("Test case 1: PASSED (Write to register 0)");
        end else begin
            $display("Test case 1: FAILED (Write to register 0)");
        end

        // Test case 2: Read from registers 1 and 2
        WRITE_EN = 0;
        ADDR_1 = 5'b00000;
        ADDR_2 = 5'b00010;
        CLK = 1;
        #10; // Wait for a few time units
        // Check if the data matches what was written
        if (DATA_1 === 32'hA5A5A5A5 && DATA_2 === 32'd0) begin
            $display("Test case 2: PASSED (Read from registers 1 and 2)");
        end else begin
            $display("Test case 2: FAILED (Read from registers 1 and 2)");
        end

        // Test case 3: Write to registers 1 and 2
        WRITE_ADDR = 5'b00001;
        WRITE_DATA = 32'h12345678;
        WRITE_EN = 1;
        CLK = 0;
        #10; // Wait for a few time units
        // Check if the data was written to the registers
        if (REG1 === 32'h12345678) begin
            $display("Test case 3: PASSED (Write to registers 1 and 2)");
        end else begin
            $display("Test case 3: FAILED (Write to registers 1 and 2)");
        end

        // Test case 4: Read from registers 3 and 4
        WRITE_EN = 0;
        ADDR_1 = 5'b00011;
        ADDR_2 = 5'b00100;
        CLK = 1;
        #10; // Wait for a few time units
        // Check if the data matches what was written
        if (DATA_1 === 32'd0 && DATA_2 === 32'd0) begin
            $display("Test case 4: PASSED (Read from registers 3 and 4)");
        end else begin
            $display("Test case 4: FAILED (Read from registers 3 and 4)");
        end

        // Test case 5: Write and read from the same register (register 5)
        WRITE_ADDR = 5'b00101;
        WRITE_DATA = 32'hAAAA5555;
        ADDR_1 = 5'b00101;
        ADDR_2 = 5'b00101;
        WRITE_EN = 1;
        CLK = 0;
        #10; // Wait for a few time units
        // Check if the data was written to the register and read correctly
        if (REG5 === 32'hAAAA5555 && DATA_1 === 32'hAAAA5555 && DATA_2 === 32'hAAAA5555) begin
            $display("Test case 5: PASSED (Write and read from the same register)");
        end else begin
            $display("Test case 5: FAILED (Write and read from the same register)");
        end

        // Test case 6: Write with reset
        RESET = 1;
        WRITE_ADDR = 5'b00110;
        WRITE_DATA = 32'h12345678;
        ADDR_1 = 5'b00110;
        ADDR_2 = 5'b00111;
        WRITE_EN = 1;
        CLK = 0;
        #10; // Wait for a few time units
        RESET = 0;
        #10; // Wait for a few time units
        // Check if the data was not written due to reset
        if (REG6 === 32'd0 && DATA_1 === 32'd0 && DATA_2 === 32'd0) begin
            $display("Test case 6: PASSED (Write with reset)");
        end else begin
            $display("Test case 6: FAILED (Write with reset)");
        end


        // Terminate the simulation
        $finish;
    end

endmodule
