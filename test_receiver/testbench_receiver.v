`timescale 1ns/1ps
module testbench_receiver;

   reg rst,clk,rx,read_en;                 //TESTBENCH FOR RECEIVER
   reg [9:0] input_number;
  
  wire empty;                        
  wire [7:0] read_data;
  

  receiver_test  testbench_receiver(rst,clk,read_en,read_data,empty,rx,input_number);
  
 

  always #10 clk =~clk;  
 
  
  initial
		begin
			clk=0;
			rx=1;
			read_en=0;
			
			rst=0;
			#2 rst=1; //rst signal on-off 
			#2 rst=0;
			
			input_number=325; // load value to generate s_tick signal. 
			                   
			
		end
	
  initial begin
		
		 rx<= #200000 0; //start bit
		   
		 rx<= #304167 1;
		 rx<= #408334 1;
		 rx<= #512501 1;
		 rx<= #616668 1;  // 8-bit data sending 
		 rx<= #720835 0;  // 9600 bits/sec = 104167 ns for 1 bit
		 rx<= #825002 0;
		 rx<= #929169 0;
		 rx<= #1033336 0;
		 
		 rx<= #1137503 1;  
		 rx<= #1241670 1;	// 2-bit stop 
		
   end
	
			
	 
  initial begin 
		  #1637603 read_en=1; 
		  #1800000 $finish;
		 
		end

   
  initial begin 
     $monitor("%d %d %d %d %d", $time, testbench_receiver.receive.rx_out,testbench_receiver.receive.rx_done, read_data, empty); // for debugging
	 
   end
  
endmodule
