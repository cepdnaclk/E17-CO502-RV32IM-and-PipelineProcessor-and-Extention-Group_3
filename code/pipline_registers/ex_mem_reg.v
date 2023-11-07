`timescale 1ns/100ps

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
    output reg REG_WRITE_EN_EXMEM,
    output reg [1:0] WB_VALUE_SEL_EXMEM,
    output reg MEM_READ_EN_EXMEM,
    output reg MEM_WRITE_EN_EXMEM,
    output reg [31:0] PC_EXMEM,
    output reg [31:0] RESULT_EXMEM,
    output reg [31:0] REG_DATA_2_EXMEM,
    output reg [2:0] FUNC3_EXMEM,
    output reg [4:0] REG_WRITE_ADDR_EXMEM
);

    always @(posedge CLK, posedge RESET)
    begin
    if(RESET)begin
      REG_WRITE_EN_EXMEM <= #0.1 1'd0;
      WB_VALUE_SEL_EXMEM <= #0.1 2'd0;
      MEM_READ_EN_EXMEM <= #0.1 1'b0;
      MEM_WRITE_EN_EXMEM <= #0.1 1'b0;
      PC_EXMEM <= #0.1 31'b0;
      RESULT_EXMEM <= #0.1 31'b0;
      REG_DATA_2_EXMEM<= #0.1 31'b0;
      FUNC3_EXMEM <= #0.1 3'd0;
      REG_WRITE_ADDR_EXMEM <= #0.1 5'd0;
    end else if (!MEM_BUSYWAIT) begin
      REG_WRITE_EN_EXMEM <= #0.1 REG_WRITE_EN_EX;
      WB_VALUE_SEL_EXMEM <= #0.1 WB_VALUE_SEL_EX;
      MEM_READ_EN_EXMEM <= #0.1 MEM_READ_EN_EX;
      MEM_WRITE_EN_EXMEM <= #0.1 MEM_WRITE_EN_EX;
      PC_EXMEM <= #0.1 PC_EX;
      RESULT_EXMEM <= #0.1 RESULT_EX;
      REG_DATA_2_EXMEM <= #0.1 REG_DATA_2_EX;
      FUNC3_EXMEM <= #0.1 FUNC3_EX;
      REG_WRITE_ADDR_EXMEM <= #0.1 REG_WRITE_ADDR_EX;
    end

  end

endmodule