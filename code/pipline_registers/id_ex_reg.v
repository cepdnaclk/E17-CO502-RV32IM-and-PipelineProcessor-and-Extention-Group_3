module id_ex_reg(
    // input
    input CLK,
    input RESET,
    input IDEX_RESET,
    input MEM_BUSYWAIT,
    input REG_WRITE_EN_ID, //  wrten_reg
    input [1:0] WB_VALUE_SEL_ID, // ALU_RESULT, MEM, PC + 4
    input MEM_READ_EN_ID, // d_mem_r
    input MEM_WRITE_EN_ID, // d_mem_w
    input [1:0] BJ_CTRL_ID,
    input [4:0] ALU_OP_ID, // alu_op
    input COMP_SEL_ID,
    input OP2_SEL_ID, // mux2
    input OP1_SEL_ID, // mux1
    input [31:0] IMM_SEL_ID, // mux_wire_module
    input [31:0] PC_ID,
    input [31:0] DATA_1_ID,
    input [31:0] DATA_2_ID,
    input [31:0] IMM_ID,
    input [2:0] FUNC3_ID,
    input [31:0] ADDR_1_ID,
    input [31:0] ADDR_2_ID,
    input [4:0] REG_WRITE_ADDR_ID,
    // outputs
    output REG_WRITE_EN_IDEX, //  wrten_reg
    output [1:0] WB_VALUE_SEL_IDEX, // ALU_RESULT, MEM, PC + 4
    output MEM_READ_EN_IDEX, // d_mem_r
    output MEM_WRITE_EN_IDEX, // d_mem_w
    output [1:0] BJ_CTRL_IDEX,
    output [4:0] ALU_OP_IDEX, // alu_op
    output COMP_SEL_IDEX,
    output OP2_SEL_IDEX, // mux2
    output OP1_SEL_IDEX, // mux1
    output [31:0] IMM_SEL_IDEX, // mux_wire_module
    output [31:0] PC_IDEX,
    output [31:0] DATA_1_IDEX,
    output [31:0] DATA_2_IDEX,
    output [31:0] IMM_IDEX,
    output [2:0] FUNC3_IDEX,
    output [31:0] ADDR_1_IDEX,
    output [31:0] ADDR_2_IDEX,
    output [4:0] REG_WRITE_ADDR_IDEX
);

    always @(posedge CLK, posedge RESET) begin

        if (RESET) begin
            REG_WRITE_EN_IDEX <= 1'b0;
            WB_VALUE_SEL_IDEX <= 2'b0;
            MEM_READ_EN_IDEX <= 1'b0;
            MEM_WRITE_EN_IDEX <= 1'b0;
            BJ_CTRL_IDEX <= 2'b0;
            ALU_OP_IDEX <= 5'b0;
            COMP_SEL_IDEX <= 1'b0;
            OP2_SEL_IDEX <= 1'b0;
            OP1_SEL_IDEX <= 1'b0;
            IMM_SEL_IDEX <= 32'b0;
            PC_IDEX <= 32'b0;
            DATA_1_IDEX <= 32'b0;
            DATA_2_IDEX <= 32'b0;
            IMM_IDEX <= 32'b0;
            FUNC3_IDEX <= 3'b0;
            ADDR_1_IDEX <= 32'b0;
            ADDR_2_IDEX <= 32'b0;
            REG_WRITE_ADDR_IDEX <= 5'b0;
        end else if (IDEX_RESET) begin
            REG_WRITE_EN_IDEX <= 1'b0;
            WB_VALUE_SEL_IDEX <= 2'b0;
            MEM_READ_EN_IDEX <= 1'b0;
            MEM_WRITE_EN_IDEX <= 1'b0;
            BJ_CTRL_IDEX <= 2'b0;
            ALU_OP_IDEX <= 5'b0;
            COMP_SEL_IDEX <= 1'b0;
            OP2_SEL_IDEX <= 1'b0;
            OP1_SEL_IDEX <= 1'b0;
            IMM_SEL_IDEX <= 32'b0;
            PC_IDEX <= 32'b0;
            DATA_1_IDEX <= 32'b0;
            DATA_2_IDEX <= 32'b0;
            IMM_IDEX <= 32'b0;
            FUNC3_IDEX <= 3'b0;
            ADDR_1_IDEX <= 32'b0;
            ADDR_2_IDEX <= 32'b0;
            REG_WRITE_ADDR_IDEX <= 5'b0;
        end else if (!MEM_BUSYWAIT) begin
            REG_WRITE_EN_IDEX <= REG_WRITE_EN_ID;
            WB_VALUE_SEL_IDEX <= WB_VALUE_SEL_ID;
            MEM_READ_EN_IDEX <= MEM_READ_EN_ID;
            MEM_WRITE_EN_IDEX <= MEM_WRITE_EN_ID;
            BJ_CTRL_IDEX <= BJ_CTRL_ID;
            ALU_OP_IDEX <= ALU_OP_ID;
            COMP_SEL_IDEX <= COMP_SEL_ID;
            OP2_SEL_IDEX <= OP2_SEL_ID;
            OP1_SEL_IDEX <= OP1_SEL_ID;
            IMM_SEL_IDEX <= IMM_SEL_ID;
            PC_IDEX <= PC_ID;
            DATA_1_IDEX <= DATA_1_ID;
            DATA_2_IDEX <= DATA_2_ID;
            IMM_IDEX <= IMM_ID;
            FUNC3_IDEX <= FUNC3_ID;
            ADDR_1_IDEX <= ADDR_1_ID;
            ADDR_2_IDEX <= ADDR_2_ID;
            REG_WRITE_ADDR_IDEX <= REG_WRITE_ADDR_ID;
        end

        
    end

endmodule