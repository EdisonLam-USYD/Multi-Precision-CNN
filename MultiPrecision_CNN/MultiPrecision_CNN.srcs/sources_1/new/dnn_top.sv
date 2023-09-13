//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2023
// Design Name: 
// Module Name: convolution_buffer
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

// For testing, will manually have to edit stored weights and values
// details on array parameters: https://asic4u.wordpress.com/2016/01/23/passing-array-as-parameters/

module dnn_top #(BitSize = 8, M_W_BitSize = 16, NumIn = 4, NumOut = 6, NumLayers = 2, integer w_b[NumLayers] = `{4, 2})
(
    input clk,
    input res_n,
    input in_valid,
    input [NumIn-1:0][BitSize-1:0] in_data,

    output out_ready,
    output [NumOut-1:0][BitSize-1:0] out_data,
    output out_valid,
    output out_done
);

    // Parameters for loading in weights
    // parameter integer [NumLayers-1:0] w_b = `{4, 2};


    
endmodule