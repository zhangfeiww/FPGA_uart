module uart_top(
	 input		wire		sys_clk		,
	input		wire		sys_rstn	,
	input		wire		rx			,

	output		wire			tx
);
				wire		[7:0]	ser_to_para					;
				wire				flag_end					;

uart_rx
#(
			.UART_BAUD_RATE		('d9600)					,
			.CLK_FREQ			('d50_000_000)
)
u0_uart_rx(
			.sys_clk		(sys_clk)						,	
			.sys_rstn		(sys_rstn)						,
			.rx		 		(rx)   							,
			
			.ser_to_para	(ser_to_para)					,
			.flag_end		(flag_end)
);

uart_tx
#(
			.UART_BAUD_RATE		('d9600)					,
			.CLK_FREQ			('d50_000_000)
)
u0_uart_tx(
			.sys_clk		(sys_clk)							,	
			.sys_rstn		(sys_rstn)							,
		  	.flag_begin		(flag_end)					,
		  	.ser_to_para	(ser_to_para)					,	
		
		  	.tx				(tx)
);	

endmodule


