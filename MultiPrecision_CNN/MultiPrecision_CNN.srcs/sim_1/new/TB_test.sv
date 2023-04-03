`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2023 20:43:24
// Design Name: 
// Module Name: TB_test
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


module TB_test;
    initial begin
    static bit [2:0] packed_array = 3'b011;
    static bit       unpacked_array[3];
 
    {>>{unpacked_array}} = packed_array;
    end
 
endmodule
