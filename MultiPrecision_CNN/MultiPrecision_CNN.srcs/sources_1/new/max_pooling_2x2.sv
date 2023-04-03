`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2023 13:28:51
// Design Name: 
// Module Name: max_pooling_2x2
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

// different from other one because it assumes it is a 2 x 2 and hard codes the multiplexors
module max_pooling_2x2 #(BitSize = 32)
    (
    input clk,
	input [BitSize-1:0] input1,
	input [BitSize-1:0] input2,
	input [BitSize-1:0] input3,
	input [BitSize-1:0] input4,
	input enable,
    output logic signed [BitSize-1:0] output1,
	output logic maxPoolingDone
    );
    
    logic [7:0] inputArray [0:7];
	 
	 //initial $readmemb("inputArray.txt", inputArray, 0, 7);
	
//	logic [BitSize-1:0] initialMax = {1, {(BitSize - 1) {0}}};
    localparam initialMax = {1, {(BitSize - 1) {0}}};
	logic [BitSize-1:0] tempOutput;
	
	always @ (posedge clk) begin
		if(enable) begin
			if($signed(initialMax) < $signed(input1)) begin
				if($signed(input2) < $signed(input1)) begin
					if($signed(input3) < $signed(input1)) begin
						if($signed(input4) < $signed(input1)) begin
							output1 <= input1;
							maxPoolingDone <= 1;
						end
						else begin
							output1 <= input4;
							maxPoolingDone <= 1;
						end
					end
					else begin
						if($signed(input3) < $signed(input4)) begin
							output1 <= input4;
							maxPoolingDone <= 1;
						end
						else begin
							output1 <= input3;
							maxPoolingDone <= 1;
						end
					end
				end
				else begin
					if($signed(input3) < $signed(input2)) begin
						if($signed(input4) < $signed(input2)) begin
							output1 <= input2;
							maxPoolingDone <= 1;
						end
						else begin
							output1 <= input4;
							maxPoolingDone <= 1;
						end
					end
					else begin
						if($signed(input3) < $signed(input4)) begin
							output1 <= input4;
							maxPoolingDone <= 1;
						end
						else begin
							output1 <= input3;
							maxPoolingDone <= 1;
						end
					end
				end
			end
			else begin
				output1 <= initialMax;
				maxPoolingDone <= 1;
			end
		end
		else begin
			output1 <= 0;
			maxPoolingDone <= 0;
		end
	end
endmodule
