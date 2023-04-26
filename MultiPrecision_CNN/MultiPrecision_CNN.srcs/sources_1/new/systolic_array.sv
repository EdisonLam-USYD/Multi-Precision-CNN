`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2023 18:08:00
// Design Name: 
// Module Name: stolic_pe
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



// systolic array, used for matrix multiplication within layers and hidden layers to avoid fan-out and allows for pipelining
// need to implement number of inputs and number of nerves instead of block size as num input != num outputs all the time
// in_data must be transposed to obtain the correct values

/*
How things operate:
assuming you have matrix a * b, where a has m x n dimensions and b has n x p (rows x column)
m is the number of input images (height) but does not matter for this function as function will constantly output while in_valid (i am assuming it will be 1)
n is the number of inputs and their corresponding weights
p is the number of nerves within that layer

this module first loads n weights into their corresponding block and then turns on out_ready
the input of this module should be the diagonals of the matrix a and the output is the diagonals of the matrix c, 
    meaning these arrays can be linked up to one another to simulate each layer
the input is transposed and then inputted into the array
i.e if a was:
[00, 01, 02, 03]
[10, 11, 12, 13]
[20, 21, 22, 23]
[30, 31, 32, 33]

in_data needs to be
[00, --, --, --]
[10, 01, --, --]
[20, 11, 02, --]
[30, 21, 12, 03]
[--, 31, 22, 13]
[--, --, 32, 23]
[--, --, --, 33]


module takes m + n + p cycles to complete 
*/

// to do next: implement an enable which properly switches the module on, as currently, all operations run using in_valid, when in_valid is off, all operations are halted

// systolic_array #(.BitSize(BitSize), .Weight_BitSize(Weight_BitSize), .NumOfInputs(NumOfInputs), .NumOfNerves(NumOfNerves)) 
//         layer1 (.clk(), .res_n(), .in_start(), .in_valid(), .in_data(), .in_weights(), .in_partial_sum(), .out_ready(), .out_valid(), .out_done(), .out_data())
module systolic_array #(BitSize = 8, Weight_BitSize = 2, NumOfInputs = 2, NumOfNerves = 2)
    (
        input                                   clk,
        input                                   res_n,
        input                                   in_start,           // signals when out_done and out_valid should stop, hold start for 1 cycle per height (m)
        input                                   in_valid,           // should always be on unless blockage
        input [NumOfInputs*BitSize-1:0]         in_data,            // (assuming m = 1)
        input [NumOfNerves*BitSize-1:0]         in_weights,               // actual value can be stored based on Weight_BitSize
        input [NumOfNerves*BitSize-1:0]         in_partial_sum,     // some can have biases

        output logic                            out_ready,
        output logic                            out_valid,
        output logic                            out_done,
        output logic [NumOfNerves*BitSize-1:0]  out_data
    );

    // takes BlockSize cycles to load in all b values
    logic en_l_b;
    integer counter_w;                          // counts the loading of the weights for each of the nerves (NumOfInputs times)

    logic [NumOfInputs-1:0][BitSize-1:0] t_in_data;    // transformed version of in_data for easier input
    logic [NumOfNerves-1:0][BitSize-1:0] in_w;
    logic [NumOfNerves-1:0][BitSize-1:0] in_pa;
    logic [NumOfNerves-1:0][BitSize-1:0] out_array;
    logic [2*NumOfInputs-1:0] done_check;

    assign t_in_data = in_data;
    assign in_w = in_weights;
    assign in_pa = in_partial_sum;
    assign out_data = out_array;
    assign out_done = done_check[NumOfInputs];
    assign out_valid = done_check[2*NumOfInputs-1:NumOfInputs] != 0;

    always_ff @(posedge clk) begin
        if (!res_n) begin
            counter_w       <= 'b0;
            done_check[0]   <= 'b0;
        end
        else begin
            if (counter_w < NumOfInputs + 1) begin
                counter_w   <= counter_w + 1;
            end
            done_check[0]   <= in_start;
        end
    end 

    // condition for when there is output: counter_in_r > NumOfInputs + NumOfNerves
    always_comb begin
        en_l_b = (counter_w + 1 == NumOfInputs) ? 1'b1 : 1'b0;
        out_ready = (counter_w + 1 >= NumOfInputs) ? 1'b1 : 1'b0;        // out_ready is on when all weights are loaded in
        // out_valid = 'b0;
        // $display("............out_valid: %b | %b", done_check[NumOfNerves+:NumOfInputs+1], out_valid);
        // out_valid = (done_check[NumOfNerves+:NumOfInputs+1] != 3'b0) ? 1 : 0;
        // for (int i = 0; i < NumOfInputs + 1; i = i + 1) begin
        //     $display("............out_valid: %b | %b", done_check[NumOfNerves+:NumOfInputs+1], out_valid);
        //     out_valid = (done_check[NumOfNerves+i] == 1'b1 || out_valid == 1'b1) ? 1'b1 : 1'b0;
        // end
    end

    genvar i;
    genvar j;
    generate;
        for (i = 0; i < NumOfInputs; i = i + 1) begin : si            // row      -> corresponds to the number of inputs
            for (j = 0; j < NumOfNerves; j = j + 1) begin :sj         // column   -> corresponds to the number of nerves in layer
                logic [BitSize-1:0]          out_a;
                logic [BitSize-1:0]          out_b;
                logic [BitSize-1:0]          out_ps;
                if (i == 0 && j == 0) begin
                    systolic_pe #(.BitSize(BitSize), .Weight_BitSize(Weight_BitSize)) s_block 
                        (.clk(clk), .res_n(res_n), .in_valid(in_valid), .en_l_b(en_l_b), .in_a(t_in_data[NumOfInputs-1]), .in_b(in_w[NumOfNerves-1-j]), 
                        .in_partial_sum(in_pa[NumOfNerves-1-j]), .out_a(si[i].sj[j].out_a), .out_b(si[i].sj[j].out_b), .out_partial_sum(si[i].sj[j].out_ps));
                end
                else if (i == 0) begin
                    systolic_pe #(.BitSize(BitSize), .Weight_BitSize(Weight_BitSize)) s_block 
                        (.clk(clk), .res_n(res_n), .in_valid(in_valid), .en_l_b(en_l_b), .in_a(si[i].sj[j-1].out_a), .in_b(in_w[NumOfNerves-1-j]), 
                        .in_partial_sum(in_pa[NumOfNerves-1-j]), .out_a(si[i].sj[j].out_a), .out_b(si[i].sj[j].out_b), .out_partial_sum(si[i].sj[j].out_ps));
                end
                else if (j == 0) begin
                    systolic_pe #(.BitSize(BitSize), .Weight_BitSize(Weight_BitSize)) s_block 
                        (.clk(clk), .res_n(res_n), .in_valid(in_valid), .en_l_b(en_l_b), .in_a(t_in_data[NumOfInputs-1-i]), .in_b(si[i-1].sj[j].out_b), 
                        .in_partial_sum(si[i-1].sj[j].out_ps), .out_a(si[i].sj[j].out_a), .out_b(si[i].sj[j].out_b), .out_partial_sum(si[i].sj[j].out_ps));
                end
                else begin
                    systolic_pe #(.BitSize(BitSize), .Weight_BitSize(Weight_BitSize)) s_block 
                    (.clk(clk), .res_n(res_n), .in_valid(in_valid), .en_l_b(en_l_b), .in_a(si[i].sj[j-1].out_a), .in_b(si[i-1].sj[j].out_b), 
                    .in_partial_sum(si[i-1].sj[j].out_ps), .out_a(si[i].sj[j].out_a), .out_b(si[i].sj[j].out_b), .out_partial_sum(si[i].sj[j].out_ps));
                end
                // systolic_pe #(.BitSize(BitSize), .Weight_BitSize(2)) s_block 
                //     (.clk(clk), .res_n(res_n), .in_valid(in_valid), .en_l_b(en_l_b), .in_a(si[i].sj[j].in_a), .in_b(si[i].sj[j].in_b), 
                //     .in_partial_sum(si[i].sj[j].in_ps), .out_a(si[i].sj[j].out_a), .out_b(si[i].sj[j].out_b), .out_partial_sum(si[i].sj[j].out_ps));
            end
        end
    endgenerate

    // assigning output
    generate;
        for (genvar k = 0; k < NumOfNerves; k = k + 1) begin : sk 
            assign out_array[NumOfNerves-k-1] = si[NumOfInputs-1].sj[k].out_ps;
        end
    endgenerate

    // generating counter pipeline to show out_done
    generate;
        for (genvar l = 1; l < 2*NumOfInputs; l = l + 1) begin : start_pl
            always_ff @(posedge clk) begin
                if (!res_n) begin 
                    done_check[l] <= 1'b0;
                end
                else if (in_valid) begin
                    done_check[l] <= done_check[l-1];
                end
            end
        end
    endgenerate

    
endmodule
