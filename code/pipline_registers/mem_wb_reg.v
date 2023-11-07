`timescale 1ns/100ps

module mem_wb_reg(
    // inputs
    input CLK,
    input RESET,
    input MEM_BUSYWAIT,
    input  REG_WRITE_EN_MEM,
    input [1:0] WB_VALUE_SEL_MEM,
    input MEM_READ_EN_MEM,
    input [31:0] PC_4_MEM,
    input [31:0] ALU_RES_MEM,
    input [31:0] MEM_READ_MEM,
    input [4:0] REG_WRITE_ADDR_MEM,
    // outputs
    output reg REG_WRITE_EN_MEMWB,
    output reg [1:0] WB_VALUE_SEL_MEMWB,
    output reg MEM_READ_EN_MEMWB,
    output reg [31:0] PC_4_MEMWB,
    output reg [31:0] ALU_RES_MEMWB,
    output reg [31:0] MEM_READ_MEMWB,
    output reg [4:0] REG_WRITE_ADDR_MEMWB
);

    always @(posedge CLK, posedge RESET)
    begin
    if (RESET) begin
        REG_WRITE_EN_MEMWB <= #0.1 1'b0;
        WB_VALUE_SEL_MEMWB <= #0.1 2'b0;
        MEM_READ_EN_MEMWB <= #0.1 1'b0;
        PC_4_MEMWB <= #0.1 32'b0;
        ALU_RES_MEMWB <= #0.1 32'b0;
        MEM_READ_MEMWB <= #0.1 32'b0;
        REG_WRITE_ADDR_MEMWB <= #0.1 5'b0;
    end else if (!MEM_BUSYWAIT) begin
        REG_WRITE_EN_MEMWB <= #0.1 REG_WRITE_EN_MEM;
        WB_VALUE_SEL_MEMWB <= #0.1 WB_VALUE_SEL_MEM;
        MEM_READ_EN_MEMWB <= #0.1 MEM_READ_EN_MEM;
        PC_4_MEMWB <= #0.1 PC_4_MEM;
        ALU_RES_MEMWB <= #0.1 ALU_RES_MEM;
        MEM_READ_MEMWB <= #0.1 MEM_READ_MEM;
        REG_WRITE_ADDR_MEMWB <= #0.1 REG_WRITE_ADDR_MEM;
    end
    end
    
endmodule