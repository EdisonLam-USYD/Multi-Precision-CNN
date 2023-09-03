




module TB_flattening_layer;
    localparam BitSize          = 4;
    localparam ImageSize        = 4; // i.e. NxN
    localparam NumOfImages      = 4;
    localparam NumOfPEPerInput  = 1;
    localparam NumOfInputs      = 2;
    localparam CyclesPerPixel   = 4;

    logic clk;
    logic res_n;
    logic [NumOfImages-1:0] in_valid;
    logic [NumOfImages-1:0] in_done;
    logic [NumOfInputs*NumOfPEPerInput-1:0][BitSize-1:0] in_data;

    logic out_ready;
    logic out_valid;
    logic [ImageSize-1:0][BitSize-1:0] out_data;

    logic [NumOfImages-1:0][ImageSize-1:0][BitSize-1:0] inputs;
    logic [ImageSize-1:0][BitSize-1:0] a;
    logic [ImageSize-1:0][BitSize-1:0] b;
    logic [ImageSize-1:0][BitSize-1:0] c;
    logic [ImageSize-1:0][BitSize-1:0] d;
    
    flattening_layer #(.Bitsize(Bitsize), .ImageSize(ImageSize), .NumOfImages(NumOfImages), 
        .NumOfPEPerInput(NumOfPEPerInput), .NumOfInputs(NumOfInputs), .CyclesPerPixel(CyclesPerPixel))
        f_layer0 (.clk(clk), .res_n(res_n), .in_valid(in_valid), .in_data(in_data), .in_done(in_done), 
        .out_ready(out_ready), .out_valid(out_valid), .out_data(out_data));

    int j;
    int i;
    
    // assign in_valid = {(j % 2) == CyclesPerPixel}

    initial 
    begin
        a = {1, 2, 3, 4};
        b = {0, 2, 4, 8};
        c = {9, 6, 3, 1};
        d = {5, 6, 7, 8};
        inputs = {a, b, c, d};

        res_n = 0;
        clk = 0;
        #5
        clk = 1;
        in_valid = 0;
        #5
        res_n = 1;
        clk = 0;

        $monitor("@%0t: out = %p", out_data);

        for (i = 0; i < ImageSize; i = i + 1) begin
            for (j = 0; j < CyclesPerPixel; j = j + 1) begin
                #10
                if (j == 0) in_valid = {1, 0, 1, 0};
                else if (j == 1) in_valid = {0, 1, 0, 1};
                else in_valid = '0;
                in_data = {inputs[(j % NumOfImages)][ImageSize - i], inputs[((j + 1) % NumOfImages)][ImageSize - i]};
                clk = 1;
                #10
                clk = 0;
            end
        end
        for (i = 0; i < ImageSize; i = i + 1) begin
            for (j = 0; j < CyclesPerPixel; j = j + 1) begin
                #10
                if (j == 0) in_valid = {1, 1, 1, 1};
                else in_valid = '0;
                in_data = '0;
                clk = 1;
                #10
                clk = 0;
            end
        end

        // hardcoding tests - single pe per input
        // #10
        // in_data = {a[]}

    end


endmodule