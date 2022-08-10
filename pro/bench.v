`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:41:29 07/16/2022
// Design Name:   cpu
// Module Name:   C:/Windows/system32/pro/bench.v
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

module bench;

	// Inputs
	integer fd;
	reg [19:0]inputs;
	reg [19:0] in;
	reg clk;

	// Outputs
	wire [7:0] ra;
	wire [7:0] rb;
	wire [7:0] rc;
	wire [7:0] rd;
	wire [15:0] out;
	wire [7:0]pre_mant;
	wire [7:0]op2;
	wire zf ;
	wire sf;

	// Instantiate the Unit Under Test (UUT)
	cpu uut (
		.in(in), 
		.clk(clk), 
		.ra(ra), 
		.rb(rb), 
		.rc(rc), 
		.rd(rd), 
		.out(out), 
		.pre_mant(pre_mant),
		.op2(op2),
		.zf(zf),
		.sf(sf)
	);
	
	always #50 clk= ~clk;
	initial begin
		// Initialize Inputs
		in = 0;
		clk = 0;
		fd=$fopen("test.txt", "r");
		while($fscanf(fd, "%b" , inputs)) begin
			in=inputs;
			#100;
		// Wait 100 ns for global reset to finish
			
		end
        
		// Add stimulus here

	end
      
endmodule

