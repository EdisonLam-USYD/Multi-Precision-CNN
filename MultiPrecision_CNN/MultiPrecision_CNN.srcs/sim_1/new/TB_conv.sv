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

`define B 2
`define N 3
`define K 2
`define IW 4
`define NoK 1


module TB_conv;

    logic [`K*(`N*`N)-1:0] in_kernel;
    logic [`B*(`N*`N)-1:0] in_conv;
   
    logic [1:0] out;

    logic [2:0][`IW-1:0][`B-1:0] image;
    logic [`NoK-1:0][`N-1:0][`N-1:0][`k-1:0] kernels;
    integer counter;
    logic clk;
    logic res_n;
    logic in_valid;
    logic out_ready;
    logic [2:0][`IW-1:0][`B-1:0] out_data;

    initial
    begin
        // $monitor("@ %0t:\n\t\t%b %b\n %b", $time);
        image = {{1, 0, 0, 1}, {1, 1, 1, 1}, {0, 1, 1, 1}};
        counter = 0;
        clk = -1;
        res_n = 0;
        kernel[0] = {{'b10, 'b11, 'b01}, {'b01, 'b01, 'b01}, {'b11, 'b11, 'b11}};
    end

    logic [`B-1:0] in_data = image[counter/`IW][counter%`IW];
    assign 

    always begin
        #10
        res_n = 1;
        counter = counter + 1;
        in_valid = 1;
        clk = 1;
        #10
        clk = 0;
        
    end



    convolution_stage #(.NumberOfK(`NoK), .N(`N), .BitSize(`B), .KernelBitSize(`K), .ImageWidth(`IW)) conv_s 
        (.clk(clk), .res_n(res_n), .in_valid(in_valid), .kernel(kernel[0]), .in_data(in_data), .out_ready(out_ready), .out_valid(out_valid), .out_data(out_data));
endmodule