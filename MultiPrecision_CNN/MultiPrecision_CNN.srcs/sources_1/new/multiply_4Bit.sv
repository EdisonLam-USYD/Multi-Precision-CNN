`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2023 18:17:11
// Design Name: 
// Module Name: multiply_4Bit
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

// should be noted that the 4 bits in the kernel represent [-1:1]
module multiply_4Bit #(BitSize = 32, FixedPointPos = 0)
    (
    input signed [BitSize-1:0] i_data, // 32bit number
    input signed [3:0] i_prod, // in 2's complement fixed point
    output logic [BitSize-1:0] o_data
    );
    wire [2*BitSize-1:0] temp_out;
    assign temp_out = (i_data*i_prod) >>> FixedPointPos;
    assign o_data = temp_out[BitSize-1:0];

endmodule
