`timescale 1ns/1ps
module baud_rate #(parameter bit=10) (rst,clk,en,input_number,done);
	
	input rst,clk,en;
	input [bit-1:0] input_number;
	output done;
	reg [bit-1:0] ps,ns;
	
	always@(posedge clk or posedge rst)
		begin
			if(rst)
				ps<= 0;
			else if(en)      
				ps<= ns;
			else 
				ps<=ps;
		end		
	
	assign done=(ps==input_number);  //generate done signal 
												// input number = (1/(16*b*T)) - 1 
												//b = 9600 bits/sec
	always@(*)
		ns= (done) ? 0 : ps+1;    
		
endmodule		