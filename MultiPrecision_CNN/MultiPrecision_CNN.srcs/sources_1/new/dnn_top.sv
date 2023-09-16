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

// dnn_top #(
//     .BitSize(), .M_W_BitSize(), .NumIn(), .MaxNumNerves(), .NumOfImages(),
//     .CyclesPerPixel(), .ImageSize(), .NumLayers(2), .LWB(`{4, 2}), .LNN(`{3, 3})
// ) dnn_inst (
//     .clk(), .res_n(), .in_valid(), .in_data(), .in_weights(), 
//     .out_ready(), .out_data(), .out_valid(), .out_done()
// )
module dnn_top 
#(
    BitSize = 8, M_W_BitSize = 16, NumIn = 4, NumLayers = 2, MaxNumNerves = 3, NumOfImages = 4,
    CyclesPerPixel = 4, ImageSize = 4)
(
    input clk,
    input res_n,
    input [NumOfImages-1:0] in_valid,
    input [NumIn-1:0][BitSize-1:0] in_data,
    // input 
    input [MaxNumNerves-1:0][M_W_BitSize-1:0] in_weights,

    output out_ready,
    output [LNN[0]-1:0][BitSize-1:0] out_data,
    output out_valid,
    output out_done
);

    // Parameters for loading in weights
    // parameter integer [NumLayers-1:0] w_b = `{4, 2};

    // it takes N number of cycles to load in the weights of each nerve layer 
    // where N is the number of outputs of the previous layer

    parameter integer LWB [NumLayers-1:0] = `{4, 2};        // LWB = Layer Weighted Bitsize
    parameter integer LNN [NumLayers-1:0] = `{3, 3};        // LNN = Layer Number of Nerves (i.e number of inputs to the next layer)

    logic fl_out_valid;
    logic [ImageSize-1:0][BitSize-1:0] fl_out_data;
    logic fl_out_ready;

    flattening_layer #(.Bitsize(BitSize), .ImageSize(ImageSize), .NumOfImages(NumOfImages), .NumOfInputs(NumIn), .CyclesPerPixel(CyclesPerPixel))
        f_layer0 (.clk(clk), .res_n(res_n), .in_valid(in_valid), .in_data(in_data), .out_ready(fl_out_ready), .out_valid(fl_out_valid), .out_data(fl_out_data));


    integer weight_timer_c;
    integer weight_timer_r;
    integer weight_counter_c;
    integer weight_counter_r;
    logic [NumLayers-1:0] weight_en; // hot encoding
    assign weight_en[NumLayers-1] = res_n;

    genvar i;
    generate 
        for (i = 0; i < NumLayers; i = i + 1) begin : layer
            logic nl_out_ready;
            logic nl_out_valid;
            logic nl_out_done;
            
            logic [LNN[NumLayers-1]-1:0][BitSize-1:0] nl_out;
            if (i == 0) begin
                // out_ready can be used to signal which array has not been loaded yet
                // implement in_start based on flattening layer?? - probably just hold the start for the known number of images
                systolic_array #(.BitSize(BitSize), .Weight_BitSize(LWB[NumLayers-1-i]), .M_W_BitSize(M_W_BitSize), .NumOfInputs(ImageSize), .NumOfNerves(LNN[NumLayers-1-i])) 
                    layer1 (.clk(clk), .res_n(weight_en[NumLayers-1-i]), .in_valid(fl_out_valid), .in_start(!fl_out_ready), .in_data(fl_out_data), .in_weights(in_weights[MaxNumNerves-1:-LNN[NumLayers-1-i]]), .in_partial_sum('0 /*in_partial_sum*/), 
                    .out_ready(nl_out_ready), .out_valid(nl_out_valid), .out_done(nl_out_done), .out_data(nl_out));

            end
            else begin
                // systolic_array #(.BitSize(BitSize), .Weight_BitSize(LWB[NumLayers-1-i]), .M_W_BitSize(M_W_BitSize), .NumOfInputs(LNN[NumLayers-i]), .NumOfNerves(LNN[NumLayers-1-i])) 
                systolic_array #(.BitSize(BitSize), .Weight_BitSize(LWB[NumLayers-1-i]), .M_W_BitSize(M_W_BitSize), .NumOfInputs(LLN[NumLayers-i]), .NumOfNerves(LNN[NumLayers-1-i])) 
                    layer1 (.clk(clk), .res_n(weight_en[NumLayers-1-i]), .in_valid(layer[i-1].nl_out_valid), .in_start(layer[i-1].nl_out_done), .in_data(layer[i-1].nl_out), .in_weights(in_weights[MaxNumNerves-1:-LNN[NumLayers-1-i]]), .in_partial_sum('0 /*in_partial_sum*/), 
                    .out_ready(nl_out_ready), .out_valid(nl_out_valid), .out_done(nl_out_done), .out_data(nl_out));

            end

            logic temp_out_ready;

            if (i == 0) begin
                assign temp_out_ready = nl_out_ready;
            end
            else begin
                assign temp_out_ready = nl_out_ready | layer[i-1].temp_out_ready;
            end
        end
        assign out_ready    = layer[NumLayers-1].temp_out_ready;
        assign out_valid    = layer[NumLayers-1].nl_out_valid;
        assign out_data     = layer[NumLayers-1].nl_out;
        assign out_done     = layer[NumLayers-1].nl_out_done;
    endgenerate

    //TODO: weight enable logic
    // only logic within this module is the loading in of weights
    always_comb begin
        weight_timer_c = weight_timer_r + 1;
        weight_counter_c = weight_counter_r;

        if (weight_counter_c == 0) begin
            if (weight_timer_c > ImageSize) begin
                weight_counter_c = weight_counter_c + 1;
                weight_counter_c = 0;
            end
        end
        else if (weight_counter_c < NumLayers) begin
            if (weight_timer_c > LNN[NumLayers - 1 - ]) begin
                weight_counter_c = weight_counter_c + 1;
                weight_counter_c = 0;
            end
        end

    end

    always_ff @(posedge clk) begin
        if (!res_n) begin
            weight_counter_r    <= 0;
            weight_timer_r      <= 0;
            weight_en[NumLayers-1] <= 1;

        end
        else begin
            weight_counter_r    <= weight_counter_c;
            weight_timer_r      <= weight_timer_c;
            
            if (weight_counter_c != weight_counter_r) begin
                weight_en       <= weight_en >> 1;
            end

        end
    end
    
endmodule