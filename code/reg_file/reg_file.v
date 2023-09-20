module reg_file(
    // inputs
    WRITE_ADDR,
    WRITE_DATA,
    ADDR_1,
    ADDR_2,
    WRITE_EN,
    CLK,
    RESET,
    // outputs
    DATA_1,
    DATA_2,
    REG0,
    REG1,
    REG2,
    REG3,
    REG4,
    REG5,
    REG6
);

    input [31:0] WRITE_DATA;
    input [4:0] WRITE_ADDR;
    input [4:0] ADDR_1, ADDR_2;
    input WRITE_EN, CLK, RESET;

    output [31:0] DATA_1, DATA_2;
    output [31:0] REG0, REG1, REG2, REG3, REG4, REG5, REG6;

    reg [31:0] REGISTER [31:0];

    integer j;

    always @ (negedge CLK,posedge RESET)			
	begin
		if(RESET)
		begin
				for(j = 0; j <= 31; j = j +1 )
				begin
					REGISTER[j] <= 32'b00000000000000000000000000000000;			//assigning 

				end
		end
		else if(WRITE_EN)
		begin
			Register[WRITE_ADDR] <= WRITE_DATA;
		end

	end

    assign DATA_1 = REGISTER[ADDR_1];
    assign DATA_2 = REGISTER[ADDR_2];

    assign REG0 = REGISTER[0];
    assign REG1 = REGISTER[1];
    assign REG2 = REGISTER[2];
    assign REG3 = REGISTER[3];
    assign REG4 = REGISTER[4];
    assign REG5 = REGISTER[5];
    assign REG6 = REGISTER[6];

endmodule