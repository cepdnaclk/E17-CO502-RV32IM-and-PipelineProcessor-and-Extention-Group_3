`timescale 1ns/100ps

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
    input [4:0] ADDR_1_ID,
    input [4:0] ADDR_2_ID,
    input [4:0] REG_WRITE_ADDR_ID,
    // outputs
    output reg REG_WRITE_EN_IDEX, //  wrten_reg
    output reg [1:0] WB_VALUE_SEL_IDEX, // ALU_RESULT, MEM, PC + 4
    output reg MEM_READ_EN_IDEX, // d_mem_r
    output reg MEM_WRITE_EN_IDEX, // d_mem_w
    output reg [1:0] BJ_CTRL_IDEX,
    output reg [4:0] ALU_OP_IDEX, // alu_op
    output reg COMP_SEL_IDEX,
    output reg OP2_SEL_IDEX, // mux2
    output reg OP1_SEL_IDEX, // mux1
    output reg [31:0] IMM_SEL_IDEX, // mux_wire_module
    output reg [31:0] PC_IDEX,
    output reg [31:0] DATA_1_IDEX,
    output reg [31:0] DATA_2_IDEX,
    output reg [31:0] IMM_IDEX,
    output reg [2:0] FUNC3_IDEX,
    output reg [4:0] ADDR_1_IDEX,
    output reg [4:0] ADDR_2_IDEX,
    output reg [4:0] REG_WRITE_ADDR_IDEX
);

    always @(posedge CLK, posedge RESET) begin
        if (RESET) begin
            REG_WRITE_EN_IDEX <= #0.1 1'b0;
            WB_VALUE_SEL_IDEX <= #0.1 2'b0;
            MEM_READ_EN_IDEX <= #0.1 1'b0;
            MEM_WRITE_EN_IDEX <= #0.1 1'b0;
            BJ_CTRL_IDEX <= #0.1 2'b0;
            ALU_OP_IDEX <= #0.1 5'b0;
            COMP_SEL_IDEX <= #0.1 1'b0;
            OP2_SEL_IDEX <= #0.1 1'b0;
            OP1_SEL_IDEX <= #0.1 1'b0;
            IMM_SEL_IDEX <= #0.1 32'b0;
            PC_IDEX <= #0.1 32'b0;
            DATA_1_IDEX <= #0.1 32'b0;
            DATA_2_IDEX <= #0.1 32'b0;
            IMM_IDEX <= #0.1 32'b0;
            FUNC3_IDEX <= #0.1 3'b0;
            ADDR_1_IDEX <= #0.1 5'b0;
            ADDR_2_IDEX <= #0.1 5'b0;
            REG_WRITE_ADDR_IDEX <= #0.1 5'b0;
        end else if (IDEX_RESET) begin
            REG_WRITE_EN_IDEX <= #0.1 1'b0;
            WB_VALUE_SEL_IDEX <= #0.1 2'b0;
            MEM_READ_EN_IDEX <= #0.1 1'b0;
            MEM_WRITE_EN_IDEX <= #0.1 1'b0;
            BJ_CTRL_IDEX <= #0.1 2'b0;
            ALU_OP_IDEX <= #0.1 5'b0;
            COMP_SEL_IDEX <= #0.1 1'b0;
            OP2_SEL_IDEX <= #0.1 1'b0;
            OP1_SEL_IDEX <= #0.1 1'b0;
            IMM_SEL_IDEX <= #0.1 32'b0;
            PC_IDEX <= #0.1 32'b0;
            DATA_1_IDEX <= #0.1 32'b0;
            DATA_2_IDEX <= #0.1 32'b0;
            IMM_IDEX <= #0.1 32'b0;
            FUNC3_IDEX <= #0.1 3'b0;
            ADDR_1_IDEX <= #0.1 5'b0;
            ADDR_2_IDEX <= #0.1 5'b0;
            REG_WRITE_ADDR_IDEX <= #0.1 5'b0;
        end else if (!MEM_BUSYWAIT) begin
            REG_WRITE_EN_IDEX <= #0.1 REG_WRITE_EN_ID;
            WB_VALUE_SEL_IDEX <= #0.1 WB_VALUE_SEL_ID;
            MEM_READ_EN_IDEX <= #0.1 MEM_READ_EN_ID;
            MEM_WRITE_EN_IDEX <= #0.1 MEM_WRITE_EN_ID;
            BJ_CTRL_IDEX <= #0.1 BJ_CTRL_ID;
            ALU_OP_IDEX <= #0.1 ALU_OP_ID;
            COMP_SEL_IDEX <= #0.1 COMP_SEL_ID;
            OP2_SEL_IDEX <= #0.1 OP2_SEL_ID;
            OP1_SEL_IDEX <= #0.1 OP1_SEL_ID;
            IMM_SEL_IDEX <= #0.1 IMM_SEL_ID;
            PC_IDEX <= #0.1 PC_ID;
            DATA_1_IDEX <= #0.1 DATA_1_ID;
            DATA_2_IDEX <= #0.1 DATA_2_ID;
            IMM_IDEX <= #0.1 IMM_ID;
            FUNC3_IDEX <= #0.1 FUNC3_ID;
            ADDR_1_IDEX <= #0.1 ADDR_1_ID;
            ADDR_2_IDEX <= #0.1 ADDR_2_ID;
            REG_WRITE_ADDR_IDEX <= #0.1 REG_WRITE_ADDR_ID;
        end   
    end

endmodule