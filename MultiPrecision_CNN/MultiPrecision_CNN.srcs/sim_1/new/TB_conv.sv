`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2023 18:33:34
// Design Name: 
// Module Name: TB_dotProduct
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

`define B 1
`define N 3
`define K 1
`define IW 4


module TB_dotProduct;

    logic [`K*(`N*`N)-1:0] in_kernel;
    logic [`B*(`N*`N)-1:0] in_conv;
   
    logic [1:0] out;
    logic [`B-1:0] max;

    logic [2:0][`IW-1:0] image;
    integer counter;
    logic clk;

    initial
    begin
        $monitor("@ %0t", $time);
        image = {{1, 0, 0, 1}, {1, 1, 1, 1}};
        counter = 0;
        clk = 0;
    end

    always begin
        #10
        counter = 1;
        clk = 1;
        
    end



    convolution_stage #(.NumberOfConvs(1), .N(3), .BitSize(2), .KernelBitSize(1), .ImageWidth(`IW)) conv_s 
        (.clk(), .res_n(), .in_valid(), .kernel(), .in_data(), .out_ready(), .out_valid(), .out_data());
endmodule