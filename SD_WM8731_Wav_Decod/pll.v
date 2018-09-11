module pll (
				areset,
				inclk0,
				c0,
				cy
			);

	input	  areset;
	input	  inclk0;
	output	  c0;
	output     cy;

	
	reg c0;
	reg cy;
	reg [16:0]count;
	
	always@(posedge inclk0 or negedge areset)begin
	if(!areset)begin	
		c0<=0;
		count<=0;
	end
	else 
		if(count<(2-1))begin
			count<=count+1;
		end
		else begin
				c0<=~c0;
				count<=0;
		end
	end
	
	reg [16:0]count_cy;
	always@(posedge inclk0 or negedge areset)begin
	if(!areset)begin	
		cy<=0;
		count_cy<=0;
	end
	else 
		if(count_cy<(50-1))begin
			count_cy<=count_cy+1;
		end
		else begin
				cy<=~cy;
				count_cy<=0;
		end
	end
	endmodule
	
	