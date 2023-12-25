module uart_tx
#(
	parameter		UART_BAUD_RATE	=	'd9600			,
	parameter		CLK_FREQ		=	'd50_000_000
)
(
	input	wire			sys_clk,	
	input	wire			sys_rstn,
	input	wire			flag_begin,
	input	wire	[7:0]	ser_to_para,	

	output	reg				tx
);
	localparam		BAUD_CNT_MAX	=	CLK_FREQ/UART_BAUD_RATE	;

			reg 			work_en 		;
			reg 	[12:0] 	baud_cnt 		;
			reg 			bit_flag 		;
			reg 	[3:0] 	bit_cnt 		;
		

/**********************reg for work_en****************/
always @(posedge sys_clk or negedge sys_rstn)begin
	if(!sys_rstn)
		work_en	<=	1'b0	;
	else if(flag_begin == 1'b1)
		work_en	<=	1'b1	;
	else if((bit_cnt == 4'd9)	&&	(bit_flag == 1'b1))
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
 	else if((bit_cnt == 4'd9) && (bit_flag == 1'b1))
 		bit_cnt <= 4'b0;
 	else if((bit_flag ==1'b1) && (work_en == 1'b1))
 		bit_cnt <= bit_cnt + 1'b1;
 end





/**********************signal for tx****************/
always@(posedge sys_clk or negedge sys_rstn)begin
	 if(!sys_rstn)
	 	tx <= 1'b1; 
	 else if(bit_flag == 1'b1)
	 	begin
	 		case(bit_cnt)
	 		0 : tx <= 1'b0;
	 		1 : tx <= ser_to_para[0];
	 		2 : tx <= ser_to_para[1];
	 		3 : tx <= ser_to_para[2];
	 		4 : tx <= ser_to_para[3];
	 		5 : tx <= ser_to_para[4];
	 		6 : tx <= ser_to_para[5];
	 		7 : tx <= ser_to_para[6];
	 		8 : tx <= ser_to_para[7];
	 		9 : tx <= 1'b1;
	 		default : tx <= 1'b1;
	 		endcase
		end
 end

endmodule
