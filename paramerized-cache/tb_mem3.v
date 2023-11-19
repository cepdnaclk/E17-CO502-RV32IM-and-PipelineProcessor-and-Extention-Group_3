`include "./memory.v"
module testbench_data_memory;

  // Parameters
  parameter DELAY = 10;

  // Signals
  reg clock;
  reg reset;
  reg read;
  reg write;
  reg [29:0] address;
  reg [127:0] writedata;
  wire [127:0] readdata;
  wire busywait;

  // Instantiate the data_memory module
  data_memory uut (
    .clock(clock),
    .reset(reset),
    .read(read),
    .write(write),
    .address(address),
    .writedata(writedata),
    .readdata(readdata),
    .busywait(busywait)
  );

  // Initial stimulus
  initial begin
    // Initialize inputs
    clock = 0;
    reset = 1;
    read = 0;
    write = 0;
    address = 0;
    writedata = 0;

    // Apply reset
    #DELAY reset = 0;

    // Perform a series of write operations
    for (address = 0; address < 10; address = address + 1) begin
      write = 1;
      writedata = 32'hA5A5A5A5 + address;
      #DELAY;
      write = 0;
    end

    // Perform a read operation
    read = 1;
    address = 1;
    #DELAY;
    read = 0;
    #DELAY;
    read = 1;
    address = 2;
    #DELAY;
    read = 0;

    // Finish simulation
    #DELAY $finish;
  end

  // Monitor signals
  always @(negedge read) begin
    $display("Time=%0t,read=%0d, ReadData=%h, BusyWait=%b", $time, read, readdata, busywait);
  end

  // Clock generation
  always #5 clock = ~clock;

endmodule
