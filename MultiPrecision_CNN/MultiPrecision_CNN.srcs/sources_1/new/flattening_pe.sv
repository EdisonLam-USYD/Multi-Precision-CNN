// takes the in_data on the same cycle as the res_n (assuming in_valid is high)

// flattening_pe #(.BitSize(), .ImageSize()) flat_pe 
//    (.clk(), .res_n(), .in_valid(), .in_data(), .out_valid(), .out_ready(), .out_data(), .out_done());
module flattening_pe #(BitSize = 2, ImageSize = 9) 
    (
        input clk,
        input res_n,
        input in_valid,
        input [BitSize-1:0] in_data,

        output logic                                        out_valid,
        output logic                                        out_ready,
        output logic [(ImageSize)*BitSize-1:0] out_data,
        output logic out_done       // not sure if needed
    );

    logic [$clog2(ImageSize)-1:0] counter_r;
    logic [$clog2(ImageSize)-1:0] counter_c;

    logic [ImageSize-1:0][BitSize-1:0] out_data_c;
    
    assign out_data = out_data_c;

    always_comb begin
        counter_c = counter_r;
        out_data_c = '0;
        if (in_valid)
        begin
            out_data_c[ImageSize-1-counter_c] =  in_data;
            counter_c = (ImageSize - 1 != counter_r) ? counter_r + 1 : 0;
        end
    end

    always_ff @(posedge clk) begin
        if (!res_n)
        begin
            counter_r <= 0;
        end
        else
        begin
            counter_r <= counter_c;
        end
    end

endmodule