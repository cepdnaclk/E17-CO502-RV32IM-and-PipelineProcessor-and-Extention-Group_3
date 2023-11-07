`include "./mem.v"
module top_module_tb;

  // Define the signals
  reg [31:0] address;
  reg [31:0] data_in;
  reg valid_in;
  reg write_enable;
  reg clk;
  wire [31:0] data_out;
  wire valid_out;

  // Instantiate the top_module
  top_module top (
    .address(address),
    .data_in(data_in),
    .valid_in(valid_in),
    .write_enable(write_enable),
    .clk(clk),
    .data_out(data_out),
    .valid_out(valid_out)
  );

  // Clock generation
  always begin
    #5 clk = ~clk; // Toggle the clock every 5 time units
  end

  // Test scenario
  initial begin
    // Initialize inputs
    address = 32'h00000000;
    data_in = 32'h12345678;
    valid_in = 1;
    write_enable = 1;
    clk = 0;

    // Apply stimulus
    // Perform a write operation
    #10 address = 32'h00000000; // Address where data is written
    #10 data_in = 32'hABCDEF01; // New data to be written
    #10 write_enable = 1;

    // Perform a read operation
    #10 address = 32'h00000000; // Address to read the data from
    #10 write_enable = 0; // Set write enable to 0 for read
    #10 valid_in = 0; // Simulate a cache miss

    // Display results
    $display("Data out: %h", data_out);
    $display("Valid out: %d", valid_out);

    // Finish the simulation
    $finish;
  end

endmodule
