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
    output REG_WRITE_EN_MEM,
    output [1:0] WB_VALUE_SEL_MEM,
    output MEM_READ_EN_MEM,
    output reg [31:0] PC_4_MEM,
    output [31:0] ALU_RESULT,
    output [31:0] READ_DATA,
    output [4:0] REG_WRITE_ADDR_MEM
);

    wire MEM_FWD_SEL;
    wire [31:0] WRITE_DATA;

    assign ALU_RESULT = RESULT;
    assign REG_WRITE_EN_MEM = REG_WRITE_EN_EXMEM;
    assign WB_VALUE_SEL_MEM = WB_VALUE_SEL_EXMEM;
    assign MEM_READ_EN_MEM = MEM_READ_EN_EXMEM;
    assign REG_WRITE_ADDR_MEM = REG_WRITE_ADDR_EXMEM;

    always @(*) begin
        PC_4_MEM <= PC_EXMEM + 4;
    end

    mux2x1 Mem_Data_Sel_Mux(
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
        MEM_BUSYWAIT
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