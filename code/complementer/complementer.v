module complementer (
    input [31:0] IN,
    output [31:0] OUT
);

wire [31:0] NOTOUT;
assign NOTOUT = IN^32'b11111111111111111111111111111111;
assign OUT = NOTOUT + 1;
    
endmodule