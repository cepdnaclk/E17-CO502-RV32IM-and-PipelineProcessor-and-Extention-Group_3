`include "./cache.v"
module testbench;

  // Parameters
  parameter BLOCK_SIZE = 32;
  parameter ASSOCIATIVITY = 4;
  parameter SET_SIZE = 64;

  // Signals
  reg [31:0] address;
  reg [31:0] data_in;
  reg valid_in;
  reg write_enable;
  reg clk;
  wire [31:0] data_out;
  wire valid_out;

  // Instantiate the cache module
  cache cache_inst (
    .address(address),
    .data_in(data_in),
    .valid_in(valid_in),
    .write_enable(write_enable),
    .clk(clk),
    .data_out(data_out),
    .valid_out(valid_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Reset
    write_enable = 0;
    valid_in = 0;
    data_in = 0;

    // Wait a few clock cycles
    #10;

    // Test Case 1: Read and Write Operations
    $display("Test Case 1: Read and Write Operations");
    for (integer i = 0; i < 5; i = i + 1) begin
      // Generate random address and data
      address = $random % (SET_SIZE * BLOCK_SIZE);
      data_in = $random;

      // Perform read operation
      valid_in = 1;
      write_enable = 0;
      #10;
      $display("Read: Address = %0d, Data Out = %0d, Valid Out = %0d", address, data_out, valid_out);

      // Perform write operation
      valid_in = 1;
      write_enable = 1;
      #10;
      $display("Write: Address = %0d, Data In = %0d, Valid Out = %0d", address, data_in, valid_out);

      // Wait before the next iteration
      #10;
    end

    // Test Case 2: Read Operation with Cache Miss
    $display("Test Case 2: Read Operation with Cache Miss");
    address = 100; // Assuming this address is not in the cache
    valid_in = 1;
    write_enable = 0;
    #10;
    $display("Read: Address = %0d, Data Out = %0d, Valid Out = %0d", address, data_out, valid_out);

    // Finish simulation after some cycles
    #100;
    $finish;
  end

endmodule
