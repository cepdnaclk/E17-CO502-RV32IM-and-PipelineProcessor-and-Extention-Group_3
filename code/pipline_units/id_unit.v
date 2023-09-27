module id_unit(
    // inputs
    input CLK,
    input RESET,
    input [31:0] INSTRUCTION_IFID, // CONTROL_UNIT, HAZARD_DETECTION_UNIT, REGISTER_FILE, IMM_GENERATOR
    input [4:0] WRITE_ADDR, // REGISTER_FILE
    input [31:0] WRITE_DATA, // REGISTER_FILE
    input WRITE_EN,
    input [31:0] REG_WRITE_ADDR_EX, // HAZARD_DETECTION_UNIT
    input MEM_READ_EN_EX, // HAZARD_DETECTION_UNIT
    input BRANCH_SEL
    // outputs

);

    controller Controller(
        // inputs
        INSTRUCTION_IFID[6:0], // OPCODE
        INSTRUCTION_IFID[14:12], // FUNC3
        INSTRUCTION_IFID[31:25], // FUNC7
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
    reg_file Reg_File(
        // inputs
        WRITE_ADDR,
        WRITE_DATA,
        INSTRUCTION_IFID[19:15], // ADDR_1
        INSTRUCTION_IFID[24:20], // ADDR_2
        WRITE_EN,
        CLK,
        RESET,
        // outputs
        DATA_1,
        DATA_2,
        REG0,
        REG1,
        REG2,
        REG3,
        REG4,
        REG5,
        REG6
    );
    


endmodule