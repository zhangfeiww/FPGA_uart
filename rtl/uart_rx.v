module uart_rx
#(
	parameter		UART_BAUD_RATE	=	'd9600			,
	parameter		CLK_FREQ		=	'd50_000_000
)
(
	input	wire			sys_clk,	
	input	wire			sys_rstn,
	input	wire			rx,

	output	reg		[7:0]	ser_to_para,
	output	reg				flag_end
);
	localparam		BAUD_CNT_MAX	=	CLK_FREQ/UART_BAUD_RATE	;
			reg 			rx_delay1 		;
			reg 			rx_delay2 		;
			reg 			rx_delay3 		;
			wire 			start_nedge 	;
			reg 			work_en 		;
			reg 	[12:0] 	baud_cnt 		;
			reg 			bit_flag 		;
			reg 	[3:0] 	bit_cnt 		;
			reg 	[7:0] 	rx_data 		;
			reg 			rx_flag 		;
/**********************delay for searching a negedge of rx****************/
always @(posedge sys_clk or negedge sys_rstn)begin
	if(!sys_rstn)
		begin
			rx_delay1	<=	1'b1	;
			rx_delay2	<=	1'b1	;
			rx_delay3	<=	1'b1	;
		end
	else
		begin
			rx_delay1	<=	rx			;
			rx_delay2	<=	rx_delay1	;
			rx_delay3	<=	rx_delay2	;
		end
end
assign start_nedge = (rx_delay2 == 1'b0) && (rx_delay3 == 1'b1)	;
/**********************reg for work_en****************/
always @(posedge sys_clk or negedge sys_rstn)begin
	if(!sys_rstn)
		work_en	<=	1'b0	;
	else if(start_nedge == 1'b1)
		work_en	<=	1'b1	;
	else if((bit_cnt == 4'd8)	&&	(bit_flag == 1'b1))
		work_en	<=	1'b0	;
end
/**********************reg baud_cnt****************/
always@(posedge sys_clk or negedge sys_rstn)begin
	if(!sys_rstn)
		baud_cnt <= 13'b0;
	else if((baud_cnt == BAUD_CNT_MAX - 1) || (work_en == 1'b0))
		baud_cnt <= 13'b0;
	else if(work_en == 1'b1)
		baud_cnt <= baud_cnt + 1'b1;
end
/**********************reg bit_flag****************/
always@(posedge sys_clk or negedge sys_rstn)begin
	if(!sys_rstn)
		bit_flag <= 1'b0;
	else if(baud_cnt == BAUD_CNT_MAX/2 - 1)
		bit_flag <= 1'b1;
	else
		bit_flag <= 1'b0;
end
/**********************reg for bit_cnt****************/
always@(posedge sys_clk or negedge sys_rstn)begin
 	if(!sys_rstn)
 		bit_cnt <= 4'b0;
 	else if((bit_cnt == 4'd8) && (bit_flag == 1'b1))
 		bit_cnt <= 4'b0;
 	else if(bit_flag ==1'b1)
 		bit_cnt <= bit_cnt + 1'b1;
 end
/**********************reg for rx_data****************/
always@(posedge sys_clk or negedge sys_rstn)begin
 	if(!sys_rstn)
 		rx_data <= 8'b0;
 	else if((bit_cnt >= 4'd1)&&(bit_cnt <= 4'd8)&&(bit_flag == 1'b1))
 		rx_data <= {rx_delay3, rx_data[7:1]};
 end
/**********************reg for rx_flag****************/
always@(posedge sys_clk or negedge sys_rstn)begin
 	if(!sys_rstn)
 		rx_flag <= 1'b0;
 	else if((bit_cnt == 4'd8) && (bit_flag == 1'b1))
 		rx_flag <= 1'b1;
 	else
 		rx_flag <= 1'b0;
end




/**********************signal for ser_to_para****************/
always@(posedge sys_clk or negedge sys_rstn)begin
 	if(!sys_rstn)
 		ser_to_para <= 8'b0;
 	else if(rx_flag == 1'b1)
 		ser_to_para <= rx_data;
 end
/**********************signal for flag_end****************/
 always@(posedge sys_clk or negedge sys_rstn)begin
	 if(!sys_rstn)
	 	flag_end <= 1'b0;
	 else
	 	flag_end <= rx_flag;
 end
endmodule
