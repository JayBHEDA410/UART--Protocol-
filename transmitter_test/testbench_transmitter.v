`timescale 1ns/1ps
module testbench_transmitter;                        //TESTBENCH FOR TRANSMISSION

   reg rst,clk,write_en;                 
	reg [7:0] write_data;
   reg [9:0] input_number;
  
  wire full,tx;

  transmitter_test  testbench_transmitter(rst,clk,write_en,write_data,full,tx,input_number);
  
 

  always #10 clk =~clk;  
 
  
  initial
		begin
			clk=0;
			write_en=0;
			rst=0;
			#2 rst=1; //rst signal on-off 
			#2 rst=0;
			   
			input_number=325; // load value to generate s_tick signal
			
		end
		
	 
  initial begin 
       #5 write_data=81;
		 #2 write_en=1;
		 #7 write_data=85;    // write 81 at register[0]
		 #20 write_data=81;   // write 85 at register[1]
		                      // write 81 at register[2]
		    
		 #20 write_en=0;	
		 #4000000 $finish; 
		end

  initial begin 
     $monitor("%d %d %d", $time, tx, testbench_transmitter.transmission.tx_done_tick); // for debugging
	 
   end
  
endmodule
