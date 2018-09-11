module sinwave_gen( 
							input clock_50M, 
							input bclk, //IIS/PCM clock 
							input dacclk, //左右声道输出 
							output reg dacdat, //语音输出 
							input play_en, //播音使能信号 
							output reg wav_rden, //ddr语言数据读请求 
							input [31:0] wav_out_data //ddr语言输出数据 
							); 
				
reg [7:0] data_num; 
reg [31:0] audio_data; 
reg wav_rden_req; 
reg dacclk_a,dacclk_b; 
reg bclk_a,bclk_b; 
reg wav_rden_reg1; 
reg wav_rden_reg2; 

//检测dacclk信号的跳变 
always@(negedge clock_50M ) 
begin 
	dacclk_a<=dacclk;
	dacclk_b<=dacclk_a;	
end 

//检测bclk时钟跳变 
always@(negedge clock_50M ) 
begin 
	bclk_a<=bclk; 
	bclk_b<=bclk_a; 
end 

//播放声音数据 
always@(negedge clock_50M ) 
begin 
	if(play_en==1'b0) begin //复位寄存器
		data_num<=0; 
		audio_data<=0; 
		dacdat<=0; 
	end 
	else begin 
		if(dacclk_a&&!dacclk_b) begin //dacclk 上降沿, 
		audio_data<=wav_out_data;
		data_num<=0; 
		dacdat<=1'b0; 
		end 
		else if(!bclk_a&&bclk_b) begin //bclk 下降沿,播放数据 
			if(((data_num >=15) && (data_num <31)) | ((data_num >=47) && (data_num <63))) begin 
				dacdat<=audio_data[31]; 
				audio_data<={audio_data[30:0],1'b0}; 
			end 
			else begin 
				dacdat<=1'b0; 
				audio_data<=audio_data; 
			end 
			data_num<=data_num+1'b1; 
		end 
	end 
end 

//产生ddr读信号 
always@(posedge clock_50M ) 
begin 
	if(play_en==1'b0) begin 
		wav_rden_req<=1'b0; 
	end 
	else begin 
		if(data_num==8) //产生1个ddr读信号 
			wav_rden_req<=1'b1; 
		else 
			wav_rden_req<=1'b0;
	end 
end 

//脉冲信号转换为一个clock宽度 
always@(negedge clock_50M )
begin 
	wav_rden_reg1<=wav_rden_req; 
	wav_rden_reg2<=wav_rden_reg1;
	if(wav_rden_reg1 & ~wav_rden_reg2) 
		wav_rden<=1'b1; 
	else 
		wav_rden<=1'b0; 
end 

endmodule