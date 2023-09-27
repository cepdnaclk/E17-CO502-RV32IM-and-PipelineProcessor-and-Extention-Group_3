module id_unit(
    // inputs
    input CLK,
    input RESET,
    input [31:0] PC_IF,
    input [31:0] INSTRUCTION_IFID, // CONTROL_UNIT, HAZARD_DETECTION_UNIT, REGISTER_FILE, IMM_GENERATOR
    input [4:0] WRITE_ADDR, // REGISTER_FILE
    input [31:0] WRITE_DATA, // REGISTER_FILE
    input WRITE_EN,
    input [31:0] REG_WRITE_ADDR_EX, // HAZARD_DETECTION_UNIT
    input MEM_READ_EN_EX, // HAZARD_DETECTION_UNIT
    input BRANCH_SEL,
    // outputs 
    // Controller
    output REG_WRITE_EN, //  wrten_reg
    output [1:0] WB_VALUE_SEL, // ALU_RESULT, MEM, PC + 4
    output MEM_READ_EN, // d_mem_r
    output MEM_WRITE_EN, // d_mem_w
    output [1:0] BJ_CTRL,
    output [4:0] ALU_OP, // alu_op
    output COMP_SEL,
    output OP2_SEL, // mux2
    output OP1_SEL, // mux1
    output [31:0] PC_ID,
    // Reg_File
    output [31:0] DATA_1,
    output [31:0] DATA_2,
    output [31:0] REG0, REG1, REG2, REG3, REG4, REG5, REG6,
    // Imm_Gen
    output [31:0] IMM,
    // Hazard_Detection_Unit
    output LU_HAZARD,
    // Flush_Unit
    output IFID_HOLD,
    output IFID_RESET,
    output IDEX_RESET,
    // Other
    output [2:0] FUNC3,
    output [31:0] ADDR_1_ID,
    output [31:0] ADDR_2_ID,
    output [4:0] REG_WRITE_ADDR
);

    wire [2:0] IMM_SEL;

    assign ADDR_1_ID = INSTRUCTION_IFID[19:15];
    assign ADDR_2_ID = INSTRUCTION_IFID[24:20];
    assign FUNC3 = INSTRUCTION_IFID[14:12];
    assign REG_WRITE_ADDR = INSTRUCTION_IFI[11:7];
    assign PC_ID = PC_IF;

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
        ADDR_1_ID, // ADDR_1
        ADDR_2_ID, // ADDR_2
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
    imm_gen Imm_Gen(
        // inputs
        INSTRUCTION_IFID,
        IMM_SEL,
        // outputs
        IMM
    );
    hazard_detection_unit Hazard_Detection_Unit(
        // inputs
        REG_WRITE_ADDR_EX,
        MEM_READ_EN_EX,
        ADDR_1_ID,
        ADDR_2_ID,
        OP1_SEL,
        OP2_SEL,
        // outputs
        LU_HAZARD
    );
    flush_unit Flush_Unit(
        // inputs
        LU_HAZARD,
        BRANCH_SEL,
        // outputs
        IFID_HOLD,
        IFID_RESET,
        IDEX_RESET
    );


endmodule