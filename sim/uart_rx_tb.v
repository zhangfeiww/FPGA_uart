`timescale 1ns/1ps
`define bit_cnt	5208 
module uart_rx_tb();

			reg						clk			;
			reg						rstn		;
			reg						rx			;
			wire		[7:0]		ser_to_para	;
			wire					flag_end	;
		
										
									
uart_rx
#(
			.UART_BAUD_RATE		('d9600)			,
			.CLK_FREQ			('d50_000_000)
)
u0_uart_rx(
			.sys_clk		(clk)					,	
			.sys_rstn		(rstn)					,
			.rx		 		(rx)   					,
			
			.ser_to_para	(ser_to_para)						,
			.flag_end		(flag_end)
);


always #10 clk = ~clk;

initial begin
	clk  = 1'b1;
	rstn = 1'b0;
	rx	 = 1'b1;
	#20
	rstn = 1'b1;
	rx_bit(8'd239); 
 	rx_bit(8'd250);
 	rx_bit(8'd2);
 	rx_bit(8'd3);
 	rx_bit(8'd4);
 	rx_bit(8'd5);
 	rx_bit(8'd6);
 	rx_bit(8'd7);	
	#6000000
	$finish;
end


task rx_bit(
	input	[7:0]	data
);
	integer	i;
	for(i=0; i<10; i=i+1) begin
		case(i)
	 		0: rx = 1'b0;
	 		1: rx = data[0];
	 		2: rx = data[1];
	 		3: rx = data[2];
	 		4: rx = data[3];
	 		5: rx = data[4];
	 		6: rx = data[5];
	 		7: rx = data[6];
	 		8: rx = data[7];
	 		9: rx = 1'b1;
	 	endcase
	 		#(`bit_cnt*20); //每发送1位数据延时5208个时钟周期
	 end
endtask

initial begin
	$fsdbDumpfile("uart_rx_tb.fsdb");
	$fsdbDumpvars(0,uart_rx_tb);
end


endmodule
