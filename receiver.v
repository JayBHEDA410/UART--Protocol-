`timescale 1ns/1ps
module receiver #(parameter D_bit=8, stop_tick=16) (clk,rst,rx,s_tick,rx_done,rx_out);
	input clk,rst,s_tick,rx;
	output [D_bit-1:0] rx_out;
	output reg rx_done;
	
	reg [1:0] ps,ns; // present and next state registers
	reg [3:0] p_nbit_receive,n_nbit_receive;  //registers for number of bit received 
	reg [4:0] p_tick_num,n_tick_num;  //registers for number of tick given
	reg [D_bit-1:0] p_bits,n_bits;  //registers for store received bits
   
	parameter idle=2'b00,start=2'b01,data=2'b10,stop=2'b11;
	
	always@(posedge clk or posedge rst) begin
		if(rst)
			begin
				ps<=idle;
				p_nbit_receive<=0;
				p_tick_num<=0;
				p_bits<=0;
			end
		else
			begin
			   ps<= ns;
				p_nbit_receive<= n_nbit_receive;
				p_tick_num<= n_tick_num;                // next state to present state
				p_bits<= n_bits;
			end
		end		
	
	always@(*)
		begin
			
	    	rx_done=0;
			ns=ps;
			n_nbit_receive=p_nbit_receive;
			n_bits=p_bits;                         // to avoid generating latch
			n_tick_num=p_tick_num;
			
			case(ps)
				idle: if(~rx)
				
							begin
								n_tick_num=0;        // idle state
								ns=start;
							end	
				
				start: if(s_tick)
				
							if(p_tick_num==7)
							
								 begin
									n_tick_num=0;
									n_nbit_receive=0;
									ns=data;             // start state
								end	
								
							else 
								n_tick_num = p_tick_num+1;
								
							
							
				data: if(s_tick==1)
				
								if(p_tick_num==15)
								
									begin
										n_tick_num=0;
										n_bits = {rx,p_bits[D_bit-1:1]};
										
										if(p_nbit_receive==(D_bit-1))
											ns=stop;                            //data state
											
										else
											n_nbit_receive=p_nbit_receive+1;
									end
									
								else	
									n_tick_num=p_tick_num+1;
									
				stop:	if(s_tick==1)
								
								if(p_tick_num==(stop_tick-1))
								
									begin
										rx_done=1;
										ns=idle;
									end              //stop state
									
								else
									n_tick_num = p_tick_num +1;
									
				default: ns=idle;
				
			endcase		
		end
		
	assign rx_out=	p_bits;
	
endmodule	
									
									
								
								
								