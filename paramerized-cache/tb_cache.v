`include "./cache.v"
`include "./memory.v"


module tb_cache;

    parameter DELAY = 5;
    reg clock, reset, read_en, write_en; 
    reg [31:0] addr, write_data;
    wire [31:0] read_data; 
    wire busywait;   
    wire mem_read_en, mem_write_en, mem_busywait;
    wire [29:0] mem_addr;
    wire [127:0] mem_write_data,mem_read_data;

    cache  mycache(
        // inputs
        clock,
        reset, 
        read_en,
        write_en,
        addr,
        write_data,
        // inputs from mem
        mem_busywait,
        mem_read_data,
        

        // outputs
        read_data,
        busywait,
        // outputs to mem
        mem_read_en,
        mem_write_en,
        mem_addr,
        mem_write_data
    );
    
    data_memory mydata_memory(
        // input
        clock,
        reset,
        mem_read_en,
        mem_write_en,
        mem_addr,
        mem_write_data,
        // outputs
        mem_read_data,
        mem_busywait
    );

    always #DELAY clock = ~clock;

    initial begin
        $dumpfile("wavedata.vcd");
        $dumpvars(0,tb_cache);
        clock =1'b0;

        reset = 1;
        #DELAY;
        reset =0; 
        read_en=0;
        write_en=1;
        addr = 1;
        write_data = 32'h1;
        


        #100
        $finish;
    end
        // reset, 
        // read_en,
        // write_en,
        // addr,
        // write_data,

endmodule