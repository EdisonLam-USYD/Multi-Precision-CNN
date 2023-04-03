`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2023 18:17:11
// Design Name: 
// Module Name: multiply_1Bit
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


module multiply_1Bit #(BitSize = 32)
    (
    input signed [BitSize-1:0] i_data,
    input i_prod,
    output logic [BitSize-1:0] o_data
    );
    
    always_comb begin
        if (i_prod) begin
            o_data = i_data;
        end 
        else begin
            o_data = BitSize'('b0);
        end
    end
endmodule
