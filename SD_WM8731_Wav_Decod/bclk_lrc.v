module bclk_lrc(clk50, rst_n,lrc,bclk); 
 input clk50; 
 input rst_n; 
 
 output reg lrc;
 output reg bclk;
 
 reg [15:0] count1;
 reg [15:0] count2;
 
 
 always @(posedge clk50 or negedge rst_n) 
 begin 
	if (!rst_n) begin 
		count1 <=1'b0;
		lrc<=0; 
	end 
	else begin
		if(count1 == 16'd567) begin 
			lrc <= 1'b1; 
			count1 <= count1 + 16'd1; 
		end 
		else if(count1 == 16'd1133) begin 
			lrc <= 1'b0; 
			count1 <= 16'd0; 
		end 
		else begin 
			count1 <= count1 + 16'd1; 
		end 
	end
end 

 always @(posedge clk50 or negedge rst_n) 
 begin 
	if (!rst_n) begin 
		count2 <=1'b0;
		bclk<=0; 
	end 
	else begin
		if(count2 == 16'd9) begin 
			bclk <= 1'b1; 
			count2 <= count2 + 16'd1; 
		end 
		else if(count2 == 16'd17) begin 
			bclk <= 1'b0; 
			count2 <= 16'd0; 
		end 
		else begin 
			count2 <= count2 + 16'd1; 
		end 
	end
end 
endmodule