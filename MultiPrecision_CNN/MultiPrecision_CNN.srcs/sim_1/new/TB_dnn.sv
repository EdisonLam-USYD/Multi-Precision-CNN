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

module TB_dnn;
    localparam BitSize          = 4;
    // localparam ImageSize        = 2; 
    // localparam NumOfImages      = 4;
    // localparam NumOfPEPerInput  = 1;
    // localparam NumOfInputs      = 2;
    // localparam CyclesPerPixel   = 2;
    localparam M_W_BitSize      = 4;
    localparam bit [4:0] a [4:0] = '{2, 4, 6, 8, 10};

    logic clk;
    logic res_n;
    logic [NumOfImages-1:0] in_valid;
    logic [NumOfInputs-1:0][BitSize-1:0] in_data;

    logic out_ready;
    logic out_valid;

    dnn_top #(
        .BitSize(BitSize), .M_W_BitSize(M_W_BitSize), .NumIn(1), .MaxNumNerves(3), .NumOfImages(2),
        .CyclesPerPixel(1), .ImageSize(4), .NumLayers(2), .LWB(`{4, 2}), .LNN(`{3, 3})
    ) dnn_inst (
        .clk(clk), .res_n(res_n), .in_valid(in_valid), .in_data(in_data), .in_weights(), 
        .out_ready(), .out_data(), .out_valid(), .out_done()
    );

    // testing array parameters:
    initial begin
        for (int i = 0; i < 5; i = i + 1) begin
            $display("i = %d: a[i] = %d", i, a[i]);
        end
    end
endmodule