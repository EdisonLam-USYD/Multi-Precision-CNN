`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2023 21:05:38
// Design Name: 
// Module Name: TB_nerveLayers
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


module TB_nerveLayers;

    localparam BitSize = 4;
    localparam Weight_BitSize = 2;
    localparam NumOfInputs = 2;
    localparam NumOfNerves = 2;
    localparam Height = 4;

    logic                                   clk;
    logic                                   res_n;
    logic                                   in_valid;
    logic                                   in_start;
    logic [NumOfInputs*BitSize-1:0]         in_data;
    logic [NumOfNerves*BitSize-1:0]         in_weights;
    logic [NumOfNerves*BitSize-1:0]         in_partial_sum;

    logic                            out_ready;
    logic                            out_valid;
    logic                            out_done;
    logic [NumOfNerves*BitSize-1:0]              out_data;

    systolic_array #(.BitSize(BitSize), .Weight_BitSize(Weight_BitSize), .NumOfInputs(NumOfInputs), .NumOfNerves(NumOfNerves)) 
        layer1 (.clk(clk), .res_n(res_n), .in_valid(in_valid), .in_start(in_start), .in_data(in_data), .in_weights(in_weights), .in_partial_sum(in_partial_sum), 
        .out_ready(out_ready), .out_valid(out_valid), .out_done(out_done), .out_data(out_data));

    logic [NumOfInputs-1:0][NumOfNerves-1:0][BitSize-1:0] weights;
    logic [Height:0][NumOfInputs-1:0][BitSize-1:0] a_matrix;
    logic [BitSize-1:0] a;
    logic [BitSize-1:0] b;
    logic [BitSize-1:0] c;
    logic [BitSize-1:0] d;

    logic [BitSize-1:0] aaaaaaa;
    logic [BitSize-1:0] bbbbbbb;
    logic [BitSize-1:0] ccccccc;
    logic [BitSize-1:0] ddddddd;

    initial begin
        $monitor("@%0t: \n\tin_w: %b\n\tin_b: %b, %b, %b, %b\n\tout_b: %b, %b, %b, %b\n\tstored weights: %b, %b, %b, %b\n\tin_valid: %b, in_start: %b, t_in_data: %b\n\tin_a: %b, %b, %b, %b\n\tmulti_val: %b, %b, %b, %b\n\tout_ps:%b, %b, %b, %b\n\tout_array = %b, out_done: %b, out_valid: %b\n\tdone_check_timeline: %b", $time, layer1.in_w,
        layer1.si[0].sj[0].genblk1.s_block.in_b, layer1.si[0].sj[1].genblk1.s_block.in_b, layer1.si[1].sj[0].genblk1.s_block.in_b, layer1.si[1].sj[1].genblk1.s_block.in_b,
        layer1.si[0].sj[0].out_b, layer1.si[0].sj[1].out_b, layer1.si[1].sj[0].out_b, layer1.si[1].sj[1].out_b,
        layer1.si[0].sj[0].genblk1.s_block.stored_b_c, layer1.si[0].sj[1].genblk1.s_block.stored_b_c, layer1.si[1].sj[0].genblk1.s_block.stored_b_c, layer1.si[1].sj[1].genblk1.s_block.stored_b_c,
        layer1.in_valid, layer1.in_start, layer1.t_in_data,
        layer1.si[0].sj[0].genblk1.s_block.out_a, layer1.si[0].sj[1].genblk1.s_block.out_a, layer1.si[1].sj[0].genblk1.s_block.out_a, layer1.si[1].sj[1].genblk1.s_block.out_a,
        layer1.si[0].sj[0].genblk1.s_block.multi_val, layer1.si[0].sj[1].genblk1.s_block.multi_val, layer1.si[1].sj[0].genblk1.s_block.multi_val, layer1.si[1].sj[1].genblk1.s_block.multi_val,
        layer1.si[0].sj[0].out_ps, layer1.si[0].sj[1].out_ps, layer1.si[1].sj[0].out_ps, layer1.si[1].sj[1].out_ps,
        layer1.out_array, layer1.out_done, layer1.out_valid, layer1.done_check);

        a = 4'b0011;
        b = 4'b0010;
        c = 4'b0001;
        d = 4'b0000;
        weights =  {{c, d},
                    {d, c}};
        aaaaaaa = 4'b0111;
        bbbbbbb = 4'b0110;
        ccccccc = 4'b0101;
        ddddddd = 4'b0100;
        a_matrix = {{{aaaaaaa}, {4'b0000}},
                    {{bbbbbbb}, {aaaaaaa}},
                    {{ccccccc}, {bbbbbbb}},
                    {{ddddddd}, {ccccccc}},
                    {{4'b0000}, {ddddddd}}};
        res_n = 0;
        clk = 0;
        in_weights = weights[0];
        in_partial_sum = 'b0;
        in_data = 'b0;
        in_start = 'b0;
        in_valid = 1;
        #5
        clk = 1;
        #5
        res_n = 1;
        clk = 0;
        // loading in weights
        for(int i = 1; i < NumOfInputs; i = i + 1) begin
            #10
            in_weights = weights[i%2];
            clk = 1;
            #10
            clk = 0;
        end
        // TODO: input data
        for(int i = 0; i < Height + 1; i = i) begin
            #10
            in_data = a_matrix[Height-i];
            in_start = (i < Height) ? 1 : 0;
            clk = 1;
            #10
            clk = 0;
            i = (out_ready) ? i + 1 : i;
        end
        in_data = 'b0;
        for(int i = 0; i < 5; i = i + 1) begin
            #10
            clk = 1;
            #10
            clk = 0;
        end

    end

endmodule
