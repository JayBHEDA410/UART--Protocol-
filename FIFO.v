`timescale 1ns/1ps
module FIFO#(parameter bits=8,depth=8) (clk,rst,read_en,write_en,data_out,data_in,full,empty);

	input clk,rst,read_en,write_en;
	input [bits-1:0] data_in;
	output full,empty;
	
	output reg [bits-1:0] data_out;
	
	reg [3:0] read_ptr,write_ptr;
	reg [bits-1:0] register [depth-1:0];
	
	always@(posedge clk or posedge rst)
		begin
			if(rst)
					write_ptr<=0;	
					
			else if(write_en && !full)
				begin
					register[write_ptr]<=data_in;   //write value in FIFO
					write_ptr<=write_ptr+1;
				end
				
			else 
				register[write_ptr]<=register[write_ptr];	
		end		
		
	always@(posedge clk or posedge rst)
		begin
			if(rst)
					read_ptr<=0;	
					
			else if(read_en && !empty)
				begin                                     
					data_out<= register[read_ptr];   //read value from FIFO
					read_ptr<=read_ptr+1;
				end	
			
			else 
					data_out<=data_out;	
		end			
		
	
	assign full=({~write_ptr[3],write_ptr[2:0]} == read_ptr[3:0]);
	assign empty=(read_ptr[3:0] == write_ptr[3:0]);                         //signal generate full and empty
	
endmodule