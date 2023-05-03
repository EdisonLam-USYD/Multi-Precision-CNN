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

module TB_conv;

    // logic [`K*(`N*`N)-1:0] in_kernel;
    // logic [`B*(`N*`N)-1:0] in_conv;
   
    // logic [1:0] out;

    // logic [`IW-1:0][`IW-1:0][`B-1:0] image;
    // integer counter;
    // logic clk;
    // logic res_n;
    // logic in_valid;
    // logic out_ready;
    // logic [2:0][`IW-1:0][`B-1:0] out_data;

    localparam BitSize = 4;
    localparam N = 3;
    localparam ImageWidth = 4;
    localparam K = 2;
    localparam NoK = 1;

    logic clk;
    logic res_n;
    logic in_valid;
    logic [BitSize-1:0] in_data;
    logic out_ready;
    logic out_valid;
    logic [BitSize-1:0] out_data;

    logic [ImageWidth*ImageWidth-1:0][BitSize-1:0] test_image;
    logic [BitSize-1:0] a;
    logic [BitSize-1:0] b;
    logic [BitSize-1:0] c;
    logic [BitSize-1:0] d;

    logic [NoK-1:0][N-1:0][N-1:0][K-1:0] kernels;
    
    convolution_stage #(.NumberOfK(NoK), .N(N), .BitSize(BitSize), .KernelBitSize(K), .ImageWidth(ImageWidth)) conv_s 
        (.clk(clk), .res_n(res_n), .in_valid(in_valid), .kernel(kernels[0]), .in_data(in_data), .out_ready(out_ready), .out_valid(out_valid), .out_data(out_data));

    logic [BitSize-1:0] pooling [N*N-1:0];
    assign {>>BitSize{pooling}} = conv_s.dot_product_in_c;
    
    initial
    begin
        // $monitor("@ %0t:\n\t\t%b %b\n %b", $time);
        a = 4'b0111;
        b = 4'b0010;
        c = 4'b1111;
        d = 4'b1000;
        test_image =   {a, b, b, c,
                        d, d, c, a,
                        c, b, d, d,
                        c, d, d, d};
        res_n = 0;
        clk = 1;
        #2
        res_n = 1;
        clk = 0;
        kernels[0] = {{2'b10, 2'b11, 2'b01}, {2'b01, 2'b01, 2'b01}, {2'b11, 2'b11, 2'b11}};
        
        $monitor("@ %0t:\tbuffer_r = %p\n\t\t\tpooling_data = %p\n\t\t\tout = %b, out_valid = %b", 
            $time, conv_s.data_stream_r, pooling, out_data, out_valid);

        for (int counter = 1; counter <= ImageWidth*ImageWidth; counter = counter) begin
            #10
            clk = 1;
            in_data = test_image[ImageWidth*ImageWidth - counter];
            in_valid = 1;
            #10
            clk = 0;
            if (out_ready) begin
                counter = counter + 1;
            end
          
        end
    end

    // logic [`B-1:0] in_data = image[counter/`IW][counter%`IW];

    // always begin
    //     #10
    //     res_n = 1;
    //     if (out_ready) 
    //     begin
    //         counter = counter + 1;
    //     end
    //     in_valid = 1;
    //     clk = 1;
    //     #10
    //     clk = 0;
        
    // end

endmodule