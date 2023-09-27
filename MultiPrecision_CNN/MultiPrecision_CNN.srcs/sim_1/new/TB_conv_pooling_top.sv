module TB_conv_pooling_top;

    localparam BitSize = 4;
    localparam N = 3;
    localparam ImageWidth = 4;
    //localparam K = 2;
    //localparam NoK = 4;
    //localparam CyclesPerPixel = 2;
    // localparam ProcessingElements = NoK/CyclesPerPixel;

    localparam C1NumberOfK      = 3;
    localparam C1KernelBitSize  = 2;
    localparam C1CyclesPerPixel = 1;
    
    localparam C2NumberOfK      = 4;
    localparam C2KernelBitSize  = 2;
    localparam C2CyclesPerPixel = 2;

    localparam C3NumberOfK      = 2;
    localparam C3KernelBitSize  = 2;
    localparam C3CyclesPerPixel = 2;

    localparam C4NumberOfK      = 2;
    localparam C4KernelBitSize  = 2;
    localparam C4CyclesPerPixel = 2;

    logic                                           clk;
    logic                                           res_n;
    logic                                           in_valid;
    logic [BitSize-1:0]                             in_data;
    logic                                           out_ready;
    
    logic [C2NumberOfK-1:0]                                     C2_out_valid;
    logic [C2NumberOfK/C2CyclesPerPixel-1:0][BitSize-1:0]       C2_out_data;
    logic [C3NumberOfK-1:0]                                     C3_out_valid;
    logic [C3NumberOfK/C3CyclesPerPixel-1:0][BitSize-1:0]       C3_out_data;
    logic [C4NumberOfK-1:0]                                     C4_out_valid;
    logic [C4NumberOfK/C4CyclesPerPixel-1:0][BitSize-1:0]       C4_out_data;        

    logic [ImageWidth*ImageWidth-1:0][BitSize-1:0]  test_image;
    logic [BitSize-1:0]                             a;
    logic [BitSize-1:0]                             b;
    logic [BitSize-1:0]                             c;
    logic [BitSize-1:0]                             d;

    logic [C1NumberOfK-1:0][N-1:0][N-1:0][C1KernelBitSize-1:0] C1kernel;
    logic [C2NumberOfK-1:0][N-1:0][N-1:0][C2KernelBitSize-1:0] C2kernel;
    logic [C3NumberOfK-1:0][N-1:0][N-1:0][C3KernelBitSize-1:0] C3kernel;    
    logic [C4NumberOfK-1:0][N-1:0][N-1:0][C4KernelBitSize-1:0] C4kernel;



    conv_pooling_top #(.N(N), .BitSize(BitSize), .ImageWidth(ImageWidth), 
        .C2NumberOfK(C2NumberOfK), .C3NumberofK(C3NumberOfK), .C4NumberofK(C4NumberOfK),
        .C1KernelBitSize(C1KernelBitSize), .C2KernelBitSize(C2KernelBitSize), .C3KernelBitSize(C3KernelBitSize), .C4KernelBitSize(C4KernelBitSize),
        .C1CyclesPerPixel(C1CyclesPerPixel), .C2CyclesPerPixel(C2CyclesPerPixel), .C3CyclesPerPixel(C3CyclesPerPixel), .C4CyclesPerPixel(C4CyclesPerPixel)) conv_pooling_top
		(
    		.clk(clk),
            .res_n(res_n),
        	.in_valid(in_valid),
            .in_data(in_data),
            .out_ready(out_ready),
            .C1kernel(C1kernel), 
            .C2kernel(C2kernel),
            .C3kernel(C3kernel),
            .C4kernel(C4kernel),
            .C2_out_valid(C2_out_valid),
            .C2_out_data(C2_out_data),
            .C3_out_valid(C3_out_valid),
            .C3_out_data(C3_out_data),
            .C4_out_valid(C4_out_valid),
            .C4_out_data(C4_out_data)
    );



    
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
        C1kernel[0] = {{2'b00, 2'b01, 2'b10}, {2'b11, 2'b00, 2'b01}, {2'b10, 2'b11, 2'b00}};
        C1kernel[1] = {{2'b11, 2'b11, 2'b11}, {2'b10, 2'b10, 2'b10}, {2'b01, 2'b01, 2'b01}};
        C1kernel[2] = {{2'b11, 2'b01, 2'b00}, {2'b10, 2'b00, 2'b11}, {2'b00, 2'b10, 2'b11}};
        // C1kernel[3] = {{2'b10, 2'b10, 2'b10}, {2'b01, 2'b01, 2'b01}, {2'b01, 2'b10, 2'b00}};
        
        C2kernel[0] = {{2'b00, 2'b01, 2'b10}, {2'b11, 2'b00, 2'b01}, {2'b10, 2'b11, 2'b00}};
        C2kernel[1] = {{2'b11, 2'b11, 2'b11}, {2'b10, 2'b10, 2'b10}, {2'b01, 2'b01, 2'b01}};
        C2kernel[2] = {{2'b11, 2'b01, 2'b00}, {2'b10, 2'b00, 2'b11}, {2'b00, 2'b10, 2'b11}};
        C2kernel[3] = {{2'b10, 2'b10, 2'b10}, {2'b01, 2'b01, 2'b01}, {2'b01, 2'b10, 2'b00}};

        C3kernel[0] = {{2'b00, 2'b01, 2'b10}, {2'b11, 2'b00, 2'b01}, {2'b10, 2'b11, 2'b00}};
        C3kernel[1] = {{2'b11, 2'b11, 2'b11}, {2'b10, 2'b10, 2'b10}, {2'b01, 2'b01, 2'b01}};
        // C3kernel[2] = {{2'b11, 2'b01, 2'b00}, {2'b10, 2'b00, 2'b11}, {2'b00, 2'b10, 2'b11}};
        // C3kernel[3] = {{2'b10, 2'b10, 2'b10}, {2'b01, 2'b01, 2'b01}, {2'b01, 2'b10, 2'b00}};

        C4kernel[0] = {{2'b00, 2'b01, 2'b10}, {2'b11, 2'b00, 2'b01}, {2'b10, 2'b11, 2'b00}};
        C4kernel[1] = {{2'b11, 2'b11, 2'b11}, {2'b10, 2'b10, 2'b10}, {2'b01, 2'b01, 2'b01}};
        // C4kernel[2] = {{2'b11, 2'b01, 2'b00}, {2'b10, 2'b00, 2'b11}, {2'b00, 2'b10, 2'b11}};
        // C4kernel[3] = {{2'b10, 2'b10, 2'b10}, {2'b01, 2'b01, 2'b01}, {2'b01, 2'b10, 2'b00}};

        for (int counter = 1; counter <= ImageWidth*ImageWidth; counter = counter) begin
            #10
            clk = 1;
            if(counter <= ImageWidth*ImageWidth) begin
                in_data = test_image[ImageWidth*ImageWidth - counter];
                in_valid = 1;
            end
            else begin
                in_data = '0;
                in_valid = '0;
            end
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