module if_id_reg(
    // inputs
    input CLK,
    input RESET,
    input HAZARD_RESET,
    input HOLD,
    input [31:0] PC_IF,
    input [31:0] INSTRUCTION_IF,
    input MEM_BUSYWAIT,
    input IMEM_BUSYWAIT,

    // outputs
    output reg [31:0] PC_IFID,
    output reg [31:0] INSTRUCTION_IFID,
);

    always @(posedge CLK,posedge RESET)
    begin
        if(RESET)begin  // Clear the reg on reset
        PC_IFID <=32'd0;
        INSTRUCTION_IFID <=32'd0;
        end else if(HAZARD_RESET) begin
        PC_IFID <=32'd0;
        INSTRUCTION_IFID <=32'd0;
        end else if (!MEM_BUSYWAIT && HOLD == 1'b0 && !IMEM_BUSYWAIT) begin // Store all the related value in IF reg if  the previous stage isn't busy
        PC_IFID <= PC_IF;
        INSTRUCTION_IFID <= INSTRUCTION_IF;
        end else if (IMEM_BUSYWAIT) begin
        INSTRUCTION_IFID <=32'd0;
        end
    end

endmodule