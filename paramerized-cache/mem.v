module Memory (
  input wire clk,
  input wire reset,
  input wire [31:0] address,
  input wire [31:0] data_in,
  input wire read_enable,
  input wire write_enable,
  output wire [31:0] data_out,
  output wire busy_wait
);

  // Internal memory storage
  reg [31:0] memory [0:1024];

  // Internal signals
  reg [31:0] read_data;
  reg busy_wait_internal;

  // Read and write operations
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Reset memory content
      for (integer i = 0; i < 1024; i = i + 1) begin
        memory[i] = 32'h0;
      end
    end else begin
      // Read operation
      if (read_enable) begin
        busy_wait_internal = 1; // Set busy wait signal
        read_data = memory[address[31:1]];
        busy_wait_internal = 0; // Clear busy wait signal
      end

      // Write operation
      if (write_enable) begin
        busy_wait_internal = 1; // Set busy wait signal
        memory[address[31:2]] = data_in;
        busy_wait_internal = 0; // Clear busy wait signal
      end
    end
  end

  // Output signals
  assign data_out = read_data;
  assign busy_wait = busy_wait_internal;

endmodule
