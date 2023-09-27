`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2023 22:14:21
// Design Name: 
// Module Name: convolution_stage
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

module switch #(NumberOfK = 1, CyclesPerPixel = 2)
		(
    		input 							clk,
            input                           res_n,
        	input 							in_valid,     // enable   
        	output logic[NumberOfK-1:0]     out_valid
      	
    );

	localparam ProcessingElements 	= NumberOfK/CyclesPerPixel;

    integer count_c;
    integer count_r;

    always_comb begin
        count_c     = count_r;
        out_valid   = '0;
        if(in_valid)
        begin
            out_valid[count_c+:ProcessingElements] = {ProcessingElements{1'b1}};
            count_c = (count_c + ProcessingElements) % NumberOfK;
        end
    end

    always_ff@(posedge clk) begin
        if(!res_n) begin
            count_r     <= '0;
        end
        else
        begin
            count_r     <= count_c;
        end
    end

endmodule