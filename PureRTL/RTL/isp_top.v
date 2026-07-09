module isp_core_top #(
    parameter IMG_WIDTH = 1280,
    parameter IMG_HEIGHT = 720
)(
    input wire          clk,
    input wire          rst_n,
    
    input wire [7:0]    s_axis_tdata,
    input wire          s_axis_tvalid,
    output wire         s_axis_tready,
    input wire          s_axis_tuser,  
    input wire          s_axis_tlast,  
    
    output reg [23:0]   m_axis_tdata,
    output reg          m_axis_tvalid,
    input wire          m_axis_tready,
    output reg          m_axis_tuser,
    output reg          m_axis_tlast,
    
    input wire [7:0]    gain 
);
    assign s_axis_tready = m_axis_tready;

    wire [15:0] gain_mult = s_axis_tdata * gain;
    wire [7:0] gained_pixel = (gain_mult[11:4] > 8'hFF) ? 8'hFF : gain_mult[11:4];

    wire [7:0] w0, w1, w2;
    line_buffer #(IMG_WIDTH, 8) lb_inst (
        .clk(clk), .ce(s_axis_tvalid && s_axis_tready),
        .din(gained_pixel), .taps_0(w0), .taps_1(w1), .taps_2(w2)
    );

    reg [7:0] p11, p12, p13, p21, p22, p23, p31, p32, p33;
    
    initial begin
        {p11, p12, p13} = 0;
        {p21, p22, p23} = 0;
        {p31, p32, p33} = 0;
    end

    always @(posedge clk) begin
        if (s_axis_tvalid && s_axis_tready) begin
            {p11, p12, p13} <= {p12, p13, w2};
            {p21, p22, p23} <= {p22, p23, w1};
            {p31, p32, p33} <= {p32, p33, w0};
        end
    end

    reg [11:0] x_cnt, y_cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_cnt <= 0;
            y_cnt <= 0;
        end else if (s_axis_tvalid && s_axis_tready) begin
            if (s_axis_tuser) begin
                x_cnt <= 0;
                y_cnt <= 0;
            end else if (s_axis_tlast) begin 
                x_cnt <= 0; 
                y_cnt <= y_cnt + 1; 
            end else begin
                x_cnt <= x_cnt + 1;
            end
        end
    end

    wire [9:0] sum_4_neighbors = p12 + p21 + p23 + p32;
    wire [9:0] sum_corners     = p11 + p13 + p31 + p33;
    wire [8:0] sum_v_neighbors = p12 + p32;
    wire [8:0] sum_h_neighbors = p21 + p23;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            m_axis_tvalid <= 1'b0;
            m_axis_tlast  <= 1'b0;
            m_axis_tuser  <= 1'b0;
            m_axis_tdata  <= 24'b0;
        end else if (s_axis_tready) begin
            m_axis_tlast  <= s_axis_tlast;
            m_axis_tuser  <= s_axis_tuser;
            
            m_axis_tvalid <= s_axis_tvalid && (y_cnt >= 2);

            if (y_cnt[0] == 0) begin 
                if (x_cnt[0] == 0) begin 
                    m_axis_tdata[23:16] <= p22; 
                    m_axis_tdata[15:8]  <= sum_4_neighbors[9:2]; 
                    m_axis_tdata[7:0]   <= sum_corners[9:2];     
                end else begin           
                    m_axis_tdata[23:16] <= sum_h_neighbors[8:1]; 
                    m_axis_tdata[15:8]  <= p22; 
                    m_axis_tdata[7:0]   <= sum_v_neighbors[8:1]; 
                end
            end else begin           
                if (x_cnt[0] == 0) begin 
                    m_axis_tdata[23:16] <= sum_v_neighbors[8:1]; 
                    m_axis_tdata[15:8]  <= p22; 
                    m_axis_tdata[7:0]   <= sum_h_neighbors[8:1]; 
                end else begin           
                    m_axis_tdata[23:16] <= sum_corners[9:2];     
                    m_axis_tdata[15:8]  <= sum_4_neighbors[9:2]; 
                    m_axis_tdata[7:0]   <= p22; 
                end
            end
        end
    end
endmodule
