module top();
        input a,b,c;
// Qonnex
        /*AUTOWIRE*/
        // Beginning of automatic wires (for undeclared instantiated-module outputs)
        logic [ADDR_WIDTH-1:0] M_AXI_ARADDR;    // From axi_master_i1 of AXI_master.v
        logic [1:0]     M_AXI_ARBURST;          // From axi_master_i1 of AXI_master.v
        logic [7:0]     M_AXI_ARLEN;            // From axi_master_i1 of AXI_master.v
        wire            M_AXI_ARREADY;          // From axi_ram_i1 of axi_ram.v
        logic [2:0]     M_AXI_ARSIZE;           // From axi_master_i1 of AXI_master.v
        logic           M_AXI_ARVALID;          // From axi_master_i1 of AXI_master.v
        logic [ADDR_WIDTH-1:0] M_AXI_AWADDR;    // From axi_master_i1 of AXI_master.v
        logic [1:0]     M_AXI_AWBURST;          // From axi_master_i1 of AXI_master.v
        logic [7:0]     M_AXI_AWLEN;            // From axi_master_i1 of AXI_master.v
        wire            M_AXI_AWREADY;          // From axi_ram_i1 of axi_ram.v
        logic [2:0]     M_AXI_AWSIZE;           // From axi_master_i1 of AXI_master.v
        logic           M_AXI_AWVALID;          // From axi_master_i1 of AXI_master.v
        wire            M_AXI_BID;              // From axi_ram_i1 of axi_ram.v
        logic           M_AXI_BREADY;           // From axi_master_i1 of AXI_master.v
        wire            M_AXI_BRESP;            // From axi_ram_i1 of axi_ram.v
        wire            M_AXI_BVALID;           // From axi_ram_i1 of axi_ram.v
        wire            M_AXI_RDATA;            // From axi_ram_i1 of axi_ram.v
        wire            M_AXI_RID;              // From axi_ram_i1 of axi_ram.v
        wire            M_AXI_RLAST;            // From axi_ram_i1 of axi_ram.v
        logic           M_AXI_RREADY;           // From axi_master_i1 of AXI_master.v
        wire            M_AXI_RRESP;            // From axi_ram_i1 of axi_ram.v
        wire            M_AXI_RVALID;           // From axi_ram_i1 of axi_ram.v
        logic [DATA_WIDTH-1:0] M_AXI_WDATA;     // From axi_master_i1 of AXI_master.v
        logic           M_AXI_WLAST;            // From axi_master_i1 of AXI_master.v
        wire            M_AXI_WREADY;           // From axi_ram_i1 of axi_ram.v
        logic [DATA_WIDTH/8-1:0] M_AXI_WSTRB;   // From axi_master_i1 of AXI_master.v
        logic           M_AXI_WVALID;           // From axi_master_i1 of AXI_master.v
        wire            compute_en;             // From buffer_controller_i1 of buffer_controller.v
        logic [DATA_WIDTH-1:0] data_out_0;      // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_1;      // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_10;     // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_11;     // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_12;     // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_13;     // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_14;     // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_15;     // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_2;      // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_3;      // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_4;      // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_5;      // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_6;      // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_7;      // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_8;      // From buffer_array_i1 of buffer_array.v
        logic [DATA_WIDTH-1:0] data_out_9;      // From buffer_array_i1 of buffer_array.v
        logic           enable;                 // From PE_arr_controller_i1 of PE_arr_controller.v
        logic           exe_1row_done;          // From PE_arr_controller_i1 of PE_arr_controller.v
        logic           exe_ready;              // From PE_arr_controller_i1 of PE_arr_controller.v
        logic [11:0]    ifm_buffer_address_0;   // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_1;   // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_10;  // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_11;  // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_12;  // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_13;  // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_14;  // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_15;  // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_2;   // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_3;   // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_4;   // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_5;   // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_6;   // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_7;   // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_8;   // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    ifm_buffer_address_9;   // From buffer_controller_i1 of buffer_controller.v
        logic [DATA_WIDTH-1:0] ifm_data;        // From axi_master_i1 of AXI_master.v
        logic           ifm_data_valid;         // From axi_master_i1 of AXI_master.v
        wire            ifm_req_valid;          // From buffer_controller_i1 of buffer_controller.v
        logic           ofm_data_last;          // From axi_master_i1 of AXI_master.v
        wire [SYSTOLIC_SIZE*DATA_WIDTH-1:0] ofm_out;// From PE_array_i1 of PE_array.v
        logic           rd_en_buffer;           // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    rd_ifm_addr;            // From buffer_controller_i1 of buffer_controller.v
        logic [15:0]    reset_pe_1;             // From PE_arr_controller_i1 of PE_arr_controller.v
        logic [15:0]    reset_pe_2;             // From PE_arr_controller_i1 of PE_arr_controller.v
        logic           sel_out_de_mux;         // From PE_arr_controller_i1 of PE_arr_controller.v
        logic           sel_out_mux;            // From PE_arr_controller_i1 of PE_arr_controller.v
        logic           wgt_data_valid;         // From axi_master_i1 of AXI_master.v
        logic           wr_en_buffer;           // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    wr_ifm_addr;            // From buffer_controller_i1 of buffer_controller.v
        logic           write_out_en;           // From PE_arr_controller_i1 of PE_arr_controller.v
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
                .wgt_data_valid         (wgt_data_valid),
                .ofm_data_last          (ofm_data_last),
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

  /*
   PE_arr_controller AUTO_TEMPLATE (
   .cnt_compute_max(12'h27),
   );
   */
  PE_arr_controller 
  PE_arr_controller_i1(/*AUTOINST*/
                       // Outputs
                       .exe_1row_done   (exe_1row_done),
                       .exe_ready       (exe_ready),
                       .reset_pe_1      (reset_pe_1[15:0]),
                       .reset_pe_2      (reset_pe_2[15:0]),
                       .enable          (enable),
                       .write_out_en    (write_out_en),
                       .sel_out_mux     (sel_out_mux),
                       .sel_out_de_mux  (sel_out_de_mux),
                       // Inputs
                       .clk             (clk),
                       .rst_n           (rst_n),
                       .compute_en      (compute_en),
                       .cnt_compute_max (12'h27));               // Templated

  /*
   PE_array AUTO_TEMPLATE (
   );
   */
  PE_array 
  PE_array_i1(/*AUTOINST*/
              // Outputs
              .ofm_out                  (ofm_out[SYSTOLIC_SIZE*DATA_WIDTH-1:0]),
              // Inputs
              .clk                      (clk),
              .rst_n                    (rst_n),
              .reset_pe_1               (reset_pe_1[SYSTOLIC_SIZE*2-2:0]),
              .reset_pe_2               (reset_pe_2[SYSTOLIC_SIZE*2-2:0]),
              .enable                   (enable),
              .write_out_en             (write_out_en),
              .sel_out_mux              (sel_out_mux),
              .sel_out_de_mux           (sel_out_de_mux),
              .wgt_in                   (wgt_in[SYSTOLIC_SIZE*DATA_WIDTH-1:0]),
              .ifm_in                   (ifm_in[SYSTOLIC_SIZE*DATA_WIDTH-1:0]));

  /*
   buffer_controller AUTO_TEMPLATE (
   );
   */
  buffer_controller 
  buffer_controller_i1(/*AUTOINST*/
                       // Outputs
                       .ifm_req_valid   (ifm_req_valid),
                       .wr_ifm_addr     (wr_ifm_addr[11:0]),
                       .rd_ifm_addr     (rd_ifm_addr[11:0]),
                       .wr_en_buffer    (wr_en_buffer),
                       .rd_en_buffer    (rd_en_buffer),
                       .ifm_buffer_address_0(ifm_buffer_address_0[11:0]),
                       .ifm_buffer_address_1(ifm_buffer_address_1[11:0]),
                       .ifm_buffer_address_2(ifm_buffer_address_2[11:0]),
                       .ifm_buffer_address_3(ifm_buffer_address_3[11:0]),
                       .ifm_buffer_address_4(ifm_buffer_address_4[11:0]),
                       .ifm_buffer_address_5(ifm_buffer_address_5[11:0]),
                       .ifm_buffer_address_6(ifm_buffer_address_6[11:0]),
                       .ifm_buffer_address_7(ifm_buffer_address_7[11:0]),
                       .ifm_buffer_address_8(ifm_buffer_address_8[11:0]),
                       .ifm_buffer_address_9(ifm_buffer_address_9[11:0]),
                       .ifm_buffer_address_10(ifm_buffer_address_10[11:0]),
                       .ifm_buffer_address_11(ifm_buffer_address_11[11:0]),
                       .ifm_buffer_address_12(ifm_buffer_address_12[11:0]),
                       .ifm_buffer_address_13(ifm_buffer_address_13[11:0]),
                       .ifm_buffer_address_14(ifm_buffer_address_14[11:0]),
                       .ifm_buffer_address_15(ifm_buffer_address_15[11:0]),
                       .compute_en      (compute_en),
                       // Inputs
                       .clk             (clk),
                       .rst_n           (rst_n),
                       .ifm_channel     (ifm_channel[10:0]),
                       .kernel_size     (kernel_size[3:0]),
                       .num_filter      (num_filter[7:0]),
                       .maxpool_stride  (maxpool_stride[1:0]),
                       .stride          (stride[2:0]),
                       .ifm_width_tile  (ifm_width_tile[11:0]),
                       .ifm_height_tile (ifm_height_tile[11:0]),
                       .ofm_width       (ofm_width[11:0]),
                       .ofm_height      (ofm_height[11:0]),
                       .ifm_width       (ifm_width[11:0]),
                       .ifm_height      (ifm_height[11:0]),
                       .num_channel     (num_channel[11:0]),
                       .exe_1row_done   (exe_1row_done),
                       .RVALID          (RVALID),
                       .RLAST           (RLAST),
                       .RREADY          (RREADY),
                       .RDATA           (RDATA[15:0]),
                       .ifm_data_valid  (ifm_data_valid),
                       .wgt_data_valid  (wgt_data_valid),
                       .ofm_data_valid  (ofm_data_valid));

  /*
   buffer_array AUTO_TEMPLATE (
   .read_en(rd_en_buffer),
   .write_en(wr_en_buffer),
   .write_addr(wr_ifm_addr),
   .data_in(RDATA),
   .read_addr_0(ifm_buffer_address_0),
   .read_addr_1(ifm_buffer_address_1),
   .read_addr_2(ifm_buffer_address_2),
   .read_addr_3(ifm_buffer_address_3),
   .read_addr_4(ifm_buffer_address_4),
   .read_addr_5(ifm_buffer_address_5),
   .read_addr_6(ifm_buffer_address_6),
   .read_addr_7(ifm_buffer_address_7),
   .read_addr_8(ifm_buffer_address_8),
   .read_addr_9(ifm_buffer_address_9),
   .read_addr_10(ifm_buffer_address_10),
   .read_addr_11(ifm_buffer_address_11),
   .read_addr_12(ifm_buffer_address_12),
   .read_addr_13(ifm_buffer_address_13),
   .read_addr_14(ifm_buffer_address_14),
   .read_addr_15(ifm_buffer_address_15),
   );
   */
  buffer_array 
  buffer_array_i1(/*AUTOINST*/
                  // Outputs
                  .data_out_0           (data_out_0[DATA_WIDTH-1:0]),
                  .data_out_1           (data_out_1[DATA_WIDTH-1:0]),
                  .data_out_2           (data_out_2[DATA_WIDTH-1:0]),
                  .data_out_3           (data_out_3[DATA_WIDTH-1:0]),
                  .data_out_4           (data_out_4[DATA_WIDTH-1:0]),
                  .data_out_5           (data_out_5[DATA_WIDTH-1:0]),
                  .data_out_6           (data_out_6[DATA_WIDTH-1:0]),
                  .data_out_7           (data_out_7[DATA_WIDTH-1:0]),
                  .data_out_8           (data_out_8[DATA_WIDTH-1:0]),
                  .data_out_9           (data_out_9[DATA_WIDTH-1:0]),
                  .data_out_10          (data_out_10[DATA_WIDTH-1:0]),
                  .data_out_11          (data_out_11[DATA_WIDTH-1:0]),
                  .data_out_12          (data_out_12[DATA_WIDTH-1:0]),
                  .data_out_13          (data_out_13[DATA_WIDTH-1:0]),
                  .data_out_14          (data_out_14[DATA_WIDTH-1:0]),
                  .data_out_15          (data_out_15[DATA_WIDTH-1:0]),
                  // Inputs
                  .clk                  (clk),
                  .rst_n                (rst_n),
                  .read_en              (rd_en_buffer),          // Templated
                  .write_en             (wr_en_buffer),          // Templated
                  .data_in              (RDATA),                 // Templated
                  .write_addr           (wr_ifm_addr),           // Templated
                  .read_addr_0          (ifm_buffer_address_0),  // Templated
                  .read_addr_1          (ifm_buffer_address_1),  // Templated
                  .read_addr_2          (ifm_buffer_address_2),  // Templated
                  .read_addr_3          (ifm_buffer_address_3),  // Templated
                  .read_addr_4          (ifm_buffer_address_4),  // Templated
                  .read_addr_5          (ifm_buffer_address_5),  // Templated
                  .read_addr_6          (ifm_buffer_address_6),  // Templated
                  .read_addr_7          (ifm_buffer_address_7),  // Templated
                  .read_addr_8          (ifm_buffer_address_8),  // Templated
                  .read_addr_9          (ifm_buffer_address_9),  // Templated
                  .read_addr_10         (ifm_buffer_address_10), // Templated
                  .read_addr_11         (ifm_buffer_address_11), // Templated
                  .read_addr_12         (ifm_buffer_address_12), // Templated
                  .read_addr_13         (ifm_buffer_address_13), // Templated
                  .read_addr_14         (ifm_buffer_address_14), // Templated
                  .read_addr_15         (ifm_buffer_address_15)); // Templated

  /*
   axi_ram AUTO_TEMPLATE (
   .clk(ACLK),
   .rst(~ARESETN),
   .s_axi_awid(8'd0),
   .s_axi_awaddr(M_AXI_AWADDR),
   .s_axi_awlen(M_AXI_AWLEN),
   .s_axi_awsize(M_AXI_AWSIZE),
   .s_axi_awburst(M_AXI_AWBURST),
   .s_axi_awlock(1'b0),
   .s_axi_awcache(4'b0010),
   .s_axi_awprot(3'b000),
   .s_axi_awvalid(M_AXI_AWVALID),
   .s_axi_awready(M_AXI_AWREADY),
   .s_axi_wdata(M_AXI_WDATA),
   .s_axi_wstrb(M_AXI_WSTRB),
   .s_axi_wlast(M_AXI_WLAST),
   .s_axi_wvalid(M_AXI_WVALID),
   .s_axi_wready(M_AXI_WREADY),
   .s_axi_bid(M_AXI_BID),
   .s_axi_bresp(M_AXI_BRESP),
   .s_axi_bvalid(M_AXI_BVALID),
   .s_axi_bready(M_AXI_BREADY),
   .s_axi_arid(8'd0),
   .s_axi_araddr(M_AXI_ARADDR),
   .s_axi_arlen(M_AXI_ARLEN),
   .s_axi_arsize(M_AXI_ARSIZE),
   .s_axi_arburst(M_AXI_ARBURST),
   .s_axi_arlock(1'b0),
   .s_axi_arcache(4'b0010),
   .s_axi_arprot(3'b000),
   .s_axi_arvalid(M_AXI_ARVALID),
   .s_axi_arready(M_AXI_ARREADY),
   .s_axi_rid(M_AXI_RID),
   .s_axi_rdata(M_AXI_RDATA),
   .s_axi_rresp(M_AXI_RRESP),
   .s_axi_rlast(M_AXI_RLAST),
   .s_axi_rvalid(M_AXI_RVALID),
   .s_axi_rready(M_AXI_RREADY),
   );
   */
  axi_ram 
  axi_ram_i1(/*AUTOINST*/
             // Outputs
             .s_axi_awready             (M_AXI_AWREADY),         // Templated
             .s_axi_wready              (M_AXI_WREADY),          // Templated
             .s_axi_bid                 (M_AXI_BID),             // Templated
             .s_axi_bresp               (M_AXI_BRESP),           // Templated
             .s_axi_bvalid              (M_AXI_BVALID),          // Templated
             .s_axi_arready             (M_AXI_ARREADY),         // Templated
             .s_axi_rid                 (M_AXI_RID),             // Templated
             .s_axi_rdata               (M_AXI_RDATA),           // Templated
             .s_axi_rresp               (M_AXI_RRESP),           // Templated
             .s_axi_rlast               (M_AXI_RLAST),           // Templated
             .s_axi_rvalid              (M_AXI_RVALID),          // Templated
             // Inputs
             .clk                       (ACLK),                  // Templated
             .rst                       (~ARESETN),              // Templated
             .s_axi_awid                (8'd0),                  // Templated
             .s_axi_awaddr              (M_AXI_AWADDR),          // Templated
             .s_axi_awlen               (M_AXI_AWLEN),           // Templated
             .s_axi_awsize              (M_AXI_AWSIZE),          // Templated
             .s_axi_awburst             (M_AXI_AWBURST),         // Templated
             .s_axi_awlock              (1'b0),                  // Templated
             .s_axi_awcache             (4'b0010),               // Templated
             .s_axi_awprot              (3'b000),                // Templated
             .s_axi_awvalid             (M_AXI_AWVALID),         // Templated
             .s_axi_wdata               (M_AXI_WDATA),           // Templated
             .s_axi_wstrb               (M_AXI_WSTRB),           // Templated
             .s_axi_wlast               (M_AXI_WLAST),           // Templated
             .s_axi_wvalid              (M_AXI_WVALID),          // Templated
             .s_axi_bready              (M_AXI_BREADY),          // Templated
             .s_axi_arid                (8'd0),                  // Templated
             .s_axi_araddr              (M_AXI_ARADDR),          // Templated
             .s_axi_arlen               (M_AXI_ARLEN),           // Templated
             .s_axi_arsize              (M_AXI_ARSIZE),          // Templated
             .s_axi_arburst             (M_AXI_ARBURST),         // Templated
             .s_axi_arlock              (1'b0),                  // Templated
             .s_axi_arcache             (4'b0010),               // Templated
             .s_axi_arprot              (3'b000),                // Templated
             .s_axi_arvalid             (M_AXI_ARVALID),         // Templated
             .s_axi_rready              (M_AXI_RREADY));                 // Templated

endmodule

// Local Variables:
// verilog-library-directories: ("/home/luu_k64/project/DNN_accelerator_base_Systolic_Array/vivado/DNN_core/DNN_core.srcs/sources_1/new_1")
// End:
// End:
