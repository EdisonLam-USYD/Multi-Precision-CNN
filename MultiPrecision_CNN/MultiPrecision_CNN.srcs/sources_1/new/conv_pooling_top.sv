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
//One Convolution stage with 3 kernels that feeds into 3 convoltuion stage each
//with a variable number of kernels and kernel bit size
//The Number of Kernels for each layer 2 convolution must be equal to or greater
//than or equal to the layer 2 cycles per pixel
//
//////////////////////////////////////////////////////////////////////////////////

module conv_pooling_top #(N = 3, BitSize=32, ImageWidth = 8, L1CyclesPerPixel = 1, Stride = 2,
        C1NumberOfK = 3, C2NumberOfK = 4, C3NumberOfK = 4, C4NumberOfK = 4,
        C1KernelBitSize = 4, C2KernelBitSize = 4, C3KernelBitSize = 2, C4KernelBitSize = 1,
        [C1KernelBitSize*(N*N)-1:0] C1kernel [C1NumberOfK-1:0] = {'0,'0,'0},
        [C2KernelBitSize*(N*N)-1:0] C2kernel [C2NumberOfK-1:0] = {'0,'0,'0,'0},
        [C3KernelBitSize*(N*N)-1:0] C3kernel [C3NumberOfK-1:0] = {'0,'0,'0,'0},
        [C4KernelBitSize*(N*N)-1:0] C4kernel [C4NumberOfK-1:0] = {'0,'0,'0,'0})
		(
    		input 						                        clk,
            input                                               res_n,
        	input 						                        in_valid,
            input [BitSize-1:0] 	                            in_data,
            
            output logic                                        out_ready,

            output logic [C2NumberOfK-1:0]                  C2_out_valid,
            output logic [C2NumberOfK-1:0][BitSize-1:0] 	C2_out_data,
            output logic [C3NumberOfK-1:0]                  C3_out_valid,
            output logic [C3NumberOfK-1:0][BitSize-1:0]     C3_out_data,
            output logic [C4NumberOfK-1:0]                  C4_out_valid,
            output logic [C4NumberOfK-1:0][BitSize-1:0] 	C4_out_data
      	
    );

    //localparam C1NumberOfK = 3;
    localparam L2CyclesPerPixel = L1CyclesPerPixel*Stride**2;
    localparam L2ImageWidth = ImageWidth/Stride;

    logic [C1NumberOfK-1:0]                 C1_out_valid;
    logic [C1NumberOfK-1:0][BitSize-1:0] 	C1_out_data;
    

    //First convolution stage with 3 kernels
    conv_pooling_layer #(.N (N), .BitSize(BitSize), .ImageWidth(ImageWidth), .NumberOfK(C1NumberOfK), 
        .KernelBitSize(C1KernelBitSize), .CyclesPerPixel(L1CyclesPerPixel), .Stride(Stride), .kernel(C1kernel)) C1
		(
    		.clk(clk),
            .res_n(res_n),
        	.in_valid(in_valid),
            .in_data(in_data),
            .out_ready(out_ready),
        	.out_valid(C1_out_valid),
            .out_data(C1_out_data)
    );

    //C2
    conv_pooling_layer #(.N (N), .BitSize(BitSize), .ImageWidth(L2ImageWidth), .NumberOfK(C2NumberOfK), 
        .KernelBitSize(C2KernelBitSize), .CyclesPerPixel(L2CyclesPerPixel), .Stride(Stride), .kernel(C2kernel)) C2
		(
    		.clk(clk),
            .res_n(res_n),
        	.in_valid(C1_out_valid[0]),
            .in_data(C1_out_data[0]),
            .out_ready(),
        	.out_valid(C2_out_valid),
            .out_data(C2_out_data)
    );

    //C3
    conv_pooling_layer #(.N (N), .BitSize(BitSize), .ImageWidth(L2ImageWidth), .NumberOfK(C3NumberOfK), 
        .KernelBitSize(C3KernelBitSize), .CyclesPerPixel(L2CyclesPerPixel), .Stride(Stride), .kernel(C3kernel)) C3
		(
    		.clk(clk),
            .res_n(res_n),
        	.in_valid(C1_out_valid[1]),
            .in_data(C1_out_data[1]),
            .out_ready(),
        	.out_valid(C3_out_valid),
            .out_data(C3_out_data)
    );

    //C4
    conv_pooling_layer #(.N (N), .BitSize(BitSize), .ImageWidth(L2ImageWidth), .NumberOfK(C4NumberOfK), 
        .KernelBitSize(C4KernelBitSize), .CyclesPerPixel(L2CyclesPerPixel), .Stride(Stride), .kernel(C4kernel)) C4
		(
    		.clk(clk),
            .res_n(res_n),
        	.in_valid(C1_out_valid[2]),
            .in_data(C1_out_data[2]),
            .out_ready(),
        	.out_valid(C4_out_valid),
            .out_data(C4_out_data)
    );
  

endmodule