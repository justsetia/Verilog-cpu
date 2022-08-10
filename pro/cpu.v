`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:04:42 07/15/2022 
// Design Name: 
// Module Name:    cpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module cpu( in,clk , ra, rb, rc, rd , out ,pre_mant , op2 , zf, sf );
	
	input clk;
	input [19:0] in;
	reg [19:0]inpt;
	output reg [15:0]out;
	output reg [7:0] ra, rb, rc, rd;
	//output reg tempt;
	reg [7:0]  op1 , ord;
	output reg [7:0] op2;
	output reg zf,sf ;
	
	parameter load_ro=4'b0001;
	parameter load_rr=4'b0010;
	parameter add_ro=4'b0011;
	parameter add_rr=4'b0100;
	parameter sub_ro=4'b0101;
	parameter sub_rr=4'b0110;
	parameter mult_ro=4'b0111;
	parameter mult_rr=4'b1000;
	parameter shr=4'b1011;
	parameter shl=4'b1100;
	parameter pt_flt=4'b1101;
	parameter max=8'b00001010;
	parameter max2 = 8'b01100100;
	parameter max3 = 1000;
	
	parameter  register_a=8'b00000001;
	parameter  register_b=8'b00000010;
	parameter  register_c=8'b00000100;
	parameter  register_d=8'b00001000;
	

	
	reg [7:0]  expo ,num2 ;
	reg [6:0] mantisa ;
	output reg [7:0]pre_mant;
	reg [14:0] final_mantisa;
	reg [15:0] res_mult ;
	reg [15:0] mult_op2 , mult_keep;
	
	reg flt , deci;
	integer n  , index , i , j , last , brek ,k ;
	
	initial begin
		sf=0;
		zf=0;
		index=0;
		//tempt=0;
		brek=1;
	 end
	 // load num1 , num2
	 
	 
	always @(posedge clk) begin
		if(rd==0) zf=1;
		else zf=0;
		res_mult=0;
		inpt=in;
		ord=inpt[19:16];
		op2=inpt[15:8];
		op1=inpt[7:0];
		case(ord)
			load_ro:begin               //loading op in register
				case(op2) 
					register_a: begin
						ra=op1;
					end
					register_b: begin
						rb = op1;
					end
					register_c: begin
						rc=op1;
					end
					register_d : begin
						rd=op1;
					end
				endcase
				if(op1==0) zf=1;
				else zf=0;
				if(op1[7]==1) sf=1;
				else sf=0;
			end
			load_rr: begin
				//tempt=1;
				case(op2) 
					register_a: begin
						ra=op1;
					end
					register_b: begin
						rb=op1;
					end
					register_c :begin
						rc=op1;
					end
					register_d : begin
						rd = op1;
					end
				endcase
				if(op1==0) zf=1;
				else zf=0;
				if(op1[7]==1) sf=1;
				else sf=0;
			end
			add_ro : begin
				case(op2)
					register_a:begin
						ra= ra + op1;
						if(ra==0) zf=1;
						else zf=0;
						if(ra[7]==1) sf=1;
						else sf=0;
					end
					register_b : begin
						rb= rb+ op1;
						if(rb==0) zf=1;
						else zf=0;
						if(rb[7]==1) sf=1;
						else sf=0;
					end
					register_c : begin
						rc = rc+op1;
						if(rc==0) zf=1;
						else zf=0;
						if(rc[7]==1) sf=1;
						else sf=0;
					end
					register_d : begin
						rd = rd + op1;
						if(rd==0) zf=1;
						else zf=0;
						if(rd[7]==1) sf=1;
						else sf=0;
					end
				endcase
			end
			add_rr: begin
				//tempt=1;
				case(op2)         //check the op2
					register_a : begin     // second is rega a
						case(op1)
							register_a:begin  //first is reg a
								ra = ra + ra;
							end
							register_b: begin
								ra= ra+ rb;
							end
							register_c: begin
								ra = ra +rc;
							end
							register_d: begin
								ra = ra + rd;
							end
						endcase
						if(ra==0) zf=1;
						else zf=0;
						if(ra[7]==1) sf=1;
						else sf=0;
					end
					register_b: begin
						case(op1) 
							register_a : begin
								rb = rb + ra;
							end
							register_b : begin
								rb = rb +rb;
							end
							register_c : begin
								rb = rb +rc;
							end
							register_d : begin
								rb = rb + rd;
							end
						endcase
						if(rb==0) zf=1;
						else zf=0;
						if(rb[7]==1) sf=1;
						else sf=0;
					end
					register_c : begin
						case(op1) 
							register_a : begin
								rc = rc + ra;
							end
							register_b : begin
								rc = rc +rb;
							end
							register_c : begin
								rc = rc +rc;
							end
							register_d : begin
								rc = rc + rd;
							end
						endcase
						if(rc==0) zf=1;
						else zf=0;
						if(rc[7]==1) sf=1;
						else sf=0;
					end
					register_d : begin
						case(op1) 
							register_a : begin
								rd = rd + ra;
							end
							register_b : begin
								rd = rd +rb;
							end
							register_c : begin
								rd = rd +rc;
							end
							register_d : begin
								rd = rd + rd;
							end
						endcase
						if(rd==0) zf=1;
						else zf=0;
						if(rd[7]==1) sf=1;
						else sf=0;
					end
				endcase
			end
			// ord , num1 , num2
			sub_ro: begin
				case(op2)
					register_a : begin
						ra = op1- ra ;
						if(ra==0) zf=1;
						else zf=0;
						if(ra[7]==1) sf=1;
						else sf=0;
					end
					register_b: begin;
						rb = op1 - rb;
						if(rb==0) zf=1;
						else zf=0;
						if(rb[7]==1) sf=1;
						else sf=0;
					end
					register_c : begin
						rc = op1- rc;
						if(rc==0) zf=1;
						else zf=0;
						if(rc[7]==1) sf=1;
						else sf=0;
					end
					register_d : begin
						rd = op1 - rd;
						if(rd==0) zf=1;
						else zf=0;
						if(rd[7]==1) sf=1;
						else sf=0;
					end
				endcase
			end
			sub_rr: begin
				if(ra==0 || rb==0 || rc==0 || rd==0) zf=1;
				else zf=0;
				case(op2) 
					register_a : begin
						case(op1)
							register_a: begin
								ra= ra - ra;
							end
							register_b : begin
								ra= ra -rb;
							end
							register_c : begin
								ra = ra -rc;
							end
							register_d : begin
								ra = ra - rd;
							end
						endcase
						if(ra==0 || rb==0 || rc==0 || rd==0) zf=1;
						else zf=0;
						if(ra[7]==1) sf=1;
						else sf=0;
					end
					register_b : begin
						case(op1)
							register_a: begin
								rb = rb -ra;
							end
							register_b : begin
								rb= rb -rb;
							end
							register_c : begin
								rb= rb - rc;
							end
							register_d : begin
								rb =rb -rd;
								if(rd==0) zf=1;
								else zf=0;
							end
						endcase
						if(ra==0 || rb==0 || rc==0 || rd==0) zf=1;
						else zf=0 ;
						if(rb[7]==1) sf=1;
						else sf=0;
					end
					register_c : begin
						case(op1)
							register_a: begin
								rc = rc -ra;
							end
							register_b : begin
								rc= rc -rb;
							end
							register_c : begin
								rc= rc - rc;
							end
							register_d : begin
								rc =rc -rd;
								if(rd==0) zf=1;
								else zf=0;
							end
						endcase
						if(ra==0 || rb==0 || rc==0 || rd==0) zf=1;
						else zf=0;
						if(rc[7]==1) sf=1;
						else sf=0;
					end
					register_d : begin
						case(op1)
							register_a: begin
								rd = rd -ra;
								if(rd==0) zf=1;
								else zf=0;
							end
							register_b : begin
								rd= rd -rb;
								if(rd==0) zf=1;
								else zf=0;
							end
							register_c : begin
								rd= rd - rc;
								if(rd==0)zf=1;
								else zf=0;
							end
							register_d : begin
								rd =rd -rd;
								if(rd==0) zf=1;
								else zf=0;
							end
						endcase
						if(ra==0 || rb==0 || rc==0 || rd==0) zf=1;
						else zf=0;
						if(rd[7]==1) sf=1;
						else sf=0;
					end
				endcase
			end
			mult_ro : begin
				case(op2)
					register_a: begin
						mult_op2[15:7]=8'b00000000;
						mult_op2[6:0]=ra;
						mult_keep = mult_op2;
						for( k=0 ; k<8 ; k=k+1) begin
							if(op1[k] ==1) begin
								//tempt=0;
								mult_op2= mult_op2 << k;
								res_mult= res_mult + mult_op2;
								mult_op2 = mult_keep;
							end
						end
					end
					register_b: begin
						mult_op2[15:7]=8'b00000000;
						mult_op2[6:0]=rb;
						mult_keep = mult_op2;
						for( k=0 ; k<8 ; k=k+1) begin
							if(op1[k] ==1) begin
								mult_op2= mult_op2 << k;
								res_mult= res_mult + mult_op2;
								mult_op2 = mult_keep;
							end
						end					
						//res_mult = rb * op1;
					end
					register_c : begin
						mult_op2[15:7]=8'b00000000;
						mult_op2[6:0]=rc;
						mult_keep = mult_op2;
						for( k=0 ; k<8 ; k=k+1) begin
							if(op1[k] ==1) begin
								mult_op2= mult_op2 << k;
								res_mult= res_mult + mult_op2;
								mult_op2 = mult_keep;
							end
						end					
					
					
						//res_mult = rc * op1;
					end
					register_d : begin
						mult_op2[15:7]=8'b00000000;
						mult_op2[6:0]=rd;
						mult_keep = mult_op2;
						for( k=0 ; k<8 ; k=k+1) begin
							if(op1[k] ==1) begin
								mult_op2= mult_op2 << k;
								res_mult= res_mult + mult_op2;
								mult_op2 = mult_keep;
							end
						end					
					
						//res_mult = rd * op1;
					end
				endcase
				if(res_mult==0) zf=1;
				else zf=0;
				if(res_mult[15]==1) sf=1;
				else sf=0;
				ra = res_mult[7:0];
				rd = res_mult [15:8];
			end
			
			mult_rr : begin
				case(op2) 
					register_a : begin
						case(op1)
							register_a : begin
								res_mult = ra * ra ;
							end
							register_b : begin
								res_mult = ra * rb;
							end
							register_c : begin
								res_mult = rc* ra;
							end
							register_d : begin
								res_mult = rd * ra;
							end
						endcase
			
					end
					register_b : begin
						case(op1)
							register_a : begin
								res_mult = rb * ra ;
							end
							register_b : begin
								res_mult = rb * rb;
							end
							register_c : begin
								res_mult = rc* rb;
							end
							register_d : begin
								res_mult = rd * rb;
							end
						endcase
					
					end
					register_c : begin
						case(op1)
							register_a : begin
								res_mult = ra * ra ;
							end
							register_b : begin
								res_mult = ra * rb;
							end
							register_c : begin
								res_mult = rc* ra;
							end
							register_d : begin
								res_mult = rd * ra;
							end
						endcase
					end
					register_d : begin
						case(op1)
							register_a : begin
								res_mult = ra * ra ;
							end
							register_b : begin
								res_mult = ra * rb;
							end
							register_c : begin
								res_mult = rc* ra;
							end
							register_d : begin
								res_mult = rd * ra;
							end
						endcase
					end
				endcase
				if(res_mult==0) zf=1;
				else zf=0;
				if(res_mult[15]==1) sf=1;
				else sf=0;
				ra= res_mult[7:0];
				rd = res_mult [15:8];
			end
			shr : begin
				case(op2)        
					register_a : begin
						for(i=0 ; i<op1 ; i=i+1) begin
							for( j=0 ; j<7 ; j=j+1) begin
								ra[j]=ra[j+1];
							end
							ra[7]=0;
							if(ra==0) zf=1;
							else zf=0;
							if(ra[7]==1) sf=1;
							else sf=0;							
						end
					end
					register_b : begin
						for(i=0 ; i<op1 ; i=i+1) begin
							for( j=0 ; j<7 ; j=j+1) begin
								rb[j]=rb[j+1];
							end
							rb[7]=0;
							if(rb==0) zf=1;
							else zf=0;
							if(rb[7]==1) sf=1;
							else sf=0;							
						end
					end
					register_c : begin
						for(i=0 ; i<op1 ; i=i+1) begin
							for( j=0 ; j<7 ; j=j+1) begin
								rc[j]=rc[j+1];
							end
							rc[7]=0;
							if(rc==0) zf=1;
							else zf=0;
							if(rc[7]==1) sf=1;
							else sf=0;							
						end
					end
					register_d : begin
						for(i=0 ; i<op1 ; i=i+1) begin
							for( j=0 ; j<7 ; j=j+1) begin
								rd[j]=rd[j+1];
							end
							rd[7]=0;
							if(rd==0) zf=1;
							else zf=0;
							if(rd[7]==1) sf=1;
							else sf=0;							
						end
					end
				endcase
			end
			shl : begin
				case(op2)        
					register_a : begin
						for(i=0 ; i<op1 ; i=i+1) begin
							for(j=7 ; j>0 ; j=j-1) begin
								op2[j]=op2[j-1];
							end
							op2[0]=0;
						end
						ra=op2;
						if(ra==0) zf=1;
						else zf=0;
						if(ra[7]==0) sf=1;
						else sf=0;
					end
					register_b : begin
						for(i=0 ; i<op1 ; i=i+1) begin
							//tempt=1;
							for(j=7 ; j>0 ; j=j-1) begin
								rb[j] = rb[j-1];
							end
							rb[0]=0;
						end
						//rb=op2;
						if(rb==0) zf=1;
						else zf=0;
						if(rb[7]==1) sf=1;
						else sf=0;
					end
					register_c : begin
						for(i=0 ; i<op1 ; i=i+1 ) begin
							op2= op2 << 1;
						end
						rc=op2;
						if(rc==0) zf=1;
						else zf=0;
						if(rc[7]==1) sf=1;
						else sf=0;
					end
					register_d : begin
						for( i=0 ; i<op1 ; i=i+1) begin
							op2 = op2 << 1;
						end
						rd=op2;
						if(rd==0) zf=1;
						else zf=0;
						if(rd[7]==1) sf=1;
						else sf=0;
					end
				endcase
			end
			// expo , mantisa , sign
			pt_flt : begin
					last=6;
					num2= inpt[15:8];   // 00000101
					for( i=7 ; i>-1 ; i=i-1) begin
						if( num2[i]==1 && brek==1) begin
							index=i;
							brek=0;
						end
					end
					pre_mant=inpt[7:0];
					brek=1;
					if(pre_mant < max)begin
						for(i=6; i>-1 ; i=i-1) begin
							pre_mant = pre_mant << 1;
							if( pre_mant > max || pre_mant==max) begin
								mantisa[i]=1;
								pre_mant= pre_mant - max;
							end
							else mantisa[i]=0;
						end
					end
					else if(pre_mant < max2)begin //2 raghami
						for( j=6 ; j >-1; j=j-1) begin
							pre_mant = pre_mant << 1;
							if(pre_mant > max2 || pre_mant==max2) begin							
								mantisa[j]=1;
								pre_mant=pre_mant-max2;
							end
							else mantisa[j]=0;
						end
					end
					else begin
						for( j=6 ; j >-1 ; j=j-1) begin
							pre_mant = pre_mant << 1;
							if(pre_mant > max3 || pre_mant==max3) begin							
								mantisa[j]=1;
								pre_mant=pre_mant-max3;
							end
							else mantisa[j]=0;
						end
					end						
					
					out[15]=0;
					expo=index+127;    // maked 129 is it right?
					out[14:7]=expo;
					rc=expo;
					final_mantisa[14:7]=num2;
					final_mantisa[6:0]=mantisa;					
					final_mantisa=final_mantisa >> index; 
					out[6:0]=final_mantisa[6:0];
					rb[7]=out[15];
					rb[6:0]=out[6:0];

			end

		endcase
	end
endmodule
