// takes the in_data on the same cycle as the res_n (assuming in_valid is high)

// flattening_pe #(.BitSize(), .ImageSize(), .Delay()) flat_pe 
//     (.clk(), .res_n(), .in_valid(), .in_data(), .out_valid(), .out_data(), .out_done());
module flattening_pe #(BitSize = 2, ImageSize = 9, Delay = 0) 
    (
        input clk,
        input res_n,
        input in_valid,
        input [BitSize-1:0] in_data,

        output logic                                        out_valid,
        // output logic                                        out_ready, // does not seem necessary
        output logic [(ImageSize)*BitSize-1:0] out_data,
        output logic out_done       // not sure if needed
    );

    logic [$clog2(ImageSize + Delay)-1:0] counter_r;
    logic [$clog2(ImageSize + Delay)-1:0] counter_c;

    logic [ImageSize-1:0][BitSize-1:0] out_data_c;
    logic in_data_c;
    
    assign out_data = out_data_c;

    always_comb begin
        counter_c = counter_r;
        out_data_c = '0;
        out_done = 0;
        if (in_valid)
        begin
            if (counter_c >= Delay) out_data_c[ImageSize-1-counter_c] =  in_data_c;
            // counter_c = (ImageSize - 1 != counter_r) ? counter_r + 1 : 0;
            counter_c = counter_r + 1;
            out_done = (counter_c >= ImageSize + Delay) ? 1 : 0;
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

    genvar i;
    generate
        if (Delay == 0)
            assert in_data_c = in_data;
        else 
        begin
            for (i = 0; i <= Delay; i = i + 1)
            begin : s_del
                if (i < Delay)
                begin
                    logic [BitSize-1:0] buffer;
                end

                if (i == 0)
                begin
                    always_ff @(posedge clk) 
                    begin
                        if (!res_n) s_del[i].buffer <= '0;
                        else
                        begin
                            if (in_valid) s_del[i].buffer <= in_data;
                        end
                    end
                end
                else if (i < Delay)
                begin
                    always_ff @(posedge clk) 
                    begin
                        if (!res_n) s_del[i].buffer <= '0;
                        else
                        begin
                            if (in_valid) s_del[i].buffer <= s_del[i-1].buffer;
                        end
                    end
                end
                else 
                begin
                    assert in_data_c = s_del[i-1].buffer;
                end
            end
        end
    endgenerate

endmodule