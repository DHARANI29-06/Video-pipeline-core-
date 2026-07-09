module line_buffer #(
    parameter WIDTH = 1280,
    parameter D_WIDTH = 8
)(
    input  wire                 clk,
    input  wire                 ce,
    input  wire [D_WIDTH-1:0]   din,
    output wire [D_WIDTH-1:0]   taps_0, 
    output wire [D_WIDTH-1:0]   taps_1, 
    output wire [D_WIDTH-1:0]   taps_2  
);
    reg [D_WIDTH-1:0] mem0 [0:WIDTH-1];
    reg [D_WIDTH-1:0] mem1 [0:WIDTH-1];
    reg [11:0] rd_ptr = 0;

    always @(posedge clk) begin
        if (ce) begin
            mem0[rd_ptr] <= din;          
            mem1[rd_ptr] <= mem0[rd_ptr]; 
            
            if (rd_ptr == WIDTH-1) rd_ptr <= 0;
            else rd_ptr <= rd_ptr + 1;
        end
    end

    assign taps_0 = din;
    assign taps_1 = mem0[rd_ptr];
    assign taps_2 = mem1[rd_ptr];
endmodule
