`timescale 1ns / 1ps

module tb_isp_core();
    reg clk = 0;
    reg rst_n = 0;
    
    reg [7:0] s_axis_tdata;
    reg s_axis_tvalid;
    reg s_axis_tuser;
    reg s_axis_tlast;
    wire s_axis_tready; 
    
    wire [23:0] m_axis_tdata;
    wire m_axis_tvalid;
    wire m_axis_tuser;
    wire m_axis_tlast;
    reg m_axis_tready = 1'b1; 
    
    reg [7:0] gain = 8'h10; 

    reg [7:0] bayer_mem [0:921599];
    
    integer i, file_out;
    
    isp_core_top #(
        .IMG_WIDTH(1280), 
        .IMG_HEIGHT(720)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .s_axis_tuser(s_axis_tuser),
        .s_axis_tlast(s_axis_tlast),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),
        .m_axis_tuser(m_axis_tuser),
        .m_axis_tlast(m_axis_tlast),
        .gain(gain)
    );

    always #5 clk = ~clk;

    initial begin
        s_axis_tdata = 8'h00;
        s_axis_tvalid = 0;
        s_axis_tuser = 0;
        s_axis_tlast = 0;
        
        $readmemh("input_bayer.hex", bayer_mem);
        
        file_out = $fopen("output_rgb.hex", "w");
        if (file_out == 0) begin
            $display("CRITICAL ERROR: Failed to open file descriptor for output recording.");
            $finish;
        end
        
        #100;
        rst_n = 1;
        #20;
        
        $display("[SIM_INFO] Initiating streaming transaction for %0d frame pixels...", 921600);

        for (i = 0; i < 921600; i = i + 1) begin
            @(posedge clk);
            while (!s_axis_tready) @(posedge clk); 
            
            s_axis_tvalid = 1'b1;
            s_axis_tdata  = bayer_mem[i];
            
            s_axis_tuser  = (i == 0);
            
            s_axis_tlast  = ((i + 1) % 1280 == 0);
        end
        
        @(posedge clk);
        s_axis_tdata = 8'h00;
        s_axis_tvalid = 1'b1; 
        s_axis_tuser = 1'b0;
        s_axis_tlast = 1'b0;
        
        repeat (3000) @(posedge clk); 
        
        s_axis_tvalid = 1'b0;
        #100;
        
        $fclose(file_out);
        $display("[SIM_INFO] Simulation sequence completed. Co-simulation stream recorded in output_rgb.hex");
        $finish;
    end

    always @(posedge clk) begin
        if (m_axis_tvalid && m_axis_tready) begin
            $fwrite(file_out, "%06x\n", m_axis_tdata);
        end
    end
endmodule
