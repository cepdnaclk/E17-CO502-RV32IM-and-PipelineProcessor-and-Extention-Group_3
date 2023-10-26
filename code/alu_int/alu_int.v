module alu_int(
    // inputs
    OP1,
    OP2,
    ALU_OP,
    // outputs
    RESULT,
    ZERO,
    SIGN_BIT,
    SLTU_BIT
);

    // inputs
    input [31:0] OP1, OP2; // Data inputs of the alu
    input [4:0] ALU_OP; // ALU_OP the appropriate operation 
    // outputs
    output reg [31:0] RESULT;
    output ZERO, SIGN_BIT,SLTU_BIT;

    wire[31:0] ADD,AND,OR,XOR,SLL,SRL,SRA,SLT,SLTU, FORWARD;
	
    assign FORWARD = OP2;
	assign ADD = OP1 + OP2;
	assign AND = OP1 & OP2;
	assign OR = OP1 | OP2;
	assign XOR = OP1 ^ OP2;
	assign SLL = OP1 << OP2; //  shift left logical
	assign SRL = OP1 >> OP2; // shift right logical						  
    assign SRA = OP1 >>> OP2; // shift right arithmetic
	assign SLT = ($signed(OP1) < $signed(OP2)) ? 32'd1 : 32'd0; 
	assign SLTU = ($unsigned(OP1) < $unsigned(OP2)) ? 32'd1 : 32'd0;

    //always block
	always @ (*)
	begin
		case(ALU_OP)
			5'd0 : 
        	begin						
				RESULT <= ADD;
			end
			5'd1 : 
        	begin			
          		RESULT <= SLL;
        	end
			5'd2 : 
       		begin
				RESULT <= SLT;
			end
			5'd3 : 
        	begin
				RESULT <= SLTU;
			end
      		5'd4 : 
        	begin
				RESULT <= XOR;
			end
      		5'd5 : 
        	begin
              	RESULT <= SRL;
			end
			5'd13 : 
        	begin      
            	RESULT <= SRA;
			end
			5'd6 :
        	begin
				RESULT <= OR;
			end
			5'd7 :
        	begin      
              	RESULT <= AND;
			end
			5'd16 :
			begin
				RESULT <= FORWARD;
			end
			
		endcase
    end

    assign ZERO = ~(|RESULT); // zero flag set when data 1 and data 2 is equal(Z flag)
    assign SIGN_BIT = RESULT[31]; // sign bit  (G flag)
    assign SLTU_BIT = SLTU[0];	// Generate altu bit

endmodule