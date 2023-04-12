`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2023 22:14:21
// Design Name: 
// Module Name: convolution_stage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// note: N is the size of the kernel - might make it during run-time rather than compilation
// Some features to add after: - stride steps, increased number of data loaded in at once (parameterised)
module convolution_stage #(NumberOfConvs = 1, N = 3, BitSize=32, KernelBitSize = 4, ImageWidth = 100)
		(
    		input 							clk,
            input                           resest,
        	input 							in_valid,     // enable
          	input [KernelBitSize*(N*N)-1:0] kernel,
          	input [BitSize-1:0] 			in_data,
        	input 							reset,
      
      		output 							out_ready,
        	output 							out_valid,
          	output [BitSize-1:0] 			out_data
      	     
      	
    );
  
  	localparam StreamSize = 	ImageWidth*2+N; 
  
  	logic [StreamSize-1:0][BitSize-1:0] data_stream_r;
  	integer 					image_pos_r;
  	integer						image_pos_c;
  
  	wire dot_product_in_c[N*N-1:0][BitSize-1:0];
  	integer stream_index;
  
  	
  	always_comb
      begin
        out_valid = 0;
    	image_pos_c = image_pos_r;
        if(in_valid) begin
        	  
        	data_stream_r[image_pos_c % StreamSize] = in_data;
        	if(image_pos_c >= StreamSize)
        	    begin
        	        int i;
        	        int j;
        	        for (i = 0; i < N; i= i + 1)
        	        begin
        	            for (j = 0; j < N; j= j + 1)
        	            begin
        	              stream_index = (image_pos_c - ((N-1-i)*ImageWidth -(N-1-j))) % StreamSize;
        	              dot_product_in_c[i*N+j] = data_stream_r[stream_index];                
        	            end
        	        end
        	      	out_valid = 1;
        	      	out_ready = 1;
        		end
        	image_pos_c = image_pos_c + 1;
        end
    end
  
  dot_NxN #(.N(N), .BitSize(BitSize), .KernelBitSize(KernelBitSize), .SumDepth(BitSize)) dot_product (.kernel(kernel), .i_data(dot_product_in_c), .o_data(), .sum(out_data));
  
  	always@(posedge clk) begin
    	if(!resest)
      	begin
        image_pos_r <= 0;
      	end
    	else
      	begin
        	image_pos_r <= image_pos_c;
        end
  	end
endmodule