`timescale 1ns/1ps
module transmitter #(parameter D_bit=8, stop_tick=16) (clk,rst,tx_in,tx_start,s_tick,tx_done_tick,tx_out);

	input clk,rst,s_tick,tx_start;
	input [D_bit-1:0] tx_in;
	
	output tx_out;
	output reg tx_done_tick;
	
	reg [1:0] ps,ns;         //present and next state registers
	
	reg [3:0] p_nbit_transmit,n_nbit_transmit;      //registers for number of bit transmitted
	reg [3:0] p_tick_num,n_tick_num;             //registers for number of tick given
	reg [D_bit-1:0] p_bits,n_bits;	               //registers for store received bits from FIFO
	
	reg tx_ps_reg,tx_ns_reg;  // registers for transmit 1-1 bit 
   
	parameter idle=2'b00,start=2'b01,data=2'b10,stop=2'b11;
	
	always@(posedge clk or posedge rst) begin
		if(rst)
			begin
				ps<=idle;
				p_nbit_transmit<=0;
				p_tick_num<=0;
				p_bits<=0;
				tx_ps_reg<=1'b1;
			end
		else
			begin
			   ps<=ns;
				p_nbit_transmit<=n_nbit_transmit;
				p_tick_num<=n_tick_num;
				p_bits<=n_bits;                         //next state value to present state 
				tx_ps_reg<=tx_ns_reg;
			end
		end		
	
	always@(*)
		begin
			
		   ns=ps;
	    	tx_done_tick=0;
			
			n_nbit_transmit=p_nbit_transmit;
			n_bits=p_bits;                            // to avoid generating latch
			n_tick_num=p_tick_num;
			
			case(ps)
				idle: begin
							tx_ns_reg=1;
							
							if(tx_start)
				                                  //idle state
							begin
							  tx_done_tick=1;
								n_tick_num=0;
								
								ns=start;
							end	
						end
						
						
				start: begin
							tx_ns_reg=0;
						
					      n_bits=tx_in;
							
							if(s_tick)
					
								if(p_tick_num==15)
								
									 begin
										n_tick_num=0;             //start state
										n_nbit_transmit=0;
										ns=data;
									end	
									
								else 
									n_tick_num = p_tick_num+1;
						 end	
							
							
				data: begin
							tx_ns_reg=p_bits[0];
					
							if(s_tick==1)
					
									if(p_tick_num==15)
									                                            //data state
										begin
											n_tick_num=0;
											n_bits = {1'b0,p_bits[D_bit-1:1]};
											
											if(p_nbit_transmit==(D_bit-1))
												ns=stop;
												
											else
												n_nbit_transmit=p_nbit_transmit+1;
										end
										
									else	
										n_tick_num=p_tick_num+ 1;
						 end				
									
				stop:	begin
							tx_ns_reg=1;
				
							if(s_tick==1)
								
								if(p_tick_num==(stop_tick-1))
								
									begin                         //stop state
									
										ns=idle;
									end
									
								else
									n_tick_num = p_tick_num+1;
						 end			
									
				default: ns=idle;
				
			endcase		
		end
		
	assign tx_out=	tx_ps_reg;
	
endmodule	
									