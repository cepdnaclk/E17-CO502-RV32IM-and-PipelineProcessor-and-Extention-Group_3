`include "../../code/alu_int/alu_int.v"
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

    // Test cases for all ALU operations
    initial begin
        for (integer i = 0; i < 32; i = i + 1) begin
            for (integer j = 0; j < 32; j = j + 1) begin
                // Assign values for OP1 and OP2 for comprehensive testing
                OP1 = i;
                OP2 = j;

                // Test each operation
                for (ALU_OP = 0; ALU_OP < 18; ALU_OP = ALU_OP + 1) begin
                    #10;

                    case (ALU_OP)
                        5'b00000: begin // ADD
                            if (RESULT !== (OP1 + OP2))
                                $display("Test ADD failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        5'b00001: begin // SLL
                            if (RESULT !== (OP1 << OP2))
                                $display("Test SLL failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        5'b00010: begin // SLT
                            if (RESULT !== (($signed(OP1) < $signed(OP2)) ? 32'd1 : 32'd0))
                                $display("Test SLT failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        5'b00011: begin // SLTU
                            if (RESULT !== (($unsigned(OP1) < $unsigned(OP2)) ? 32'd1 : 32'd0))
                                $display("Test SLTU failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        5'b00100: begin // XOR
                            if (RESULT !== (OP1 ^ OP2))
                                $display("Test XOR failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        5'b00101: begin // SRL
                            if (RESULT !== (OP1 >> OP2))
                                $display("Test SRL failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        5'b01101: begin // SRA
                            if (RESULT !== (OP1 >>> OP2))
                                $display("Test SRA failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        5'b00110: begin // OR
                            if (RESULT !== (OP1 | OP2))
                                $display("Test OR failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        5'b00111: begin // AND
                            if (RESULT !== (OP1 & OP2))
                                $display("Test AND failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        5'b10000: begin // FWD
                            if (RESULT !== OP1)
                                $display("Test FWD failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        5'b10001: begin // Negative FWD
                            if (RESULT !== -OP1)
                                $display("Test Negative FWD failed for OP1 = %d, OP2 = %d", OP1, OP2);
                        end
                        default: $display("Invalid ALU_OP");
                    endcase
                end
            end
        end

        $display("All test cases executed.");
        $finish;
    end
endmodule
