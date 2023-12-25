`timescale 1ns/1ps
`define bit_cnt	5208 
module uart_tx_tb();

			reg						clk			;
			reg						rstn		;
			reg		[7:0]			ser_to_para	;
			reg						flag_begin	;

			wire					tx			;
		
										
									
uart_tx
#(
			.UART_BAUD_RATE		('d9600)			,
			.CLK_FREQ			('d50_000_000)
)
u0_uart_tx(
	.sys_clk		(clk)			,	
	.sys_rstn		(rstn)			,
  	.flag_begin		(flag_begin)	,
  	.ser_to_para	(ser_to_para)	,	

  	.tx				(tx)
);	


always #10 clk = ~clk;

initial begin
	clk  <= 1'b1;
	rstn <= 1'b0;
	ser_to_para	<= 8'hff;
	flag_begin <= 1'b0;
	#20
	rstn = 1'b1;
	send_tx(8'd0, 1'b1);
	send_tx(8'd1, 1'b1);
	send_tx(8'd2, 1'b1);
	send_tx(8'd3, 1'b1);
	send_tx(8'd4, 1'b1);
	send_tx(8'd5, 1'b1);
	send_tx(8'd6, 1'b1);
	send_tx(8'd7, 1'b1);
	#6000000
	$finish;
end











task send_tx(
	input	[7:0]	data	,
	input			flag
);
begin
	ser_to_para	<= data;
	flag_begin	<=	flag;
	#20
	if(flag)begin
		flag_begin	<=	1'b0;
	 	#(`bit_cnt*20*10);
	end
end
endtask

initial begin
	$fsdbDumpfile("uart_tx_tb.fsdb");
	$fsdbDumpvars(0,uart_tx_tb);
end


endmodule
