`timescale 1ns/1ps

module receiver_test (rst,clk,read_en,read_data,empty,rx,input_number);
	input clk,rst;
	
	input read_en,rx;             //receiver part & FIFO_1
	output [7:0] read_data;
	output empty;
	
	input [9:0] input_number;    //timer
	

	wire s_tick, done_rec_fifo, full_rec_fifo;
	wire [7:0] rx_out;
	
	baud_rate        #( .bit(10))                 baud_rate_gen(.rst(rst),.clk(clk),.en(1'b1),.input_number(input_number),.done(s_tick));
	
	receiver     #(.D_bit(8),.stop_tick(32))    receive(.clk(clk),.rst(rst),.rx(rx),.s_tick(s_tick),.rx_done(done_rec_fifo),.rx_out(rx_out));
	
	FIFO         #(.bits(8),.depth(8))       FIFO_rec(.rst(rst),.clk(clk),.read_en(read_en),.write_en(done_rec_fifo),.data_out(read_data),.data_in(rx_out),.full(full_rec_fifo),.empty(empty));
		
endmodule		