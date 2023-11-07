`include "./cache.v"
`include "./memory.v"

module top_module (
  input wire [31:0] address,
  input wire [31:0] data_in,
  input wire valid_in,
  input wire write_enable,
  input wire clk,
  output wire [31:0] data_out,
  output wire valid_out
);

  wire [31:0] memory_data;
  wire [31:0] cache_data;
  wire cache_valid;

  // Instantiate the memory module
  memory mem (
    .address(address),
    .data_in(data_in),
    .write_enable(write_enable),
    .clk(clk),
    .data_out(memory_data)
  );

  // Instantiate the cache module with your desired parameters
  cache cache_inst (
    .address(address),
    .data_in(memory_data),
    .valid_in(valid_in),
    .write_enable(write_enable),
    .clk(clk),
    .data_out(cache_data),
    .valid_out(cache_valid)
  );

  // Connect the cache output to the top-level output
  assign data_out = cache_data;
  assign valid_out = cache_valid;
endmodule
