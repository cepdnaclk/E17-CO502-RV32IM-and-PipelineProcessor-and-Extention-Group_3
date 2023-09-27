module imm_gen(
    // inputs
    INSTRUCTION,
    IMM_SEL,
    // IMMputs
    IMM
);

input [31:0] INSTRUCTION;
input [2:0] IMM_SEL;

reg [31:0] B_IMM, J_IMM, S_IMM, U_IMM, I_IMM;

// sign extention imidiate value for B type 
// | imm[12]   | imm[10:5]         | rs2 (5)         | rs1 (5)   | funct3 (3) | imm[4:1]   | imm[11] | opcode (7) |
assign B_IMM={{20{INSTRUCTION[31]}},INSTRUCTION[7],INSTRUCTION[30:25],INSTRUCTION[11:8],1'b0};

// sign extention imidiate value for J type 
// | imm[20] (1)      | imm[10:1] (10)   | imm[11] (1)   | imm[19:12] (8) | rd (5) | opcode (7) |
assign J_IMM={{12{INSTRUCTION[31]}},INSTRUCTION[19:12],INSTRUCTION[20],INSTRUCTION[30:21],1'b0};

// sign extention imidiate value for S type 
// | imm[11:5] (7)   |   rs2 (5)         |   rs1 (5)   | funct3 (3) | imm[4:0] (5) | opcode (7) |
assign S_IMM={{21{INSTRUCTION[31]}},INSTRUCTION[30:25],INSTRUCTION[11:7]};

// sign extention imidiate value for U type 
// | imm[31:12] (20)   | rd (5) | opcode (7) |
assign U_IMM={INSTRUCTION[31:12],{12{1'b0}}};

// sign extention imidiate value for I type
//  | imm[11:0] (12) | rs1 (5) | funct3 (3) | rd (5)   | opcode (7) |
assign I_IMM={{21{INSTRUCTION[31]}},INSTRUCTION[30:20]};

always @(*) begin
    case (select)
        3'b000: begin
            IMM <= B_IMM;
        end
        3'b001: begin
            IMM <= J_IMM;
        end
        3'b010: begin
            IMM <= S_IMM;
        end
        3'b011: begin
            IMM <= U_IMM;
        end
        default: begin
            IMM <= I_IMM;
        end
    endcase
end

endmodule