`include "../alu_int/alu_int.v"
`include "../bj_controller/bj_controller.v"
`include "../complementer/complementer.v"
`include "../controller/controller.v"
`include "../d_mem/d_cache.v"
`include "../d_mem/d_cache_contr.v"
`include "../d_mem/d_mem.v"
`include "../data_cache/data_cache.v"
`include "../data_mem/data_mem.v"
`include "../hazard_units/ex_fwd_unit.v"
`include "../hazard_units/mem_fwd_unit.v"
`include "../hazard_units/flush_unit.v"
`include "../hazard_units/hazard_detection_unit.v"
`include "../i_cache/i_cache.v"
`include "../i_mem/i_mem.v"
`include "../imm_gen/imm_gen.v"
`include "../mux/mux2x1.v"
`include "../mux/mux3x1.v"
`include "../mux/mux4x1.v"
`include "../mux/mux5x1.v"
`include "../common_modules/mux2x1_32.v"
`include "../reg_file/reg_file.v"
`include "../pipline_registers/ex_mem_reg.v"
`include "../pipline_registers/id_ex_reg.v"
`include "../pipline_registers/if_id_reg.v"
`include "../pipline_registers/mem_wb_reg.v"
`include "../pipline_units/if_unit.v"
`include "../pipline_units/id_unit.v"
`include "../pipline_units/ex_unit.v"
`include "../pipline_units/mem_unit.v"

module cpu(
    input CLK, 
    input RESET, 
    output [31:0] REG0, REG1, REG2, REG3, REG4, REG5, REG6, 
    output reg [31:0] PC_OUT
);

// if_unit_module
wire LU_HAZARD, MEM_BUSYWAIT, BRANCH_SEL, IMEM_BUSYWAIT;
wire [31:0] B_PC, PC, INSTRUCTION;

// if_id_reg_module
wire HAZARD_RESET, HOLD;
wire [31:0] PC_IFID;
wire [31:0] INSTRUCTION_IFID;

// id_unit_module
wire HAZARD_DETECTION_UNIT, REGISTER_FILE, IMM_GENERATOR, REG_WRITE_EN_MEMWB, MEM_READ_EN_EX;
wire REG_WRITE_EN_ID,  MEM_READ_EN_ID,  MEM_WRITE_EN_ID,  COMP_SEL_ID, OP2_SEL_ID,  OP1_SEL_ID,  IFID_HOLD, IFID_RESET, IDEX_RESET;
wire [1:0] WB_VALUE_SEL_ID, BJ_CTRL_ID;
wire [2:0]  FUNC3_ID;
wire [4:0] ALU_OP_ID,  REG_WRITE_ADDR_ID ,REG_WRITE_ADDR_EX,REG_WRITE_ADDR_MEMWB;
wire [31:0] PC_ID,DATA_1_ID, DATA_2_ID, IMM_ID;

// id_ex_reg_module
wire REG_WRITE_EN_IDEX, MEM_READ_EN_IDEX, MEM_WRITE_EN_IDEX, COMP_SEL_IDEX, OP2_SEL_IDEX, OP1_SEL_IDEX;
wire [1:0] WB_VALUE_SEL_IDEX, BJ_CTRL_IDEX;
wire [2:0] FUNC3_IDEX;
wire [4:0] REG_WRITE_ADDR_IDEX , ALU_OP_IDEX;
wire [31:0] IMM_SEL_IDEX,PC_IDEX, DATA_1_IDEX, DATA_2_IDEX, IMM_IDEX,IMM_SEL_ID;
wire [4:0] ADDR_1_ID, ADDR_2_ID, ADDR_1_IDEX, ADDR_2_IDEX;

// ex_unit_module
wire MEM_WRITE_EN_WB,MEM_WRITE_EN_EXMEM;
wire [1:0]   WB_VALUE_SEL_EX;
wire [2:0] FUNC3_EX;
wire [4:0] ADDR_1_EX,  ADDR_2_EX,REG_WRITE_ADDR_MEM;
wire [31:0] ALU_RES_EXMEM,PC_EX,RESULT_EX, REG_DATA_2_EX;
wire REG_WRITE_EN_EX,  MEM_WRITE_EN_EX;

// ex_mem_reg_module
wire REG_WRITE_EN_EXMEM,  MEM_READ_EN_EXMEM;
wire [31:0] PC_EXMEM, REG_DATA_2_EXMEM ;
wire [1:0] WB_VALUE_SEL_EXMEM;
wire [2:0] FUNC3_EXMEM;
wire [4:0] REG_WRITE_ADDR_EXMEM;

// mem_unit_module
wire [31:0] RESULT;
wire REG_WRITE_EN_MEM, MEM_READ_EN_MEM ; 
wire [1:0] WB_VALUE_SEL_MEM;
wire [31:0] MEM_READ_MEM, ALU_RES_MEM,PC_4_MEM;
// mem_wb_reg_module
wire MEM_READ_EN_MEMWB;
wire [1:0] WB_VALUE_SEL_MEMWB;
wire [31:0] MEM_READ_MEMWB, ALU_RES_MEMWB,PC_4_MEMWB;
// WB_SEL_MUX
wire [31:0] WB_SELECT_MUX_OUT;

always @(*)
begin
  PC_OUT <= PC;
end

if_unit if_unit_module(
    // inputs
    CLK, 
    RESET, 
    LU_HAZARD, 
    MEM_BUSYWAIT, 
    BRANCH_SEL, 
    B_PC, 
    // outputs
    PC, 
    INSTRUCTION, 
    IMEM_BUSYWAIT
);

if_id_reg if_id_reg_module(
    // inputs
    CLK, 
    RESET, 
    HAZARD_RESET, 
    IFID_HOLD, 
    PC, 
    INSTRUCTION, 
    MEM_BUSYWAIT, 
    IMEM_BUSYWAIT, 
    // outputs
    PC_IFID, 
    INSTRUCTION_IFID
);

id_unit id_unit_module(
    // inputs
    CLK, 
    RESET,
    PC_IFID,
    INSTRUCTION_IFID, // CONTROL_UNIT,  HAZARD_DETECTION_UNIT,  REGISTER_FILE,  IMM_GENERATOR
    REG_WRITE_ADDR_MEMWB, // REGISTER_FILE
    WB_SELECT_MUX_OUT, // REGISTER_FILE from wb stage
    REG_WRITE_EN_MEMWB,
    REG_WRITE_ADDR_EX, // HAZARD_DETECTION_UNIT
    MEM_READ_EN_EX, // HAZARD_DETECTION_UNIT
    BRANCH_SEL, 
    // outputs
    // Controller
    REG_WRITE_EN_ID, //  wrten_reg
    WB_VALUE_SEL_ID, // ALU_RESULT,  MEM,  PC + 4
    MEM_READ_EN_ID, // d_mem_r
    MEM_WRITE_EN_ID, // d_mem_w
    BJ_CTRL_ID,
    ALU_OP_ID, // alu_op
    COMP_SEL_ID, 
    OP2_SEL_ID, // mux2
    OP1_SEL_ID, // mux1
    PC_ID, 
    // Reg_File
    DATA_1_ID, 
    DATA_2_ID, 
    REG0, REG1, REG2, REG3, REG4, REG5, REG6, 
    // Imm_Gen
    IMM_ID, 
    // Hazard_Detection_Unit
    LU_HAZARD, 
    // Flush_Unit
    IFID_HOLD, 
    IFID_RESET, 
    IDEX_RESET, 
    // Other
    FUNC3_ID, 
    ADDR_1_ID, 
    ADDR_2_ID, 
    REG_WRITE_ADDR_ID
);

id_ex_reg id_ex_reg_module(
    // input
    CLK, 
    RESET, 
    IDEX_RESET, 
    MEM_BUSYWAIT, 
    REG_WRITE_EN_ID,  //  wrten_reg
    WB_VALUE_SEL_ID,  // ALU_RESULT,  MEM,  PC + 4
    MEM_READ_EN_ID,  // d_mem_r
    MEM_WRITE_EN_ID,  // d_mem_w
    BJ_CTRL_ID, 
    ALU_OP_ID,  // alu_op
    COMP_SEL_ID, 
    OP2_SEL_ID,  // mux2
    OP1_SEL_ID,  // mux1
    IMM_SEL_ID,  // mux_wire_module
    PC_ID, 
    DATA_1_ID, 
    DATA_2_ID, 
    IMM_ID, 
    FUNC3_ID, 
    ADDR_1_ID, 
    ADDR_2_ID, 
    REG_WRITE_ADDR_ID, 
    // outputs
    REG_WRITE_EN_IDEX,  //  wrten_reg
    WB_VALUE_SEL_IDEX,  // ALU_RESULT,  MEM,  PC + 4
    MEM_READ_EN_IDEX,  // d_mem_r
    MEM_WRITE_EN_IDEX,  // d_mem_w
    BJ_CTRL_IDEX, 
    ALU_OP_IDEX,  // alu_op
    COMP_SEL_IDEX, 
    OP2_SEL_IDEX,  // mux2
    OP1_SEL_IDEX,  // mux1
    IMM_SEL_IDEX,  // mux_wire_module
    PC_IDEX, 
    DATA_1_IDEX, 
    DATA_2_IDEX, 
    IMM_IDEX, 
    FUNC3_IDEX, 
    ADDR_1_IDEX, 
    ADDR_2_IDEX, 
    REG_WRITE_ADDR_IDEX
);

ex_unit ex_unit_module(
    // inputs
    CLK, 
    RESET, 
    MEM_BUSYWAIT, 
    REG_WRITE_EN_IDEX,  //  wrten_reg
    WB_VALUE_SEL_IDEX,  // ALU_RESULT,  MEM,  PC + 4
    MEM_READ_EN_IDEX,  // d_mem_r
    MEM_WRITE_EN_IDEX,  // d_mem_w
    BJ_CTRL_IDEX, 
    ALU_OP_IDEX,  // alu_op
    COMP_SEL_IDEX, 
    OP2_SEL_IDEX,  // mux2
    OP1_SEL_IDEX,  // mux1
    IMM_SEL_IDEX,  // mux_wire_module
    PC_IDEX, 
    DATA_1_IDEX, 
    DATA_2_IDEX, 
    IMM_IDEX, 
    FUNC3_IDEX, 
    ADDR_1_IDEX, 
    ADDR_2_IDEX, 
    REG_WRITE_ADDR_IDEX, 
    // OP1_FWD_SEL_MUX,  OP2_FWD_SEL_MUX
    ALU_RES_EXMEM, 
    WB_SELECT_MUX_OUT, 
    // EX_FWD_UNIT
    REG_WRITE_ADDR_MEM,
    MEM_WRITE_EN_EXMEM,
    REG_WRITE_ADDR_MEMWB,
    MEM_WRITE_EN_WB,
    // outputs
    REG_WRITE_EN_EX, 
    WB_VALUE_SEL_EX, 
    MEM_READ_EN_EX, 
    MEM_WRITE_EN_EX, 
    PC_EX, 
    RESULT_EX, 
    REG_DATA_2_EX, 
    FUNC3_EX, 
    ADDR_1_EX, 
    ADDR_2_EX, 
    REG_WRITE_ADDR_EX, 
    B_PC, 
    BRANCH_SEL
);

ex_mem_reg ex_mem_reg_module(
    // inputs
    CLK, 
    RESET, 
    MEM_BUSYWAIT, 
    REG_WRITE_EN_EX,  //  wrten_reg
    WB_VALUE_SEL_EX,  // ALU_RESULT,  MEM,  PC + 4
    MEM_READ_EN_EX,  // d_mem_r
    MEM_WRITE_EN_EX,  // d_mem_w
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
    ALU_RES_EXMEM, 
    REG_DATA_2_EXMEM, 
    FUNC3_EXMEM, 
    REG_WRITE_ADDR_EXMEM
);

mem_unit mem_unit_module(
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
    WB_SELECT_MUX_OUT,  // Mem data select
    // mem_fwd_unit
    MEM_WRITE_EN_EXMEM, 
    REG_WRITE_ADDR_MEMWB, 
    // outputs
    MEM_BUSYWAIT,  // memory busy wait unit
    REG_WRITE_EN_MEM, 
    WB_VALUE_SEL_MEM, 
    MEM_READ_EN_MEM, 
    PC_4_MEM, 
    ALU_RES_MEM, 
    MEM_READ_MEM, 
    REG_WRITE_ADDR_MEM
);

mem_wb_reg mem_wb_reg_module(
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

mux3x1 WB_SEL_MUX(
    ALU_RES_MEMWB, 
    MEM_READ_MEMWB,
    PC_4_MEMWB,
    WB_VALUE_SEL_MEM,
    // output
    WB_SELECT_MUX_OUT
);

endmodule