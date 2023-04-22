`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2023 14:01:09
// Design Name: 
// Module Name: relu
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


module relu #(BitSize = 32)
    (
        input [BitSize-1:0] in_data,
        output logic [BitSize-1:0] out_data
    );

    always_comb begin
        case (in_data[BitSize-1])
            1: out_data = 0;
            0: out_data = in_data;
        endcase
    end
endmodule
