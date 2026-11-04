module top();
// Qonnex
        /*AUTOWIRE*/
        // Beginning of automatic wires (for undeclared instantiated-module outputs)
        logic [ADDR_WIDTH-1:0] M_AXI_ARADDR;    // From axi_master_i1 of AXI_master.v
        logic [1:0]     M_AXI_ARBURST;          // From axi_master_i1 of AXI_master.v
        logic [7:0]     M_AXI_ARLEN;            // From axi_master_i1 of AXI_master.v
        logic [2:0]     M_AXI_ARSIZE;           // From axi_master_i1 of AXI_master.v
        logic           M_AXI_ARVALID;          // From axi_master_i1 of AXI_master.v
        logic [ADDR_WIDTH-1:0] M_AXI_AWADDR;    // From axi_master_i1 of AXI_master.v
        logic [1:0]     M_AXI_AWBURST;          // From axi_master_i1 of AXI_master.v
        logic [7:0]     M_AXI_AWLEN;            // From axi_master_i1 of AXI_master.v
        logic [2:0]     M_AXI_AWSIZE;           // From axi_master_i1 of AXI_master.v
        logic           M_AXI_AWVALID;          // From axi_master_i1 of AXI_master.v
        logic           M_AXI_BREADY;           // From axi_master_i1 of AXI_master.v
        logic           M_AXI_RREADY;           // From axi_master_i1 of AXI_master.v
        logic [DATA_WIDTH-1:0] M_AXI_WDATA;     // From axi_master_i1 of AXI_master.v
        logic           M_AXI_WLAST;            // From axi_master_i1 of AXI_master.v
        logic [DATA_WIDTH/8-1:0] M_AXI_WSTRB;   // From axi_master_i1 of AXI_master.v
        logic           M_AXI_WVALID;           // From axi_master_i1 of AXI_master.v
        logic [DATA_WIDTH-1:0] ifm_data;        // From axi_master_i1 of AXI_master.v
        logic           ifm_data_last;          // From axi_master_i1 of AXI_master.v
        logic           ifm_data_valid;         // From axi_master_i1 of AXI_master.v
        // End of automatics
        /*AUTOREG*/
  /*
   AXI_master AUTO_TEMPLATE (
   .ACLK(clk),
   .ARESETN(rst_n),
   );
   */
  AXI_master 
  axi_master_i1(/*AUTOINST*/
                // Outputs
                .M_AXI_ARADDR           (M_AXI_ARADDR[ADDR_WIDTH-1:0]),
                .M_AXI_ARLEN            (M_AXI_ARLEN[7:0]),
                .M_AXI_ARSIZE           (M_AXI_ARSIZE[2:0]),
                .M_AXI_ARBURST          (M_AXI_ARBURST[1:0]),
                .M_AXI_ARVALID          (M_AXI_ARVALID),
                .M_AXI_RREADY           (M_AXI_RREADY),
                .ifm_data               (ifm_data[DATA_WIDTH-1:0]),
                .ifm_data_valid         (ifm_data_valid),
                .ifm_data_last          (ifm_data_last),
                .M_AXI_AWADDR           (M_AXI_AWADDR[ADDR_WIDTH-1:0]),
                .M_AXI_AWLEN            (M_AXI_AWLEN[7:0]),
                .M_AXI_AWSIZE           (M_AXI_AWSIZE[2:0]),
                .M_AXI_AWBURST          (M_AXI_AWBURST[1:0]),
                .M_AXI_AWVALID          (M_AXI_AWVALID),
                .M_AXI_WDATA            (M_AXI_WDATA[DATA_WIDTH-1:0]),
                .M_AXI_WSTRB            (M_AXI_WSTRB[DATA_WIDTH/8-1:0]),
                .M_AXI_WLAST            (M_AXI_WLAST),
                .M_AXI_WVALID           (M_AXI_WVALID),
                .M_AXI_BREADY           (M_AXI_BREADY),
                // Inputs
                .ACLK                   (clk),                   // Templated
                .ARESETN                (rst_n),                 // Templated
                .ifm_req_valid          (ifm_req_valid),
                .rd_ifm_addr            (rd_ifm_addr[11:0]),
                .M_AXI_ARREADY          (M_AXI_ARREADY),
                .M_AXI_RDATA            (M_AXI_RDATA[DATA_WIDTH-1:0]),
                .M_AXI_RRESP            (M_AXI_RRESP[1:0]),
                .M_AXI_RLAST            (M_AXI_RLAST),
                .M_AXI_RVALID           (M_AXI_RVALID),
                .M_AXI_AWREADY          (M_AXI_AWREADY),
                .M_AXI_WREADY           (M_AXI_WREADY),
                .M_AXI_BRESP            (M_AXI_BRESP[1:0]),
                .M_AXI_BVALID           (M_AXI_BVALID));

endmodule

// Local Variables:
// verilog-library-directories: ("/home/luu_k64/Vivado/DNN_core/DNN_core.srcs/sources_1/new_1")
// End:
// End:
