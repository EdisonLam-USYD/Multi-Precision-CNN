`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2023 14:56:36
// Design Name: 
// Module Name: max_pooling
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

// does not work for N = 1
// can probably be upgraded by hardcoding the interactions for 3x3 inputs and so on (result found in 1 cycle)
// can also do things combinationally to do things in 1 cycle (for varying size)
//     rather than 1 cycle per item in input
// max_pooling #(.N(), .BitSize()) test_max_pooling (.i_data(), .o_max());
module max_pooling #(N = 3, BitSize = 8) (
    input signed [BitSize*(N*N)-1:0] i_data,
    output logic [BitSize-1:0] o_max
    );
    localparam int size = N*N;
    // localparam int depth = $clog2(size); // finding depth based on size of i_data
    
    // separating i_data into easier chunks
    wire [N*N-1:0][BitSize-1:0] i_data_layers;
    assign i_data_layers = i_data;
    
    integer i;
        
    always_comb begin
        o_max = BitSize'('b0);
        // scan through all the i_data and find max
        for (i = 0; i < size; i = i + 1) begin
//            $display("%d: %d", i, $signed(i_data_layers[i]));
            o_max = ($signed(o_max) < $signed(i_data_layers[i])) ? i_data_layers[i] :  o_max;
        end
    end
    
//    always_ff @(posedge clk) begin
//        if (reset) begin
//            current_max <= $signed(i_data[0]);
//            counter <= 1;
//            done <= 0;
//        end
//        else if (counter == N*N) begin 
//            if (current_max < $signed(i_data[counter])) current_max <=i_data[counter];
//            done <= 1;
//        end
//        else begin
//            if (current_max < $signed(i_data[counter])) current_max <= i_data[counter];
//            counter <= counter + 1;
            
//        end            
//    end
    
endmodule
