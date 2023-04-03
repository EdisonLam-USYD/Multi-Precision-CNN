`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Edison Lam
// 
// Create Date: 26.03.2023 16:32:27
// Design Name: 
// Module Name: dot_NxN
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

// testing for kernel precision of 1 bit
// dot_NxN #(.N(3), .BitSize(8), .KernelBitSize(1), .SumDepth(32)) test1 (.kernel(), .i_data(), .o_data(), .sum());
module dot_NxN #(N = 3, BitSize=2, KernelBitSize = 4, SumDepth = 32)
    (
    input [KernelBitSize*(N*N)-1:0] kernel,
    input signed [BitSize*(N*N)-1:0] i_data,
    output logic [BitSize*(N*N)-1:0] o_data,
    output logic [SumDepth-1:0] sum // not implemented yet
    );
    
//    logic [N*N-1:0] in_shell;   // ? x ? matrix from i_data (i.e. image)
//    logic [N*N-1:0][BitSize-1:0] pooling;    // 
    logic [N*N-1:0][KernelBitSize-1:0] kernel_layers;
    logic [N*N-1:0][BitSize-1:0] i_data_layers;
    logic [N*N-1:0][BitSize-1:0] o_data_layers;
    
    assign {>>KernelBitSize{kernel_layers}} = {kernel};
    assign {>>BitSize{i_data_layers}} = {i_data};
    assign o_data = {>>{o_data_layers}};
    
    genvar i;
    generate 
        if (KernelBitSize == 1) begin
            for (i = 0; i < N*N; i= i + 1) begin : _1BitDotProduct
                multiply_1Bit #(.BitSize(BitSize)) multi (
                                            .i_data(i_data_layers[i]),
                                            .i_prod(kernel_layers[i]),
                                            .o_data(o_data_layers[i])
                                            );
            end 
        end
        else if (KernelBitSize == 2) begin
            // not implemented yet
            for (i = 0; i < N*N; i= i + 1) begin : _2BitDotProduct
                multiply_2Bit #(.BitSize(BitSize)) multi (
                                            .i_data(i_data_layers[i]),
                                            .i_prod(kernel_layers[i]),
                                            .o_data(o_data_layers[i])
                                            );
            end 
        end
        else if (KernelBitSize == 4) begin
            // not implemented yet
        end
        else if (KernelBitSize == 8) begin
            // not implemented yet
        end
        
    endgenerate 
    
    always_comb begin
        sum = 'b0;
        for (int i = 0; i < BitSize*(N*N); i = i + 1) begin
            sum = sum + o_data[i];
        end
    end

endmodule
