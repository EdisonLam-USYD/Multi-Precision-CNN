//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2023
// Design Name: 
// Module Name: convolution_buffer
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

// For testing, will manually have to edit stored weights and values
// details on array parameters: https://asic4u.wordpress.com/2016/01/23/passing-array-as-parameters/

// LWB = Layer Weighted Bitsize
// LNN = Layer Number of Nerves (i.e number of inputs to the next layer)

module dnn_top 
#(
    BitSize = 8, M_W_BitSize = 16, NumIn = 4, NumOut = 6, NumLayers = 2, MaxNumNerves = 3, NumOfImages = 4,
    integer LWB[NumLayers] = `{4, 2}, integer LNN[NumLayers] = `{3, 3})
(
    input clk,
    input res_n,
    input in_valid,
    input [NumIn-1:0][BitSize-1:0] in_data,
    input [MaxNumNerves-1:0][M_W_BitSize] in_weights,

    output out_ready,
    output [NumOut-1:0][BitSize-1:0] out_data,
    output out_valid,
    output out_done
);

    // Parameters for loading in weights
    // parameter integer [NumLayers-1:0] w_b = `{4, 2};

    // it takes N number of cycles to load in the weights of each nerve layer 
    // where N is the number of outputs of the previous layer

    integer weight_timer_c;
    integer weight_timer_r;
    logic [NumLayers-1:0] weight_en; // hot encoding

    flattening_layer #(.Bitsize(BitSize), .ImageSize(NumIn), .NumOfImages(NumOfImages), .NumOfPEPerInput(), .NumOfInputs(), .CyclesPerPixel())
        f_layer0 (.clk(), .res_n(), .in_valid(), .in_data(), .out_ready(), .out_valid(), .out_data());

    genvar i;
    genvar j;
    generate 
        for (i = 0; i < NumLayers; i = i + 1) begin : layer
            if (i = 0) begin
                logic [LNN[NumLayers-1]-1:0][BitSize-1:0] out;
                logic 
                systolic_array #(.BitSize(BitSize), .Weight_BitSize(LWB[NumLayers-1-i]), .M_W_BitSize(M_W_BitSize), .NumOfInputs(NumOfInputs), .NumOfNerves(NumOfNerves)) 
            layer1 (.clk(clk), .res_n(res_n), .in_valid(), .in_start(), .in_data(in_data), .in_weights(in_weights), .in_partial_sum(in_partial_sum), 
            .out_ready(out_ready), .out_valid(out_valid), .out_done(), .out_data(out_data));

            end
            else begin

            end
        end
    endgenerate


    
endmodule