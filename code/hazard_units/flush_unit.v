module flush_unit(
    // inputs
    LU_HAZ_SIGNAL,
    BRANCH_SEL,
    // outputs
    IFID_HOLD,
    IFID_RESET,
    IDEX_RESET
);

    input LU_HAZ_SIGNAL, BRANCH_SEL;
    output IFID_HOLD, IFID_RESET, IDEX_RESET;

    // In case of a branh/jump, IF/ID PR must be reset
    // In case of a load use hazard, IF/ID PR must hold it's value
    // In case either a branch/jump or load use hazard occurs, ID/EX PR must be reset
    assign IFID_RESET = BRANCH_SEL;
    assign IFID_HOLD = !BRANCH_SEL && LU_HAZ_SIGNAL;
    assign IDEX_RESET = BRANCH_SEL || LU_HAZ_SIGNAL;

endmodule