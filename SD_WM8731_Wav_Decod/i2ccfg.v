`timescale 1ns / 1ps 
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: eeprom_test 
// Function: write and read eeprom using I2C bus 
////////////////////////////////////////////////////////////////////////////////// 
module i2ccfg 
( 
	input CLK_50M, 
	input RSTn, 
	output reg XCK,
	output [3:0]LED,
	output SCL, 
	inout SDA 
	); 
	
wire [7:0] RdData; 
wire Done_Sig; 
reg [3:0] i; 
reg [3:0] rLED; 
reg [7:0] rAddr; 
reg [7:0] rData; 
reg [1:0] isStart;


assign LED = rLED; 
reg[15:0] count;
reg[15:0] countXCK;

//12.288Mhz分频
always@( posedge CLK_50M or negedge RSTn )
begin
	if(!RSTn)begin 
		countXCK<=1'b0;
		XCK<=0; 
	end 
	else begin
		if(countXCK == 16'd1) begin 
			XCK <= 1'b1; 
			countXCK <= countXCK + 16'd1; 
		end 
		else if(countXCK == 16'd3) begin 
			XCK <= 1'b0; 
			countXCK <= 16'd0; 
		end 
		else begin 
			countXCK <= countXCK + 16'd1; 
		end 
	end
end 
/***************************/ 
/* EEPROM write and read */ 
/***************************/ 

always @ ( posedge CLK_50M or negedge RSTn ) 
begin
	if( !RSTn ) 
		begin
		count<=0;
		i <= 4'd0; 
		rAddr <= 8'd0; 
		rData <= 8'd0; 
		isStart <= 2'b00; 
		rLED <= 4'b0000; 
		end 
	else 
		begin
		if(count<1000)
			begin
			case( i ) 
			0: 
			if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end 
			else begin isStart <= 2'b01; rData <= 8'h17; rAddr <= 8'h00; end 
			
			1: 
			if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end 
			else begin isStart <= 2'b01; rData <= 8'h17; rAddr <= 8'h02; end 
			
			2: 
			if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end 
			else begin isStart <= 2'b01; rData <= 8'h7f; rAddr <= 8'h04; end 
			
			3: 
			if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end 
			else begin isStart <= 2'b01; rData <= 8'h7f; rAddr <= 8'h06; end 
			
			4: 
			if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end 
			else begin isStart <= 2'b01; rData <= 8'h15; rAddr <= 8'h08; end 
			
			5: 
			if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end 
			else begin isStart <= 2'b01; rData <= 8'h06; rAddr <= 8'h0a; end 
			
			6: 
			if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end 
			else begin isStart <= 2'b01; rData <= 8'h00; rAddr <= 8'h0c; end 
			
			7: 
			if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end 
			else begin isStart <= 2'b01; rData <= 8'h40; rAddr <= 8'h0e; end 
			
			8: 
			if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end 
			else begin isStart <= 2'b01; rData <= 8'h00; rAddr <= 8'h10; end 
			
			9: 
			if( Done_Sig ) begin isStart <= 2'b00; i <= i + 1'b1; end 
			else begin isStart <= 2'b01; rData <= 8'h01; rAddr <= 8'h12; end 
			
			default: 
			begin isStart <= 2'b00;i <= 0;count=count+1;end 
			endcase
			end
//		else 
//			begin
//			if( Done_Sig ) begin isStart <= 2'b00; end 
//			else begin isStart <= 2'b01; rData <= 8'h40; rAddr <= 8'h0e; end 
//			end
		end
end
/***************************/
//I2C通信程序// 
/***************************/ 
iic_com U1 ( 
	.CLK ( CLK_50M ), 
	.RSTn ( RSTn ), 
	.Start_Sig ( isStart ), 
	.Addr_Sig ( rAddr ), 
	.WrData ( rData ), 
	.RdData ( RdData ), 
	.Done_Sig ( Done_Sig ), 
	.SCL ( SCL ), 
	.SDA ( SDA ) ); 
	
endmodule


