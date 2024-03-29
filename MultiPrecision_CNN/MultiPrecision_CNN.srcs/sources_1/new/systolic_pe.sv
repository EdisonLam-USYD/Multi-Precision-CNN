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

// systolic processing element, used for matrix multiplication within layers and hidden layers to avoid fan-out
// systolic_pe #(.BitSize(), .Weight_BitSize(), .M_W_BitSize()) s_block (.clk(clk), .res_n(), .en_l_b(), .in_a(), .in_b(), .in_partial_sum(), .out_a(), .out_b(), .out_partial_sum());
module systolic_pe #(BitSize = 8, M_W_BitSize = 8, Weight_BitSize = 8)
    (
        input                               clk,
        input                               res_n,
        input                               in_valid,
        input                               en_l_b,              // loads weight on high and passes on the current weight
        input [BitSize-1:0]                 in_a,
        input [M_W_BitSize-1:0]             in_b,               // actual value can be stored based on Weight_BitSize
        // input                               in_w_en,
        input [BitSize-1:0]                 in_partial_sum,
        output logic [BitSize-1:0]          out_a,
        output logic [M_W_BitSize-1:0]      out_b,
        output logic [BitSize-1:0]          out_partial_sum
    );

    logic   [Weight_BitSize-1:0]    stored_b;
    logic   [Weight_BitSize-1:0]    stored_b_c;
    wire    [BitSize-1:0]           out_value;
    wire    [BitSize-1:0]           multi_val;

    always_ff @(posedge clk) begin
        if (!res_n) begin
            stored_b                <= 'b0;
            out_partial_sum         <= 'b0;
            out_a                   <= 'b0;
        end
        else begin
            stored_b <= stored_b_c;
            if (in_valid) begin
                out_partial_sum     <= out_value;
                out_a               <= in_a;
            end
            // out_b                   <= in_b;
        end
        // if (in_w_en) begin
        out_b                   <= in_b;
        // end
        // $display("in_a:%b, in_b:%b, stored_b:%b, in_ps:%b, out: %b", in_a, in_b, stored_b, in_partial_sum, out_partial_sum);
    end

    assign out_value = in_partial_sum + multi_val;
    assign stored_b_c = (en_l_b) ? out_b[Weight_BitSize-1:0] : stored_b;

    generate 
        if (Weight_BitSize == 1) begin
            multiply_1Bit #(.BitSize(BitSize)) multi (
                                        .in_data(in_a),
                                        .i_prod(stored_b_c),
                                        .out_data(multi_val)
                                        );
        end
        else if (Weight_BitSize == 2) begin
            multiply_2Bit #(.BitSize(BitSize)) multi (
                                        .in_data(in_a),
                                        .i_prod(stored_b_c),
                                        .out_data(multi_val)
                                        );
        end
        else if (Weight_BitSize == 4) begin
            multiply_4Bit #(.BitSize(BitSize), .FixedPointPos()) multi (
                                        .in_data(in_a),
                                        .i_prod(stored_b_c),
                                        .out_data(multi_val)
                                        );
        end
        else if (Weight_BitSize == 8) begin
            multiply_8Bit #(.BitSize(BitSize), .FixedPointPos()) multi (
                                        .in_data(in_a),
                                        .i_prod(stored_b_c),
                                        .out_data(multi_val)
                                        );
        end
    endgenerate 
endmodule
