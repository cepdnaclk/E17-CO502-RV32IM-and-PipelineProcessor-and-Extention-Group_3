module mem_unit(
    // inputs
    input CLK,
    input RESET,
    input REG_WRITE_EN_EXMEM,
    input [1:0] WB_VALUE_SEL_EXMEM,
    input MEM_READ_EN_EXMEM,
    input MEM_WRITE_EN_EXMEM,
    input [31:0] PC_EXMEM,
    input [31:0] RESULT,
    input [31:0] REG_DATA_2_EXMEM,
    input [2:0] FUNC3_EXMEM,
    input [4:0] REG_WRITE_ADDR_EXMEM,
    input [31:0] Wb_Select_Mux_Out, // Mem data select
    // mem_fwd_unit
    input MEM_READ_EN_WB,
    input [4:0] REG_WRITE_ADDR_WB,
    // outputs
    output MEM_BUSYWAIT,

);

    wire MEM_FWD_SEL;
    wire [31:0] WRITE_DATA;

    always @(*) begin
        PC_4_MEM <= PC_EXMEM + 4;
    end

    mux2X1 Mem_Data_Sel_Mux(
        REG_DATA_2_EXMEM,
        Wb_Select_Mux_Out,
        MEM_FWD_SEL,
        WRITE_DATA
    );
    cache_controller Cache_Controller(
        // inputs
        CLK,
        RESET,
        MEM_READ_EN_EXMEM, // read enable signal
        MEM_WRITE_EN_EXMEM, // write enable signal
        RESULT, // read or write ADDRESS ,alu result
        WRITE_DATA, // write data
        FUNC3_EXMEM,
        // outputs
        READ_DATA, // read data
        BUSYWAIT
    );
    mem_fwd_unit Mem_Fwd_Unit(
        // inputs
        MEM_WRITE_EN_EXMEM,
        REG_WRITE_ADDR_EXMEM,
        MEM_READ_EN_WB,
        REG_WRITE_ADDR_WB,
        // outputs
        MEM_FWD_SEL
    );



endmodule