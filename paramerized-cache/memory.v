module data_memory(
	clock,
    reset,
    read,
    write,
    address,
    writedata,
    readdata,
	busywait
);
input				clock;
input           	reset;
input           	read;
input           	write;
input[29:0]      	address;
input[127:0]     	writedata;
output reg [127:0]	readdata;
output reg      	busywait;

//Declare memory array 256x8-bits 
reg [127:0] memory_array [255:0];

//Detecting an incoming memory access
reg readaccess, writeaccess;
always @(read, write)
begin
	busywait = (read || write)? 1 : 0;
	readaccess = (read && !write)? 1 : 0;
	writeaccess = (!read && write)? 1 : 0;
end

//Reading & writing
always @(posedge clock)
begin
	if(readaccess)
	begin
		readdata   = memory_array[address];
		busywait = 0;
		readaccess = 0;
	end
	if(writeaccess)
	begin
		memory_array[address] = writedata;
		busywait = 0;
		writeaccess = 0;
	end
end

//Reset memory
integer i;
always @(posedge reset)
begin
    if (reset)
    begin
        for (i=0;i<256; i=i+1)
            memory_array[i] = 0;
        
		memory_array[0] = {4{32'haabbccdd}};
        busywait = 0;
		readaccess = 0;
		writeaccess = 0;
    end
end

endmodule
