`include "./mem.v"
module MemoryTestbench;

  // Signals
  reg clk;
  reg reset;
  reg [31:0] address;
  reg [31:0] data_in;
  reg read_enable;
  reg write_enable;
  wire [31:0] data_out;
  wire busy_wait;

  // Instantiate Memory module
  Memory uut (
    .clk(clk),
    .reset(reset),
    .address(address),
    .data_in(data_in),
    .read_enable(read_enable),
    .write_enable(write_enable),
    .data_out(data_out),
    .busy_wait(busy_wait)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Initial block
  initial begin
    // Initialize inputs
    clk = 0;
    reset = 1;
    address = 0;
    data_in = 0;
    read_enable = 0;
    write_enable = 0;

    // Apply reset
    #5 reset = 0;

    // Test scenario 1: Write data to memory
    address = 10;
    data_in = 32'hABCDE123;
    write_enable = 1;
    #20 write_enable = 0;

    // Display memory content after write
    $display("Write: memory[%0d] = %h", address, data_in);

    // Test scenario 2: Read data from memory
    address = 10;
    read_enable = 1;
    #20 read_enable = 0;

    // Display read data
    $display("Read data from memory[%0d]: %h", address, data_out);

    // Test scenario 3: Reset memory content
    reset = 1;
    #10 reset = 0;

    // Display memory content after reset
    address = 10;
    read_enable = 1;
    #20 read_enable = 0;

    $display("Memory content after reset: memory[%0d] = %h", address, data_out);

    // Finish simulation
    #10 $finish;
  end

endmodule
