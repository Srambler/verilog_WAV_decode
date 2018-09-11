module sinwave_store( 
							input clock_50M, 
							input bclk, //IIS/PCM clock 
							input adcclk, //左右声道输入 
							input adcdat, //语音输入 
							input record_en, //录音使能信号 
							output reg [31:0] wav_in_data, //ddr语言输入数据 
							output reg wav_wren //ddr语言数据写请求 
							); 
							
reg [7:0] data_num; 
reg [31:0] wave_data_reg;

reg adcclk_a,adcclk_b; 
reg bclk_a,bclk_b; 
reg wav_wren_req; 
reg wav_wren_reg1; 
reg wav_wren_reg2; 

//检测dacclk信号的跳变 
always@(negedge clock_50M ) 
begin 
	adcclk_a<=adcclk; 
	adcclk_b<=adcclk_a;	
end 

//检测bclk时钟跳变 
always@(negedge clock_50M ) 
begin 
	bclk_a<=bclk; 
	bclk_b<=bclk_a; 
end 

//采集ADC的数据 
always@(posedge clock_50M ) 
begin 
	if(record_en==1'b0) begin //复位寄存器 
		data_num<=0; 
		wave_data_reg<=0; 
		wav_in_data<=0; 
		wav_wren_req<=1'b0;
	end 
	else begin 
		if(adcclk_a & !adcclk_b) begin //adcclk上升跳变时 
			wave_data_reg<=0; 
			data_num<=0; 
			wav_in_data<=wave_data_reg; 
			wav_wren_req<=1'b1; 
		end 
		else if(bclk_a&&!bclk_b) begin //bclk 上降沿,采集数据 
			if(((data_num >=16) && (data_num <=31)) | ((data_num >=48) && (data_num <=63))) begin 
				wave_data_reg<={wave_data_reg[30:0], adcdat}; 
				data_num<=data_num+1'b1;
				wav_wren_req<=1'b0; 
			end 
		else begin 
			wave_data_reg<=wave_data_reg; 
			data_num<=data_num+1'b1; 
			wav_wren_req<=1'b0; 
		end 
	end 
	else begin 
		wave_data_reg<=wave_data_reg; 
		data_num<=data_num; 
		wav_wren_req<=1'b0; 
	end 
	end 
end 

//脉冲信号转换为一个clock宽度 
always@(negedge clock_50M ) 
begin 
	wav_wren_reg1<=wav_wren_req; 
	wav_wren_reg2<=wav_wren_reg1;
	if(wav_wren_reg1 & ~wav_wren_reg2) 
		wav_wren<=1'b1; 
	else 
		wav_wren<=1'b0; 
end 
endmodule
