`include "./mem.v"
module cache (
  input wire [31:0] address,
  input wire [31:0] data_in,
  input wire valid_in,
  input wire write_enable,
  input wire read_enable,
  input wire clk,
  output wire [31:0] data_out,
  output wire valid_out
);

  // Define cache parameters
  parameter BLOCK_SIZE = 4;  // Set the block size in bytes
  parameter ASSOCIATIVITY = 4;  // Set the associativity
  parameter SET_SIZE = 64;  // Set the number of sets in the cache

  // Calculate the number of sets and index bits
  localparam NUM_SETS = SET_SIZE;
  localparam INDEX_BITS = $clog2(NUM_SETS);

  // Calculate offset bits and block offset mask
  localparam OFFSET_BITS = $clog2(BLOCK_SIZE);
  localparam OFFSET_MASK = BLOCK_SIZE - 1;

  // Calculate tag bits
  localparam TAG_BITS = 32 - INDEX_BITS - OFFSET_BITS;

  // Create storage for cache data
  reg [31:0] cache_data [0:NUM_SETS-1][0:ASSOCIATIVITY-1];
  reg [TAG_BITS-1:0] cache_tag [0:NUM_SETS-1][0:ASSOCIATIVITY-1];
  reg valid [0:NUM_SETS-1][0:ASSOCIATIVITY-1];

  // Create storage for LRU information
  reg [ASSOCIATIVITY-1:0] lru [0:NUM_SETS-1];

  // Internal signals for memory interface
  reg [31:0] mem_data_out;
  reg mem_valid_out;
  reg mem_busy_wait;

  // Inputs
  wire [INDEX_BITS-1:0] index = address[INDEX_BITS+OFFSET_BITS-1:OFFSET_BITS];
  wire [TAG_BITS-1:0] tag = address[31:INDEX_BITS+OFFSET_BITS];

  // Outputs
  wire [INDEX_BITS-1:0] read_index = address[INDEX_BITS+OFFSET_BITS-1:OFFSET_BITS];
  wire [TAG_BITS-1:0] read_tag = address[31:INDEX_BITS+OFFSET_BITS];
  reg [31:0] read_data;
  reg read_valid;

  integer lru_way = 0;
  integer way_match = -1;
  integer match_found = 0;


Memory uut_memory (
    .clk(clk),
    .address(address[31:2]),
    .data_in(32'h0),
    .read_enable(1),
    .write_enable(0),
    .data_out(mem_data_out),
    .busy_wait(mem_busy_wait)
);

  // Read operation with LRU handling
  always @(posedge clk) begin
    read_data = data_in;
    read_valid = valid_in;

    // Find the cache way with the matching tag if read_enable is high
    if (read_enable) begin
      way_match = -1;
      match_found = 0;
      for (integer way = 0; way < ASSOCIATIVITY; way = way + 1) begin
        if (valid[index][way] && cache_tag[index][way] == read_tag) begin
          way_match = way;
          match_found = 1;
        end
      end

      if (match_found) begin
        // Cache hit: Update LRU for the matching way
        for (integer way = 0; way < ASSOCIATIVITY; way = way + 1) begin
          if (way != way_match && lru[index][way] < lru[index][way_match]) begin
            lru[index][way] = lru[index][way] + 1;
          end
        end
        lru[index][way_match] = 0; // The matching way is the most recently used
        read_data = cache_data[index][way_match];
        read_valid = 1'b1;
      end
    end

    // If cache miss and read_enable is high, initiate memory read
    if (read_enable && !match_found) begin
      // Assume mem_busy_wait signal indicates the completion of the read
      mem_busy_wait = 1;
      // Connect to memory module to perform read operation
      
      // Update cache with data from memory
      cache_data[index][lru_way] = mem_data_out;
      cache_tag[index][lru_way] = tag;
      valid[index][lru_way] = 1; // Assuming data is valid after memory read
      lru[index][lru_way] = 0; // The LRU way is the most recently used
      read_data = mem_data_out;
      read_valid = 1'b1;
    end
  end

  // Write operation
  always @(posedge clk) begin
    if (write_enable) begin
      // Find the least recently used way
      lru_way = 0;
      for (integer way = 0; way < ASSOCIATIVITY; way = way + 1) begin
        if (lru[index][way] > lru[index][lru_way]) begin
          lru_way = way;
        end
      end

      // Update cache data, tag, and valid for the LRU way
      cache_data[index][lru_way] = data_in;
      cache_tag[index][lru_way] = tag;
      valid[index][lru_way] = valid_in;

      // Update LRU for the newly written way
      for (integer way = 0; way < ASSOCIATIVITY; way = way + 1) begin
        if (way != lru_way) begin
          lru[index][way] = lru[index][way] + 1;
        end
      end
      lru[index][lru_way] = 0; // The LRU way is the most recently used
    end
  end

  // Assign outputs
  assign data_out = read_data;
  assign valid_out = read_valid;
endmodule
