`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2023 18:17:11
// Design Name: 
// Module Name: multiply_2Bit
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


module multiply_2Bit #(BitSize = 32)
    (
    input [BitSize-1:0] i_data, // 32bit number
    input signed [1:0] i_prod, // in 2's complement
    output logic [BitSize-1:0] o_data
    );
    // 1st bit is signed bit, 2nd is whether it is 1 or 0
    assign o_data = (i_prod[0]) ? ((i_prod[1]) ? i_data: ~i_data+1) : 0;
    // always_comb begin
    //     case (i_prod) 
    //         2'b00: o_data <= BitSize'('b0);
    //         2'b01: o_data <= i_data;
    //         2'b11: o_data <= ~i_data + 1; // -1
    //         2'b10: o_data <= (~i_data + 1) << 1; // -2
    //     endcase
    // end
endmodule
