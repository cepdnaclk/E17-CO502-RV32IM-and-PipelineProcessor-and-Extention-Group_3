module HAZARD_DETECTION_UNIT(
    // inputs
    REG_WRITE_ADDR_EX,
    MEM_READ_EN_EX,
    ADDR_1_ID,
    ADDR_2_ID,
    OP1_SEL_ID,
    OP2_SEL_ID,
    // outputs
    LU_HAZARD
);

    input [4:0] REG_WRITE_ADDR_EX;
    input MEM_READ_EN, OP1_SEL_ID, OP2_SEL_ID;
    input [4:0] ADDR_1_ID, ADDR_2_ID;

    always @ (*)
    begin
        if (MEM_READ_EN && (       // Instruction in EX stage must be a memory read
            (!OP1_SEL_ID && (ADDR_1_ID === REG_WRITE_ADDR_EX)) ||    // Check if instruction in ID uses loaded value as OP1
            (!OP2_SEL_ID && (ADDR_2_ID === REG_WRITE_ADDR_EX))       // Check if instruction in ID uses loaded value as OP2
        ))
            LU_HAZARD = 1'b1;
        else
            LU_HAZARD = 1'b0;
    end

endmodule