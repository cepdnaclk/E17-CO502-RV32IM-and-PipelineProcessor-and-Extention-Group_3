module cache(
    // inputs
    CLOCK,
    RESET, 
    READ_EN,
    WRITE_EN,
    ADDR,
    WRITE_DATA,
    // inputs from mem
    MEM_BUSYWAIT,
    MEM_READ_DATA,
    

    // outputs
    READ_DATA,
    BUSYWAIT,
    // outputs to mem
    MEM_READ_EN,
    MEM_WRITE_EN,
    MEM_ADDR,
    MEM_WRITE_DATA
);

// Define cache parameters
parameter BLOCK_SIZE = 4; // block size in words(4 bytes)
parameter ASSOCIATIVITY  = 4; // number of ways for a set
parameter SET_SIZE = 64; // number of setes

localparam INDEX_BITS  = $clog2(SET_SIZE);
localparam OFFSET_BITS = $clog2(BLOCK_SIZE);
localparam TAG_BITS = 32 - INDEX_BITS - OFFSET_BITS; 
localparam BLOCK_SIZE_BITS = 32*BLOCK_SIZE;
localparam MEM_ADDR_SIZE = 32-OFFSET_BITS;

input wire CLOCK, RESET, READ_EN, WRITE_EN, MEM_BUSYWAIT;
input wire [31:0] WRITE_DATA;
input wire [31:0] ADDR;
input wire [BLOCK_SIZE_BITS-1:0] MEM_READ_DATA;

output reg BUSYWAIT , MEM_READ_EN, MEM_WRITE_EN;
output reg [31:0] READ_DATA;
output reg [BLOCK_SIZE_BITS-1:0] MEM_WRITE_DATA;
output reg [MEM_ADDR_SIZE-1:0] MEM_ADDR;



reg [31:0] cache_data [0:SET_SIZE-1][0:ASSOCIATIVITY-1][BLOCK_SIZE-1:0];
reg [TAG_BITS-1:0] tags [0:SET_SIZE-1][0:ASSOCIATIVITY-1];
reg valid_bits [0:SET_SIZE-1][0:ASSOCIATIVITY-1];
reg dirty_bits [0:SET_SIZE-1][0:ASSOCIATIVITY-1];
reg [4:0] lru [0:SET_SIZE-1][0:ASSOCIATIVITY-1];

wire [OFFSET_BITS-1:0] offset ;//= ADDR[OFFSET_BITS-1:0];
wire [INDEX_BITS-1:0] index ;//= ADDR[INDEX_BITS+OFFSET_BITS-1:OFFSET_BITS];
wire [TAG_BITS-1:0] tag ;//= ADDR[31:INDEX_BITS+OFFSET_BITS];


reg hit, dirty; 

initial begin
    $display("\tBlock Size:%-1d (%-1d bytes) \n\tAssociativity: %-1d \n\tSet Size: %-1d", BLOCK_SIZE, BLOCK_SIZE_BITS,ASSOCIATIVITY, SET_SIZE);
    $display("\tMem addr size: %-1d bits", 32-OFFSET_BITS);

    //$monitor("time=%0t valid_bits= %0d dirty_bit=%0d", $time, valid_bits[0][0] , dirty_bits[0][0]);
    
end

// seperate the address into tag | index | offset
assign {tag,index, offset} =ADDR;

always @(READ_EN, WRITE_EN) begin
    BUSYWAIT = (READ_EN | WRITE_EN) ? 1:0;
end

integer way_match = -1; 

always @(*) begin
    hit <= 1'b0;
    way_match= -1;
    dirty = 0;
    for(integer way=0 ; way < ASSOCIATIVITY; way = way +1) begin
        if(tags[index][way] == tag && valid_bits[index][way]) begin
            hit <= 1'b1;
            way_match = way;
            dirty = dirty_bits[index][way];
            $display("time= %0t hit = %0d",$time, hit);
            //$display("way_match: %0d dirty=%0d", way_match,dirty);
        end
        //$display("out way_match: %0d dirty=%0d", way_match, dirty);
    end
end 

always @(*) begin
    if(READ_EN && hit && dirty_bits[index][way_match]) begin
        READ_DATA = cache_data[index][way_match][offset];
    end
end

always @(posedge CLOCK) begin
    if (WRITE_EN && hit) begin
       for(integer way = 0 ; way <ASSOCIATIVITY ; way++)begin
            if(way != way_match) begin
                lru[index][way] += 1;
            end
       end
       cache_data[index][way_match][offset] = WRITE_DATA;
       dirty_bits[index][way_match] =1;
       // if needed add a cacheWrite and  deasert it
    end
    
end


parameter IDLE = 3'b000;
parameter MEM_READ = 3'b001;
parameter MEM_WRITE = 3'b010;
parameter CACHE_WRITE = 3'b001;

reg [2:0] state, next_state; 

always @(*) begin
    case (state)
        IDLE: 
            if((READ_EN || WRITE_EN) && !dirty && !hit)
                next_state <= MEM_READ;
            else if((READ_EN || WRITE_EN) && dirty && !hit)
                next_state <= MEM_WRITE;
            else
                next_state <= IDLE;
        MEM_READ:
            if (!MEM_BUSYWAIT)
                next_state <= IDLE;
            else
                next_state <= MEM_READ;
        MEM_WRITE:
            next_state <= IDLE;
        CACHE_WRITE:
            if(!MEM_BUSYWAIT)
                next_state <= MEM_READ;
            else
                next_state <=MEM_WRITE;
    endcase

end 


integer writeway = -1;
always @(*)
begin
    case(state)
        IDLE:
        begin
            MEM_READ_EN = 0; 
            MEM_WRITE_EN = 0; 
            MEM_ADDR = {MEM_ADDR_SIZE{1'bx}};
            MEM_WRITE_DATA = {BLOCK_SIZE{1'bx}};
        end

        MEM_READ:
        begin
            MEM_READ_EN = 1; 
            MEM_WRITE_EN = 0 ; 
            MEM_ADDR = {tag, index};
            MEM_WRITE_DATA = {BLOCK_SIZE{1'bx}};
            BUSYWAIT = 1;

            if (!MEM_BUSYWAIT)
            begin
                writeway=0;
                for(integer i=0; i<ASSOCIATIVITY;i++) begin
                    if(lru[index][i] < lru[index][writeway]) begin
                        writeway = i;
                        //$display("writeway %0d", writeway);
                    end
                    
                end
                //$display("outer 2 writeway %0d", writeway);
                for(integer i =0; i<BLOCK_SIZE;i++) begin
                    cache_data[index][writeway][i] = MEM_READ_DATA[32*i +:32];
                end
                $display("time= %0t Cache[0][0][x]=%0h",$time , cache_data[0][0][0]);
                //cache_data[index][writeway] = MEM_READ_DATA;
                tags[index][writeway] = tag;
                valid_bits[index][writeway] =0;
                lru[index][writeway] = 0;
                //dirty_bit[index][writeway] = 0;
                //$display("something");
            end
        end

        MEM_WRITE:
        begin
            MEM_READ_EN = 0;
            MEM_WRITE_EN = 1;
            MEM_ADDR = {tag,index};
            for(integer i =0; i<BLOCK_SIZE;i++) begin
                MEM_WRITE_DATA[32*i +:32] = cache_data[index][writeway][i];
            end
            //MEM_WRITE_DATA = cache_data[index][way_match];
            BUSYWAIT=1;

            if(!MEM_BUSYWAIT) begin
                dirty_bits[index][way_match] = 0;
            end
        end
    endcase
end

always @(posedge CLOCK, RESET) begin
    if(RESET) begin
        state = IDLE;
        for(integer i = 0 ; i < SET_SIZE ; i++)begin
            for(integer j = 0; j < ASSOCIATIVITY; j++) begin
                valid_bits[i][j] = 1'b0;
                dirty_bits[i][j] = 1'b0;
                lru[i][j] = 5'b0;
                for(integer k = 0 ; k < BLOCK_SIZE; k++ ) begin
                    cache_data[i][j][k] = 32'b0;
                end
            end
        end 
    end  
    else
        state = next_state;

end


 

endmodule