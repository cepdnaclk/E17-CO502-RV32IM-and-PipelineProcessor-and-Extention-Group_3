module ex_fwd_unit(
    // inputs
    REG_WRITE_ADDR_MEM,
    MEM_WRITE_EN_MEM,
    REG_WRITE_ADDR_WB,
    MEM_WRITE_EN_WB,
    ADDR_1_EX,
    ADDR_2_EX,
    // outputs
    OP1_FWD_SEL,
    OP2_FWD_SEL
);

input MEM_WRITE_EN_MEM, MEM_WRITE_EN_WB;
input [4:0] REG_WRITE_ADDR_MEM, REG_WRITE_ADDR_WB;
input [4:0] ADDR_1_EX, ADDR_2_EX;

output reg [1:0] OP1_FWD_SEL, OP2_FWD_SEL;

    always @ (*)
    begin  
        // Forwarding for Operand 1
        if (MEM_WRITE_EN_MEM && REG_WRITE_ADDR_MEM === ADDR_1_EX)
            OP1_FWD_SEL = 2'b01;    // Activate forwarding from MEM stage
        else if (MEM_WRITE_EN_WB && REG_WRITE_ADDR_WB === ADDR_1_EX)
            OP1_FWD_SEL = 2'b10;    // Activate forwarding from WB stage
        else
            OP1_FWD_SEL = 2'b00;    // No forwarding

        // Forwarding for Operand 2
        if (MEM_WRITE_EN_MEM && REG_WRITE_ADDR_MEM === ADDR_2_EX)
            OP2_FWD_SEL = 2'b01;    // Activate forwarding from MEM stage
        else if (MEM_WRITE_EN_WB && REG_WRITE_ADDR_WB === ADDR_2_EX)
            OP2_FWD_SEL = 2'b10;    // Activate forwarding from WB stage
        else
            OP2_FWD_SEL = 2'b00;    // No forwarding
    end

endmodule