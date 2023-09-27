module mem_fwd_unit(
    // inputs
    MEM_READ_EN_WB,
    REG_WRITE_ADDRESS_WB,
    MEM_WRITE_EN_MEM,
    REG_WRITE_ADDRESS_MEM,
    // outputs
    MEM_FWD_SEL
);

    input MEM_READ_EN_WB;
    input MEM_WRITE_EN_MEM;
    input [4:0] REG_WRITE_ADDRESS_WB;
    input [4:0] REG_WRITE_ADDRESS_MEM;

    output reg MEM_FWD_SEL;

    always @ (*)
    begin
    if (MEM_WRITE_EN_MEM && MEM_READ_EN_WB && (REG_WRITE_ADDRESS_MEM === REG_WRITE_ADDRESS_WB))
        MEM_FWD_SEL = 1'b1;
    else
        MEM_FWD_SEL = 1'b0;
    end

endmodule