`timescale 1ns/100ps
`include "./complementer.v"

module test_bench_complementer;

    // Inputs
    reg [31:0] IN;
    reg COMP_SEL_IDEX;

    // Outputs
    wire [31:0] OUT;

    // Instantiate the complementer module
    complementer uut (
        .IN(IN),
        .COMP_SEL_IDEX(COMP_SEL_IDEX),
        .OUT(OUT)
    );

    // Initial block to apply inputs and test cases
    initial begin
        // Test case 1: COMP_SEL_IDEX=0 (IN)
        IN = 32'h0000000A;
        COMP_SEL_IDEX = 1'b0;
        #10; // Wait for a few time units
        // Check the expected results
        if (OUT === 32'h0000000A) begin
            $display("Test case 1 (COMP_SEL_IDEX=0): PASSED");
        end else begin
            $display("Test case 1 (COMP_SEL_IDEX=0): FAILED");
        end

        // Test case 2: COMP_SEL_IDEX=1 (NOT IN + 1)
        IN = 32'hFFFFFFFF; // Maximum 32-bit value
        COMP_SEL_IDEX = 1'b1;
        #10; // Wait for a few time units
        // Check the expected results
        if (OUT === 32'h00000001) begin
            $display("Test case 2 (COMP_SEL_IDEX=1): PASSED");
        end else begin
            $display("Test case 2 (COMP_SEL_IDEX=1): FAILED");
        end


        // Terminate the simulation
        $finish;
    end

endmodule
