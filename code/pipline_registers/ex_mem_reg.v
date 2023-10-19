module ex_mem_reg(
    // inputs
    input CLK,
    input RESET,
    input MEM_BUSYWAIT,
    input REG_WRITE_EN_EX, //  wrten_reg
    input [1:0] WB_VALUE_SEL_EX, // ALU_RESULT, MEM, PC + 4
    input MEM_READ_EN_EX, // d_mem_r
    input MEM_WRITE_EN_EX, // d_mem_w
    input [31:0] PC_EX,
    input [31:0] RESULT_EX,
    input [31:0] REG_DATA_2_EX,
    input [2:0] FUNC3_EX,
    input [4:0] REG_WRITE_ADDR_EX,
    // outputs
    output REG_WRITE_EN_EXMEM,
    output [1:0] WB_VALUE_SEL_EXMEM,
    output MEM_READ_EN_EXMEM,
    output MEM_WRITE_EN_EXMEM,
    output [31:0] PC_EXMEM,
    output [31:0] RESULT_EXMEM,
    output [31:0] REG_DATA_2_EXMEM,
    output [2:0] FUNC3_EXMEM,
    output [4:0] REG_WRITE_ADDR_EXMEM
);

    always @(posedge CLK, posedge RESET)
    begin
    if(RESET)begin
      REG_WRITE_EN_EXMEM <= 1'd0;
      WB_VALUE_SEL_EXMEM <= 2'd0;
      MEM_READ_EN_EXMEM <= 1'b0;
      MEM_WRITE_EN_EXMEM <= 1'b0;
      PC_EXMEM <= 31'b0;
      RESULT_EXMEM <= 31'b0;
      REG_DATA_2_EXMEM<= 31'b0;
      FUNC3_EXMEM <= 3'd0;
      REG_WRITE_ADDR_EXMEM <= 5'd0;
    end else if (!MEM_BUSYWAIT) begin
      REG_WRITE_EN_EXMEM <= REG_WRITE_EN_EX;
      WB_VALUE_SEL_EXMEM <= WB_VALUE_SEL_EX;
      MEM_READ_EN_EXMEM <= MEM_READ_EN_EX;
      MEM_WRITE_EN_EXMEM <= MEM_WRITE_EN_EX;
      PC_EXMEM <= PC_EX;
      RESULT_EXMEM <= RESULT_EX;
      REG_DATA_2_EXMEM<= REG_DATA_2_EX;
      FUNC3_EXMEM <= FUNC3_EX;
      REG_WRITE_ADDR_EXMEM <= REG_WRITE_ADDR_EX;
    end

  end

endmodule