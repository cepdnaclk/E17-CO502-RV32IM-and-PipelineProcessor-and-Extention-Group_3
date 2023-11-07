module memory (
  input wire [31:0] address,
  input wire [31:0] data_in,
  input wire write_enable,
  input wire clk,
  output reg [31:0] data_out
);

  parameter MEM_SIZE = 65536; // Define the size of the memory in words (32-bit data)

  reg [31:0] mem[0:MEM_SIZE-1];

  // Read operation
  always @(posedge clk) begin
    if (!write_enable) begin
      data_out = mem[address];
    end
  end

  // Write operation
  always @(posedge clk) begin
    if (write_enable) begin
      mem[address] = data_in;
    end
  end
endmodule
