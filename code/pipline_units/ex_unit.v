module ex_unit(
    // inputs
    input CLK,
    input RESET,
    input MEM_BUSYWAIT,
    input REG_WRITE_EN_IDEX, //  wrten_reg
    input [1:0] WB_VALUE_SEL_IDEX, // ALU_RESULT, MEM, PC + 4
    input MEM_READ_EN_IDEX, // d_mem_r
    input MEM_WRITE_EN_IDEX, // d_mem_w
    input [1:0] BJ_CTRL_IDEX,
    input [4:0] ALU_OP_IDEX, // alu_op
    input COMP_SEL_IDEX,
    input OP2_SEL_IDEX, // mux2
    input OP1_SEL_IDEX, // mux1
    input [31:0] IMM_SEL_IDEX, // mux_wire_module
    input [31:0] PC_IDEX,
    input [31:0] DATA_1_IDEX,
    input [31:0] DATA_2_IDEX,
    input [31:0] IMM_IDEX,
    input [2:0] FUNC3_IDEX,
    input [31:0] ADDR_1_IDEX,
    input [31:0] ADDR_2_IDEX,
    input [4:0] REG_WRITE_ADDR_IDEX,
    // OP1_FWD_SEL_MUX, OP2_FWD_SEL_MUX
    input [31:0] ALU_RES_MEM,
    input [31:0] WRITE_DATA_WB,
    // EX_FWD_UNIT
    input [31:0] REG_WRITE_ADDR_MEM,
    input MEM_WRITE_EN_MEM,
    input [31:0] REG_WRITE_ADDR_WB,
    input MEM_WRITE_EN_WB,
    // outputs
    output [31:0] RESULT;
);
    wire [31:0] Op1_Fwd_Sel_Mux_Out, Op2_Fwd_Sel_Mux_Out;
    wire [31:0] Op1_Sel_Mux_Out, Op2_Sel_Mux_Out;
    wire [31:0] Op2_Sel_Mux_Out_Complement;
    wire ZERO, SIGN_BIT, SLTU_BIT;

    mux3x1 Op1_Fwd_Sel_Mux(
        DATA_1_IDEX,
        ALU_RES_MEM,
        WRITE_DATA_WB,
        OP1_FWD_SEL,
        Op1_Fwd_Sel_Mux_Out,
    );
    mux3x1 Op2_Fwd_Sel_Mux(
        DATA_2_IDEX,
        ALU_RES_MEM,
        WRITE_DATA_WB,
        OP1_FWD_SEL,
        Op2_Fwd_Sel_Mux_Out,
    );
    mux2x1 Op1_Sel_Mux(
        Op1_Fwd_Sel_Mux_Out,
        PC_IDEX,
        OP1_SEL_IDEX,
        Op1_Sel_Mux_Out
    );
    mux2x1 Op2_Sel_Mux(
        Op2_Fwd_Sel_Mux_Out,
        IMM_IDEX,
        OP2_SEL_IDEX,
        Op2_Sel_Mux_Out
    );
    complementer Complementer(
        Op2_Sel_Mux_Out,
        COMP_SEL_IDEX,
        Op2_Sel_Mux_Out_Complement
    );
    alu_int Alu_Int(
        // inputs
        Op1_Sel_Mux_Out,
        Op2_Sel_Mux_Out_Complement,
        ALU_OP_IDEX,
        // outputs
        RESULT,
        ZERO,
        SIGN_BIT,
        SLTU_BIT
    );
    

endmodule