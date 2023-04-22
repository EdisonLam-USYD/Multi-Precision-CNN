`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2023 14:39:05
// Design Name: 
// Module Name: max_pooling_layer
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

// utilises max pooling module to shrink down a whole input image based pooling size
// assumes ImageWidth % N = 0
// also assumes input will be streamed in similar to convolution stage
module max_pooling_layer #(N = 2, ImageWidth = 4, BitSize = 32)
    (
        input                       clk,
        input                       res_n,
        input                       in_valid,         // enable

        input [BitSize-1:0]         in_data,

        output logic                out_ready,          // don't think this is necessary as padding is not an issue and there are no wasted cycles
                                                        // only when out_ready is high, data should be given
        output logic                out_valid,
        output logic [BitSize-1:0]  out_data
    );

    localparam StreamSize = 	(ImageWidth)*(N-1)+N; // no padding required
  
  	logic [StreamSize-1:0][BitSize-1:0] data_stream_r;
    logic [StreamSize-1:0][BitSize-1:0] data_stream_c;
  	integer 					image_pos_r;
  	integer						image_pos_c;

    always@(posedge clk) begin
    	if(!res_n)
      	begin
        image_pos_r <= 0;
      	end
    	else
      	begin
        	image_pos_r <= image_pos_c;
            data_stream_r <= data_stream_c;
        end
  	end

    always_comb begin
        out_valid = 0;
        out_ready = 0;
        data_stream_c = data_stream_r;
        image_pos_c = image_pos_r;

        if (in_valid) begin         // store values
            image_pos_c = image_pos_c + 1; 
            data_stream_c = {data_stream_r[StreamSize*BitSize-1:BitSize], in_data};
            out_ready = 1;
        end

        if (image_pos_c >= StreamSize) begin

        end
        
    end


endmodule
