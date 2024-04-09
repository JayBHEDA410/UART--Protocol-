`timescale 1ns/1ps

module UART (rst,clk,read_en,write_en,write_data,read_data,full,empty,tx,rx,input_number);
	input clk,rst;
	
	input read_en,rx;             //receiver part & FIFO_1
	output [7:0] read_data;
	output empty;
	
	input [9:0] input_number;    //timer
	
	input write_en;             //transmitter & FIFO_2
	input [7:0] write_data;
	output full,tx;

	wire s_tick, done_rec_fifo, done_tran_fifo, full_rec_fifo, empty_tran_fifo;
	wire [7:0] tx_in,rx_out;
	
	baud_rate    #( .bit(10))                 baud_rate_gen(.rst(rst),.clk(clk),.en(1'b1),.input_number(input_number),.done(s_tick));
	
	receiver     #(.D_bit(8),.stop_tick(16))    receive(.clk(clk),.rst(rst),.rx(rx),.s_tick(s_tick),.rx_done(done_rec_fifo),.rx_out(rx_out));
	
	FIFO         #(.bits(8),.depth(8))       FIFO_rec(.rst(rst),.clk(clk),.read_en(read_en),.write_en(done_rec_fifo),.data_out(read_data),.data_in(rx_out),.full(full_rec_fifo),.empty(empty));
	
	FIFO         #(.bits(8),.depth(8))       FIFO_transmitter(.rst(rst),.clk(clk),.read_en(done_tran_fifo),.write_en(write_en),.data_out(tx_in),.data_in(write_data),.full(full),.empty(empty_tran_fifo));
	
	transmitter  #(.D_bit(8),.stop_tick(16))    transmission (.clk(clk),.rst(rst),.tx_in(tx_in),.tx_start(~empty_tran_fifo),.s_tick(s_tick),.tx_done_tick(done_tran_fifo),.tx_out(tx));
		
		
endmodule		