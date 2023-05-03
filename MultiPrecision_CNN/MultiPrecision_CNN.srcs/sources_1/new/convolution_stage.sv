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
// convolution_stage #(.NumberOfK(), .N(), .BitSize(), .KernelBitSize(), .ImageWidth()) conv_s (.clk(), .res_n(), .in_valid(), .kernel(), .in_data(), .out_ready(), .out_valid(), .out_data());
module convolution_stage #(NumberOfK = 1, N = 3, BitSize=32, KernelBitSize = 4, ImageWidth = 4)
		(
    		input 							clk,
            input                           res_n,
        	input 							in_valid,     // enable

          	input [NumberOfK*KernelBitSize*(N*N)-1:0] kernel,
          	input [BitSize-1:0] 			in_data,
      
      		output logic 						out_ready,
        	output logic 						out_valid,
          	output logic [NumberOfK*BitSize-1:0] 			out_data
      	     
      	
    );
  
  	localparam StreamSize = 	(ImageWidth+N-1)*(N-1)+(N+1); // only works for N = 3
  
  	logic [StreamSize-1:0][BitSize-1:0] data_stream_r;
  	logic [StreamSize-1:0][BitSize-1:0] data_stream_c;
	
  	integer 					image_pos_r;
  	integer						image_pos_c;
  
  	logic [N*N-1:0][BitSize-1:0] dot_product_in_c;


	genvar i;
	genvar j;
	generate;
		for (i = 0; i < N; i = i + 1) begin
			for (j = 0; j < N; j = j + 1) begin
				assign dot_product_in_c[i][j] = data_stream_r[i * ImageWidth + j];
			end
		end
	endgenerate


  	always_comb
      begin
		out_ready = 0;
        out_valid = 0;
    	image_pos_c = image_pos_r;
		data_stream_c = data_stream_r;
        if(in_valid) begin
			if (image_pos_c < ImageWidth+2) begin
				data_stream_c = {data_stream_r[StreamSize-2:0],'0};
				out_ready = 0;
			end
			else if((image_pos_c%(ImageWidth+2) == 0) | (image_pos_c%(ImageWidth+2) == ImageWidth+1)) begin
				data_stream_c = {data_stream_r[StreamSize-2:0],'0};
				out_ready = 0;
			end
			else begin
        		data_stream_c = {data_stream_r[StreamSize-2:0], in_data};
				out_ready = 1;
			end
			
        	image_pos_c = image_pos_c + 1;
        end
		else if((image_pos_c < (ImageWidth+2)*(ImageWidth+2)) & (image_pos_c!=0)) begin
			out_ready = 0;
			data_stream_c = {data_stream_r[StreamSize-2:0],'0};
        	image_pos_c = image_pos_c + 1;
		end
    end
  
  dot_NxN #(.N(N), .BitSize(BitSize), .KernelBitSize(KernelBitSize)) dot_product (.kernel(kernel), .in_data(dot_product_in_c), .out_data(), .sum(out_data));
  
  	always@(posedge clk) begin
    	if(!res_n)
      	begin
        image_pos_r <= 0;
		data_stream_r <= 0;
      	end
    	else
      	begin
        	image_pos_r <= image_pos_c;
			data_stream_r <= data_stream_c;
        end
  	end
endmodule