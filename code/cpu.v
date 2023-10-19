module cpu(
    
);

if_unit_module if_unit(
    // inputs
    RESET,
    CLK,
    LU_HAZARD,
    MEM_BUSYWAIT,
    BRANCH_SEL,
    B_PC,
    // outputs
    PC,
    INSTRUCTION,
    IMEM_BUSYWAIT
);

if_id_reg_module if_id_reg(
    // inputs
    CLK,
    RESET,
    HAZARD_RESET,
    HOLD,
    PC_IF,
    INSTRUCTION_IF,
    MEM_BUSYWAIT,
    IMEM_BUSYWAIT,
    // outputs
    PC_IFID,
    INSTRUCTION_IFID
);

id_unit_module id_unit(
    // inputs
    CLK,
    RESET,
    PC_IF,
    INSTRUCTION_IFID, // CONTROL_UNIT, HAZARD_DETECTION_UNIT, REGISTER_FILE, IMM_GENERATOR
    WRITE_ADDR, // REGISTER_FILE
    WRITE_DATA, // REGISTER_FILE
    WRITE_EN,
    REG_WRITE_ADDR_EX, // HAZARD_DETECTION_UNIT
    MEM_READ_EN_EX, // HAZARD_DETECTION_UNIT
    BRANCH_SEL,
    // outputs
    // Controller
    REG_WRITE_EN, //  wrten_reg
    WB_VALUE_SEL, // ALU_RESULT, MEM, PC + 4
    MEM_READ_EN, // d_mem_r
    MEM_WRITE_EN, // d_mem_w
    BJ_CTRL,
    ALU_OP, // alu_op
    COMP_SEL,
    OP2_SEL, // mux2
    OP1_SEL, // mux1
    PC_ID,
    // Reg_File
    DATA_1,
    DATA_2,
    REG0, REG1, REG2, REG3, REG4, REG5, REG6,
    // Imm_Gen
    IMM,
    // Hazard_Detection_Unit
    LU_HAZARD,
    // Flush_Unit
    IFID_HOLD,
    IFID_RESET,
    IDEX_RESET,
    // Other
    FUNC3,
    ADDR_1_ID,
    ADDR_2_ID,
    REG_WRITE_ADDR
);

id_ex_reg_module id_ex_reg(
    // input
    CLK,
    RESET,
    IDEX_RESET,
    MEM_BUSYWAIT,
    REG_WRITE_EN_ID, //  wrten_reg
    WB_VALUE_SEL_ID, // ALU_RESULT, MEM, PC + 4
    MEM_READ_EN_ID, // d_mem_r
    MEM_WRITE_EN_ID, // d_mem_w
    BJ_CTRL_ID,
    ALU_OP_ID, // alu_op
    COMP_SEL_ID,
    OP2_SEL_ID, // mux2
    OP1_SEL_ID, // mux1
    IMM_SEL_ID, // mux_wire_module
    PC_ID,
    DATA_1_ID,
    DATA_2_ID,
    IMM_ID,
    FUNC3_ID,
    ADDR_1_ID,
    ADDR_2_ID,
    REG_WRITE_ADDR_ID,
    // outputs
    REG_WRITE_EN_IDEX, //  wrten_reg
    WB_VALUE_SEL_IDEX, // ALU_RESULT, MEM, PC + 4
    MEM_READ_EN_IDEX, // d_mem_r
    MEM_WRITE_EN_IDEX, // d_mem_w
    BJ_CTRL_IDEX,
    ALU_OP_IDEX, // alu_op
    COMP_SEL_IDEX,
    OP2_SEL_IDEX, // mux2
    OP1_SEL_IDEX, // mux1
    IMM_SEL_IDEX, // mux_wire_module
    PC_IDEX,
    DATA_1_IDEX,
    DATA_2_IDEX,
    IMM_IDEX,
    FUNC3_IDEX,
    ADDR_1_IDEX,
    ADDR_2_IDEX,
    REG_WRITE_ADDR_IDEX
);

ex_unit_module ex_unit(
    // inputs
    CLK,
    RESET,
    MEM_BUSYWAIT,
    REG_WRITE_EN_IDEX, //  wrten_reg
    WB_VALUE_SEL_IDEX, // ALU_RESULT, MEM, PC + 4
    MEM_READ_EN_IDEX, // d_mem_r
    MEM_WRITE_EN_IDEX, // d_mem_w
    BJ_CTRL_IDEX,
    ALU_OP_IDEX, // alu_op
    COMP_SEL_IDEX,
    OP2_SEL_IDEX, // mux2
    OP1_SEL_IDEX, // mux1
    IMM_SEL_IDEX, // mux_wire_module
    PC_IDEX,
    DATA_1_IDEX,
    DATA_2_IDEX,
    IMM_IDEX,
    FUNC3_IDEX,
    ADDR_1_IDEX,
    ADDR_2_IDEX,
    REG_WRITE_ADDR_IDEX,
    // OP1_FWD_SEL_MUX, OP2_FWD_SEL_MUX
    ALU_RES_MEM,
    WRITE_DATA_WB,
    // EX_FWD_UNIT
    REG_WRITE_ADDR_MEM,
    MEM_WRITE_EN_MEM,
    REG_WRITE_ADDR_WB,
    MEM_WRITE_EN_WB,
    // outputs
    REG_WRITE_EN_EX,
    WB_VALUE_SEL_EX,
    MEM_READ_EN_EX,
    MEM_WRITE_EN_EX,
    PC_EX,
    RESULT,
    REF_DATA_2_EX,
    FUNC3_EX,
    ADDR_1_EX,
    ADDR_2_EX,
    B_PC,
    BRANCH_SEL
);

ex_mem_reg_module ex_mem_reg(
    // inputs
    CLK,
    RESET,
    MEM_BUSYWAIT,
    REG_WRITE_EN_EX, //  wrten_reg
    WB_VALUE_SEL_EX, // ALU_RESULT, MEM, PC + 4
    MEM_READ_EN_EX, // d_mem_r
    MEM_WRITE_EN_EX, // d_mem_w
    PC_EX,
    RESULT_EX,
    REG_DATA_2_EX,
    FUNC3_EX,
    REG_WRITE_ADDR_EX,
    // outputs
    REG_WRITE_EN_EXMEM,
    WB_VALUE_SEL_EXMEM,
    MEM_READ_EN_EXMEM,
    MEM_WRITE_EN_EXMEM,
    PC_EXMEM,
    RESULT_EXMEM,
    REG_DATA_2_EXMEM,
    FUNC3_EXMEM,
    REG_WRITE_ADDR_EXMEM
);

mem_unit_module mem_unit(
    // inputs
    CLK,
    RESET,
    REG_WRITE_EN_EXMEM,
    WB_VALUE_SEL_EXMEM,
    MEM_READ_EN_EXMEM,
    MEM_WRITE_EN_EXMEM,
    PC_EXMEM,
    RESULT,
    REG_DATA_2_EXMEM,
    FUNC3_EXMEM,
    REG_WRITE_ADDR_EXMEM,
    Wb_Select_Mux_Out, // Mem data select
    // mem_fwd_unit
    MEM_READ_EN_WB,
    REG_WRITE_ADDR_WB,
    // outputs
    MEM_BUSYWAIT,
);

mem_wb_reg_module mem_wb_reg(
    // inputs
    CLK,
    RESET,
    MEM_BUSYWAIT,
    REG_WRITE_EN_MEM,
    WB_VALUE_SEL_MEM,
    MEM_READ_EN_MEM,
    PC_4_MEM,
    ALU_RES_MEM,
    MEM_READ_MEM,
    REG_WRITE_ADDR_MEM,
    // outputs
    REG_WRITE_EN_MEMWB,
    WB_VALUE_SEL_MEMWB,
    MEM_READ_EN_MEMWB,
    PC_4_MEMWB,
    ALU_RES_MEMWB,
    MEM_READ_MEMWB,
    REG_WRITE_ADDR_MEMWB
);

endmodule