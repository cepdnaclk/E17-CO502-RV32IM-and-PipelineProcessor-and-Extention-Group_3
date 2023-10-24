`timescale 1ns/100ps

`include "../cpu/cpu.v"

module cpu_test; 

    reg CLK, RESET;
    wire [31:0] REG0, REG1, REG2, REG3, REG4, REG5, REG6;
    wire [31:0] PC_OUT;

    cpu mycpu(CLK, RESET, REG0, REG1, REG2, REG3, REG4, REG5, REG6, PC_OUT);

    always
        #5 CLK = ~CLK;

    initial
    begin

        // generate files needed to plot the waveform using GTKWave
        $dumpfile("dumps/cpuwave.vcd");
		$dumpvars(0, cpu_test);
		
        
        CLK = 1'b0;
        RESET = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
		// RESET = 1'b1;
		#2
		RESET = 1'b1;
		#4
		RESET = 1'b0;
		// #4
		// RESET = 1'b0;
        
        // finish simulation after some time
        #6000
        $finish;
        
    end
        

endmodule