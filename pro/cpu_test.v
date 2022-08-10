`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:23:41 07/15/2022
// Design Name:   cpu
// Module Name:   C:/Windows/system32/pro/cpu_test.v
// Project Name:  pro
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cpu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module cpu_test;

	// Inputs
	integer fd;
	reg clk;
	reg inpt;
	reg op1;
	reg op2;
	reg ord;

	// Instantiate the Unit Under Test (UUT)
	cpu uut (
		.clk(clk), 
		.ra(ra), 
		.rb(rb), 
		.rc(rc),
		.rd(rd),
		.out(out),
		.tempt(tempt)
	);

	initial begin
		// Initialize Inputs
		//clk = 0;
		//inpt = 0;
		//op1 = 0;
		//op2 = 0;
		//ord = 0;

		// Wait 100 ns for global reset to finish
		
		#100;
        
		// Add stimulus here

	end
      
endmodule

