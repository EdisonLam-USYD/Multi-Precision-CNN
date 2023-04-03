`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2023 14:56:36
// Design Name: 
// Module Name: avg_pooling
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


module avg_pooling #(N = 3, BitSize = 8) (
    input signed [BitSize*(N*N)-1:0] i_data,
    input signed_check,
    output logic [BitSize-1:0] o_max
    );
endmodule
