`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Edison Lam
// 
// Create Date: 27.03.2023 14:17:20
// Design Name: Pooling 
// Module Name: MaxAv_Pooling
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

`define MAX 1
`define AVG 0

module MaxAv_Pooling #(MODE = `MAX, N = 3, BitSize = 8) (
    input clk,
    input reset,
    input [N*N-1:0][BitSize-1:0] i_data,
    output logic [BitSize-1:0] o_data,
    output logic done
    );
    
    
    generate
        // assuming mode = 1, max pooling is enabled
        if (MODE == `MAX) begin
            // TODO
//            if (N == 1) o_data = i_data[0];
            max_pooling #(.N(), .BitSize()) test_max_pooling (.clk(), .reset(), .i_data(), .o_max());
        end
        // assuming mode = 0, average pooling is enabled
        else if (MODE == `AVG) begin
            // TODO
        end
    endgenerate 
    

    
endmodule
