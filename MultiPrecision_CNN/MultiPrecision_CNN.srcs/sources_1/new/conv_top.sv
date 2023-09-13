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

module conv_top #(N = 3, BitSize=32, ImageWidth = 4, NumberOfK = 1, KernelBitSize = 4, CyclesPerPixel = 2)
		(
    		input 						clk,
            input                       res_n,
        	input 						in_valid,     // enable
            input [NumberOfK-1:0][KernelBitSize*(N*N)-1:0] kernel,   

            input [BitSize-1:0] 	    in_data,

        	output                      out_valid
      	
    );

    logic [(N*N)*BitSize-1:0] 	        buffer_out;
    logic                               buffer_valid;

    logic                               conv_valid;
    logic [NumberOfK-1:0][BitSize-1:0] 	conv_out;

    logic [NumberOfK-1:0]               switch_valid;

    logic                               pooling_valid;
    logic [BitSize-1:0]                 pooling_out;

    convolution_buffer #(.N(N),  .BitSize(BitSize), .ImageWidth(ImageWidth))
	(
        .clk(clk),
        .res_n(res_n),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_done(),
        .out_ready(),
        .out_valid(buffer_valid),
        .out_data(buffer_out),
        .out_done()
    );

    convolution_stage #(.NumberOfK(NumberOfK), .N(N), .BitSize(BitSize), 
        .KernelBitSize(KernelBitSize), .ImageWidth(ImageWidth), .CyclesPerPixel(CyclesPerPixel))
	(
    	.clk(clk),
        .res_n(res_n),
        .in_valid(buffer_valid),
        .kernel(kernel),
        .in_data(buffer_out),      
      	.out_ready(),
        .out_valid(conv_valid),
        .out_data(conv_out)	
    );

    switch #(.NumberOfK(NumberOfK), .CyclesPerPixel(CyclesPerPixel))
	(
    	.clk(clk),
        .res_n(res_n),
        .in_valid(conv_valid),  
        .out_valid(switch_valid),      	
    );

    genvar i;
    generate;
        for (i = 0; i<($bits(switch_valid)-1); i=i+1) begin  
            max_pooling_layer #(.N(N), .ImageWidth(ImageWidth), .BitSize(BitSize), .Stride())
            (
                .clk(clk),
                .res_n(res_n),
                .in_valid(switch_valid[i]),
                .in_data(conv_out),
                .out_ready(),
                .out_valid(pooling_valid),
                .out_data(pooling_out)
            );
        end
    endgenerate


    always_comb begin


    end

    always_ff@(posedge clk) begin
        if(!res_n) begin

        end
        else
        begin

        end
    end

endmodule