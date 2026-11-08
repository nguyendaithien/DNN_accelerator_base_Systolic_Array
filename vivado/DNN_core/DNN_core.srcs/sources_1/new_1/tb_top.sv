`timescale 1ns/1ps
module tb_top;

    // =====================================================
    // Parameters
    // =====================================================
    parameter ADDR_WIDTH   = 12;
    parameter DATA_WIDTH   = 16;
    parameter SYSTOLIC_SIZE = 16;
    parameter SA_SIZE      = 16;
    parameter ID_WIDTH = 8;

    // =====================================================
    // Clock and Reset
    // =====================================================
    logic clk;
    logic rst_n;

    // =====================================================
    // AXI Signals
    // =====================================================

    // Read Address Channel
    wire M_AXI_ARREADY;
    wire [31:0] M_AXI_ARADDR;
    wire [7:0] M_AXI_ARLEN;
    wire [2:0] M_AXI_ARSIZE;
    wire [1:0] M_AXI_ARBURST;
    wire M_AXI_ARVALID;

    // Read Data Channel
    wire [DATA_WIDTH-1:0] M_AXI_RDATA;
    wire [1:0] M_AXI_RRESP;
    wire M_AXI_RLAST;
    wire M_AXI_RVALID;
    wire M_AXI_RREADY;

    // Write Address Channel
    wire M_AXI_AWREADY;
    wire [ADDR_WIDTH-1:0] M_AXI_AWADDR;
    wire [7:0] M_AXI_AWLEN;
    wire [2:0] M_AXI_AWSIZE;
    wire [1:0] M_AXI_AWBURST;
    wire M_AXI_AWVALID;

    // Write Data Channel
    wire M_AXI_WREADY;
    wire [DATA_WIDTH-1:0] M_AXI_WDATA;
    wire [DATA_WIDTH/8-1:0] M_AXI_WSTRB;
    wire M_AXI_WLAST;
    wire M_AXI_WVALID;

    // Write Response Channel
    wire [1:0] M_AXI_BRESP;
    wire M_AXI_BVALID;
    wire M_AXI_BREADY;


    // =====================================================
    // DUT: TOP
    // =====================================================

    top #(
        .ADDR_WIDTH   (ADDR_WIDTH),
        .DATA_WIDTH   (DATA_WIDTH),
        .SYSTOLIC_SIZE(SYSTOLIC_SIZE),
        .SA_SIZE      (SA_SIZE)
    ) top_inst (

        .clk           (clk),
        .rst_n         (rst_n),

        // Read Address
        .M_AXI_ARREADY (M_AXI_ARREADY),
        .M_AXI_ARADDR  (M_AXI_ARADDR),
        .M_AXI_ARLEN   (M_AXI_ARLEN),
        .M_AXI_ARSIZE  (M_AXI_ARSIZE),
        .M_AXI_ARBURST (M_AXI_ARBURST),
        .M_AXI_ARVALID (M_AXI_ARVALID),

        // Read Data
        .M_AXI_RDATA   (M_AXI_RDATA),
        .M_AXI_RRESP   (M_AXI_RRESP),
        .M_AXI_RLAST   (M_AXI_RLAST),
        .M_AXI_RVALID  (M_AXI_RVALID),
        .M_AXI_RREADY  (M_AXI_RREADY),

        // Write Address
        .M_AXI_AWREADY (M_AXI_AWREADY),
        .M_AXI_AWADDR  (M_AXI_AWADDR),
        .M_AXI_AWLEN   (M_AXI_AWLEN),
        .M_AXI_AWSIZE  (M_AXI_AWSIZE),
        .M_AXI_AWBURST (M_AXI_AWBURST),
        .M_AXI_AWVALID (M_AXI_AWVALID),

        // Write Data
        .M_AXI_WREADY  (M_AXI_WREADY),
        .M_AXI_WDATA   (M_AXI_WDATA),
        .M_AXI_WSTRB   (M_AXI_WSTRB),
        .M_AXI_WLAST   (M_AXI_WLAST),
        .M_AXI_WVALID  (M_AXI_WVALID),

        // Write Response
        .M_AXI_BRESP   (M_AXI_BRESP),
        .M_AXI_BVALID  (M_AXI_BVALID),
        .M_AXI_BREADY  (M_AXI_BREADY)
    );


    // =====================================================
    // AXI RAM: MEMORY MODEL
    // =====================================================

    axi_ram #(
        .DATA_WIDTH      (16),
        .ADDR_WIDTH      (32),
        .STRB_WIDTH      (DATA_WIDTH/8),
        .ID_WIDTH        (ID_WIDTH),
        .PIPELINE_OUTPUT (0)
    ) axi_ram_inst (

        .clk          (clk),
        .rst          (~rst_n),

        // Write Address
        .s_axi_awid   ({ID_WIDTH{1'b0}}),
        .s_axi_awaddr (M_AXI_AWADDR),
        .s_axi_awlen  (M_AXI_AWLEN),
        .s_axi_awsize (M_AXI_AWSIZE),
        .s_axi_awburst(M_AXI_AWBURST),
        .s_axi_awlock (1'b0),
        .s_axi_awcache(4'b0011),
        .s_axi_awprot (3'b000),
        .s_axi_awvalid(M_AXI_AWVALID),
        .s_axi_awready(M_AXI_AWREADY),

        // Write Data
        .s_axi_wdata  (M_AXI_WDATA),
        .s_axi_wstrb  (M_AXI_WSTRB),
        .s_axi_wlast  (M_AXI_WLAST),
        .s_axi_wvalid (M_AXI_WVALID),
        .s_axi_wready (M_AXI_WREADY),

        // Write Response
        .s_axi_bid    (),
        .s_axi_bresp  (M_AXI_BRESP),
        .s_axi_bvalid (M_AXI_BVALID),
        .s_axi_bready (M_AXI_BREADY),

        // Read Address
        .s_axi_arid   ({ID_WIDTH{1'b0}}),
        .s_axi_araddr (M_AXI_ARADDR),
        .s_axi_arlen  (M_AXI_ARLEN),
        .s_axi_arsize (M_AXI_ARSIZE),
        .s_axi_arburst(M_AXI_ARBURST),
        .s_axi_arlock (1'b0),
        .s_axi_arcache(4'b0011),
        .s_axi_arprot (3'b000),
        .s_axi_arvalid(M_AXI_ARVALID),
        .s_axi_arready(M_AXI_ARREADY),

        // Read Data
        .s_axi_rid    (),
        .s_axi_rdata  (M_AXI_RDATA),
        .s_axi_rresp  (M_AXI_RRESP),
        .s_axi_rlast  (M_AXI_RLAST),
        .s_axi_rvalid (M_AXI_RVALID),
        .s_axi_rready (M_AXI_RREADY)
    );

		// ==== INITIAL VALUE ==========
		 initial begin
        $readmemb ("./data/ifm_bin_c3_h418_w418.txt", axi_ram_inst.mem,0);
     end
		 initial begin 
			 #1000;
			 //for (integer i = 0; i < 1000; i= i+1) begin
			 //  $display ("mem[%d]: %d", i, axi_ram_inst.mem[i]);
			 //end
			 #1000;
			 for (integer i = 523172; i < 524172; i= i+1) begin
			   $display ("mem[%d]: %d", i, axi_ram_inst.mem[i]);
			 end
		 end

    // =====================================================
    // Clock Generation
    // Period = 5ns => Frequency = 200MHz
    // =====================================================

    initial begin
        clk = 0;
        forever #2.5 clk = ~clk;
    end
    // =====================================================
    // Reset
    // =====================================================
    initial begin
        rst_n = 0;
        repeat(10) @(posedge clk);
        rst_n = 1;
        $display("[%0t] Reset released", $time);
    end
    // =====================================================
    // Simulation Control
    // =====================================================
    initial begin
        #1000000;
        $display("Simulation finished");
        $finish;
    end
endmodule

