module complementer (
    input [31:0] IN,
    input COMP_SEL_IDEX,
    output [31:0] OUT
);

    wire [31:0] NOTOUT;
    assign NOTOUT = IN^32'b11111111111111111111111111111111;
    assign OUT = COMP_SEL_IDEX ? NOTOUT + 1:IN;
    
endmodule