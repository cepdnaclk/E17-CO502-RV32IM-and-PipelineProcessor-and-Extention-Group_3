`timescale 1ns/100ps

module controller(
    // inputs
    OPCODE,
    FUNC3,
    FUNC7,
    // outputs
    REG_WRITE_EN, //  wrten_reg
    WB_VALUE_SEL, // ALU_RESULT, MEM, PC + 4
    MEM_READ_EN, // d_mem_r
    MEM_WRITE_EN, // d_mem_w
    BJ_CTRL,
    ALU_OP, // alu_op
    COMP_SEL,
    OP2_SEL, // mux2
    OP1_SEL, // mux1
    IMM_SEL // mux_wire_module
);

    input [6:0] OPCODE;
    input [2:0] FUNC3;
    input [6:0] FUNC7;

    output reg [4:0] ALU_OP;
    output reg [2:0] IMM_SEL;
    output reg [1:0] BJ_CTRL;
    output reg [1:0] WB_VALUE_SEL;
    output reg REG_WRITE_EN, MEM_READ_EN, MEM_WRITE_EN, COMP_SEL, OP2_SEL, OP1_SEL;

    // test this

    wire [4:0] ALU_SELECT;

    assign ALU_SELECT = {1'b0,FUNC7[5],FUNC3};

    always @ (*)
    begin
        #1
        case(OPCODE)
        7'b0110111: begin // LUI
            MEM_READ_EN <= 1'd0;
            MEM_WRITE_EN <= 1'd0;
            BJ_CTRL <= 2'b00;
            REG_WRITE_EN <= 1'd1;
            COMP_SEL <= 1'd0;
            WB_VALUE_SEL <= 2'd0;
            OP2_SEL <= 1'd1;
            OP1_SEL <= 1'd0;
            IMM_SEL <= 3'b011;
            ALU_OP <= 5'b10000;
        end
        7'b0010111: begin // AUIPC
            MEM_READ_EN <= 1'd0;
            MEM_WRITE_EN <= 1'd0;
            BJ_CTRL <= 2'b00;
            REG_WRITE_EN <= 1'd1;
            COMP_SEL <= 1'd0;
            WB_VALUE_SEL <= 2'd0;
            OP2_SEL <= 1'd1;
            OP1_SEL <= 1'd1;
            IMM_SEL <= 3'b011;
            ALU_OP <= 5'd0;
        end
        7'b1101111: begin // JAL
            MEM_READ_EN <= 1'd0;
            MEM_WRITE_EN <= 1'd0;
            BJ_CTRL <= 2'b01;
            REG_WRITE_EN <= 1'd1;
            COMP_SEL <= 1'd0;
            WB_VALUE_SEL <= 2'd2;
            OP2_SEL <= 1'd1;
            OP1_SEL <= 1'd1;
            IMM_SEL <= 3'd1;
            ALU_OP <= 5'd0;
        end
        7'b1100111: begin // JALR
            MEM_READ_EN <= 1'd0;
            MEM_WRITE_EN <= 1'd0;
            BJ_CTRL <= 2'b01;
            REG_WRITE_EN <= 1'd1;
            COMP_SEL <= 1'd0;
            WB_VALUE_SEL <= 2'd0;
            OP2_SEL <= 1'd1;
            OP1_SEL <= 1'd0;
            IMM_SEL <= 3'd4;
            ALU_OP <= 5'd0;
        end
        7'b1100011: begin // BEQ, BNE, ...
            MEM_READ_EN <= 1'd0;
            MEM_WRITE_EN <= 1'd0;
            BJ_CTRL <= 2'b10;
            REG_WRITE_EN <= 1'd0;
            COMP_SEL <= 1'd1;
            WB_VALUE_SEL <= 2'd0;
            OP2_SEL <= 1'd0;
            OP1_SEL <= 1'd0;
            IMM_SEL <= 3'd0;
            ALU_OP <= 5'd0;
        end
        7'b0000011: begin // LB, LH, LW
            MEM_READ_EN <= 1'd1;
            MEM_WRITE_EN <= 1'd0;
            BJ_CTRL <= 2'b00;
            REG_WRITE_EN <= 1'd1;
            COMP_SEL <= 1'd0;
            WB_VALUE_SEL <= 2'd1;
            OP2_SEL <= 1'd1;
            OP1_SEL <= 1'd0;
            IMM_SEL <= 3'd4;
            ALU_OP <= 5'd0;
        end
        7'b0100011: begin // SB, SH, SW, ...
            MEM_READ_EN <= 1'd0;
            MEM_WRITE_EN <= 1'd1;
            BJ_CTRL <= 2'b00;
            REG_WRITE_EN <= 1'd1;
            COMP_SEL <= 1'd0;
            WB_VALUE_SEL <= 2'd0;
            OP2_SEL <= 1'd1;
            OP1_SEL <= 1'd0;
            IMM_SEL <= 3'd02;
            ALU_OP <= 5'd0;
        end
        7'b0010011: begin // ADDI, SLTI, SORI, ORI, ANDI, ...
            MEM_READ_EN <= 1'd0;
            MEM_WRITE_EN <= 1'd0;
            BJ_CTRL <= 2'b00;
            REG_WRITE_EN <= 1'd1;
            COMP_SEL <= 1'd0;
            WB_VALUE_SEL <= 2'd0;
            OP2_SEL <= 1'd1;
            OP1_SEL <= 1'd0;
            IMM_SEL <= 3'd4;
            //ALU_OP <= ALU_SELECT;
            ALU_OP <= ((FUNC3 == 3'b101) || (FUNC3 == 3'b001)) ? ALU_SELECT: {2'b0, FUNC3} ;

        end
        7'b0110011: begin // ADD, SUB, AND, OR
            MEM_READ_EN <= 1'd0;
            MEM_WRITE_EN <= 1'd0;
            BJ_CTRL <= 2'b00;
            REG_WRITE_EN <= 1'd1;
            COMP_SEL <= (FUNC7[5] && !FUNC3[0]) ? 1'd1 : 1'd0;
            WB_VALUE_SEL <= 2'd0;
            OP2_SEL <= 1'd0;
            OP1_SEL <= 1'd0;
            IMM_SEL <= 3'd0;
            //ALU_OP <= ALU_SELECT;
            ALU_OP <= ((FUNC3 == 3'b101) ) ? ALU_SELECT: {2'b0, FUNC3} ;

        end
        default: begin // Default
            MEM_READ_EN <= 1'd0;
            MEM_WRITE_EN <= 1'd0;
            BJ_CTRL <= 2'b00;
            REG_WRITE_EN <= 1'd1;
            COMP_SEL <= 1'd0;
            WB_VALUE_SEL <= 2'd0;
            OP2_SEL <= 1'd0;
            OP1_SEL <= 1'd0;
            IMM_SEL <= 3'd0;
            ALU_OP <= ALU_SELECT;
        end
        endcase
    end
endmodule