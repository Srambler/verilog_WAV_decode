// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altrea Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL or Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions: I2C output data
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author             :| Mod. Date :| Changes Made:
//   V1.0 :| Joe Yang           :| 05/07/10  :|      Initial Revision
// --------------------------------------------------------------------
`define rom_size 6'd9

module CLOCK_500 (
	CLOCK,
	CLOCK_500,
	DATA,
	END,
	RESET,
	GO,
	CLOCK_2
);
	input  CLOCK;
	input  END;
	input  RESET;
	output CLOCK_500;
	output [23:0]DATA;
	output GO;
	output CLOCK_2;


reg  [10:0]COUNTER_500;

wire  CLOCK_500=COUNTER_500[9];
wire  CLOCK_2=COUNTER_500[1];

reg  [15:0]ROM[`rom_size:0];
reg  [15:0]DATA_A;
reg  [5:0]address;
wire [23:0]DATA={8'h34,DATA_A};
	
wire  GO =((address <= `rom_size) && (END==1))? COUNTER_500[10]:1;
always @(negedge RESET or posedge END) begin
	if (!RESET) address=0;
	else 
	if (address < `rom_size) address=address+1;
end

reg [7:0]vol;

always @(posedge RESET) begin
	vol=vol-1;end


always @(posedge END) begin
//	ROM[0]= 16'h1e00;
	ROM[0]= 16'h0c00;	     //power down
	ROM[1]= 16'h0e00;	     //16位右对齐
	ROM[2]= 16'h0815;	     //sound select
	
	ROM[3]= 16'h1000;		 //mclk
	
	ROM[4]= 16'h0017;		 //
	ROM[5]= 16'h0217;		 //
	ROM[6]= {8'h04,1'b0,vol[6:0]};		 //
	ROM[7]= {8'h06,1'b0,vol[6:0]};	     //sound vol
	ROM[8]= 16'h0a04;      //44.1khz的采样
	//ROM[4]= 16'h1e00;		 //reset	
	ROM[`rom_size]= 16'h1201;//active
	DATA_A=ROM[address];
end

always @(posedge CLOCK ) begin
	COUNTER_500=COUNTER_500+1;
end

endmodule

