module if_unit(
    // inputs
    input CLK,
    input RESET,
    input LU_HAZARD,
    input MEM_BUSYWAIT,
    input BRANCH_SEL,
    input [31:0] B_PC,
    //outputs
    output reg [31:0] PC,
    output [31:0] INSTRUCTION,
    output IMEM_BUSYWAIT
);

    wire [31:0] PC_Select_Mux_Out, Branch_Select_Mux_Out;
    reg [31:0] PC_PLUS_FOUR;

    mux2x1 PC_Select_Mux(
        PC_PLUS_FOUR,
        PC,
        LU_HAZARD,
        PC_Select_Mux_Out
    );
    mux2x1 Branch_Select_Mux(
        PC_Select_Mux_Out,
        B_PC,
        BRANCH_SEL,
        Branch_Select_Mux_Out
    );
    i_cache I_Cache(
        PC,
        CLK,
        RESET,
        INSTRUCTION,
        IMEM_BUSYWAIT
    );

    always @(*) begin
        PC_PLUS_FOUR <= PC + 4;
    end

    always @(posedge CLK, posedge RESET,BRANCH_SEL) begin //update the pc value depend on the positive clock edge
        if(RESET)begin
            PC <= -4;  // set the PC = -4, the pervious always block increase it to 0
        end
        else if(MEM_BUSYWAIT == 1'b0 && IMEM_BUSYWAIT == 1'b0)begin //update the pc when only busywait is zero
            //$display(Branch_Select_Mux_Out);
            //f$display("-");
            #1 PC <=  Branch_Select_Mux_Out; 
        end
    end

endmodule