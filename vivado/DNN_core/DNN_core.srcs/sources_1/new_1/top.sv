module top #(
        parameter ADDR_WIDTH = 12,
        parameter DATA_WIDTH = 16,
        parameter SYSTOLIC_SIZE = 16,
        parameter SA_SIZE = 16
)(
        M_AXI_ARREADY  ,
        M_AXI_RDATA    ,
        M_AXI_RRESP    ,
        M_AXI_RLAST    ,
        M_AXI_RVALID   ,
        M_AXI_AWREADY  ,
        M_AXI_WREADY   ,
        M_AXI_BRESP    ,
        M_AXI_BVALID   ,
        M_AXI_ARADDR   ,
        M_AXI_ARLEN    ,
        M_AXI_ARSIZE   ,
        M_AXI_ARBURST  ,
        M_AXI_ARVALID  ,
        M_AXI_RREADY   ,
        M_AXI_AWADDR   ,
        M_AXI_AWLEN    ,
        M_AXI_AWSIZE   ,
        M_AXI_AWBURST  ,
        M_AXI_AWVALID  ,
        M_AXI_WDATA    ,
        M_AXI_WSTRB    ,
        M_AXI_WLAST    ,
        M_AXI_WVALID   ,
        M_AXI_BREADY   ,
  clk,
        rst_n   
        );

        input                    clk            ;
        input                    rst_n          ;
        input logic  M_AXI_ARREADY  ;
        input logic  [DATA_WIDTH-1:0] M_AXI_RDATA    ;
        input logic  [1:0] M_AXI_RRESP    ;
        input logic  M_AXI_RLAST    ;
        input logic  M_AXI_RVALID   ;
        input logic  M_AXI_AWREADY  ;
        input logic  M_AXI_WREADY   ;
        input logic  [1:0] M_AXI_BRESP    ;
        input logic  M_AXI_BVALID   ;
        output logic [ADDR_WIDTH-1:0] M_AXI_ARADDR   ;
        output logic [7:0] M_AXI_ARLEN    ;
        output logic [2:0] M_AXI_ARSIZE   ;
        output logic [1:0] M_AXI_ARBURST  ;
        output logic M_AXI_ARVALID  ;
        output logic M_AXI_RREADY   ;
        output logic [ADDR_WIDTH-1:0] M_AXI_AWADDR   ;
        output logic [7:0] M_AXI_AWLEN    ;
        output logic [2:0] M_AXI_AWSIZE   ;
        output logic [1:0] M_AXI_AWBURST  ;
        output logic M_AXI_AWVALID  ;
        output logic [DATA_WIDTH-1:0] M_AXI_WDATA    ;
        output logic [DATA_WIDTH/8-1:0] M_AXI_WSTRB    ;
        output logic M_AXI_WLAST    ;
        output logic M_AXI_WVALID   ;
        output logic M_AXI_BREADY   ;


        logic [SYSTOLIC_SIZE*DATA_WIDTH-1:0] ifm_in;


// Qonnex
        /*AUTOWIRE*/
        // Beginning of automatic wires (for undeclared instantiated-module outputs)
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
        logic           ifm_req_valid;          // From buffer_controller_i1 of buffer_controller.v
        logic           ofm_data_last;          // From axi_master_i1 of AXI_master.v
        wire [SYSTOLIC_SIZE*DATA_WIDTH-1:0] ofm_out;// From PE_array_i1 of PE_array.v
        logic [15:0]    rd_en_buffer;           // From buffer_controller_i1 of buffer_controller.v
        logic [11:0]    rd_ifm_addr;            // From buffer_controller_i1 of buffer_controller.v
        logic [2*SA_SIZE-2:0] reset_pe_1;       // From PE_arr_controller_i1 of PE_arr_controller.v
        logic [2*SA_SIZE-2:0] reset_pe_2;       // From PE_arr_controller_i1 of PE_arr_controller.v
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
   .M_AXI_ARADDR(M_AXI_ARADDR),
   .M_AXI_ARLEN(M_AXI_ARLEN),
   .M_AXI_ARSIZE(M_AXI_ARSIZE),
   .M_AXI_ARBURST(M_AXI_ARBURST),
   .M_AXI_ARVALID(M_AXI_ARVALID),
   .M_AXI_RREADY(M_AXI_RREADY),
   .M_AXI_AWADDR(M_AXI_AWADDR),
   .M_AXI_AWLEN(M_AXI_AWLEN),
   .M_AXI_AWSIZE(M_AXI_AWSIZE),
   .M_AXI_AWBURST(M_AXI_AWBURST),
   .M_AXI_AWVALID(M_AXI_AWVALID),
   .M_AXI_WDATA(M_AXI_WDATA),
   .M_AXI_WSTRB(M_AXI_WSTRB),
   .M_AXI_WLAST(M_AXI_WLAST),
   .M_AXI_WVALID(M_AXI_WVALID),
   .M_AXI_BREADY(M_AXI_BREADY),
   );
   */
  AXI_master 
  axi_master_i1(/*AUTOINST*/
                // Outputs
                .M_AXI_ARADDR           (M_AXI_ARADDR),          // Templated
                .M_AXI_ARLEN            (M_AXI_ARLEN),           // Templated
                .M_AXI_ARSIZE           (M_AXI_ARSIZE),          // Templated
                .M_AXI_ARBURST          (M_AXI_ARBURST),         // Templated
                .M_AXI_ARVALID          (M_AXI_ARVALID),         // Templated
                .M_AXI_RREADY           (M_AXI_RREADY),          // Templated
                .ifm_data               (ifm_data[DATA_WIDTH-1:0]),
                .wgt_data_valid         (wgt_data_valid),
                .ifm_data_valid         (ifm_data_valid),
                .ofm_data_last          (ofm_data_last),
                .M_AXI_AWADDR           (M_AXI_AWADDR),          // Templated
                .M_AXI_AWLEN            (M_AXI_AWLEN),           // Templated
                .M_AXI_AWSIZE           (M_AXI_AWSIZE),          // Templated
                .M_AXI_AWBURST          (M_AXI_AWBURST),         // Templated
                .M_AXI_AWVALID          (M_AXI_AWVALID),         // Templated
                .M_AXI_WDATA            (M_AXI_WDATA),           // Templated
                .M_AXI_WSTRB            (M_AXI_WSTRB),           // Templated
                .M_AXI_WLAST            (M_AXI_WLAST),           // Templated
                .M_AXI_WVALID           (M_AXI_WVALID),          // Templated
                .M_AXI_BREADY           (M_AXI_BREADY),          // Templated
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
                       .reset_pe_1      (reset_pe_1[2*SA_SIZE-2:0]),
                       .reset_pe_2      (reset_pe_2[2*SA_SIZE-2:0]),
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
   .wgt_in('0),
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
              .wgt_in                   ('0),                    // Templated
              .ifm_in                   (ifm_in[SYSTOLIC_SIZE*DATA_WIDTH-1:0]));

  /*
   buffer_controller AUTO_TEMPLATE (
   .RVALID(M_AXI_RVALID),
   .RLAST(M_AXI_RLAST),
   .RREADY(M_AXI_RREADY),
   .RDATA(M_AXI_RDATA),
   .ifm_channel(12'd3),
   .kernel_size(12'd3),
   .num_filter(12'd16),
   .maxpool_stride(12'd1),
   .stride(12'd1),
   .ifm_width_tile(12'd128),
   .ifm_height_tile(12'd9),
   .ofm_width(12'd416),
   .ofm_height(12'd416),
   .ifm_width(12'd418),
   .ifm_height(12'd418),
   .num_channel(12'd16),
   );
   */
  buffer_controller 
  buffer_controller_i1(/*AUTOINST*/
                       // Outputs
                       .ifm_req_valid   (ifm_req_valid),
                       .wr_ifm_addr     (wr_ifm_addr[11:0]),
                       .rd_ifm_addr     (rd_ifm_addr[11:0]),
                       .wr_en_buffer    (wr_en_buffer),
                       .rd_en_buffer    (rd_en_buffer[15:0]),
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
                       .ifm_channel     (12'd3),                 // Templated
                       .kernel_size     (12'd3),                 // Templated
                       .num_filter      (12'd16),                // Templated
                       .maxpool_stride  (12'd1),                 // Templated
                       .stride          (12'd1),                 // Templated
                       .ifm_width_tile  (12'd128),               // Templated
                       .ifm_height_tile (12'd9),                 // Templated
                       .ofm_width       (12'd416),               // Templated
                       .ofm_height      (12'd416),               // Templated
                       .ifm_width       (12'd418),               // Templated
                       .ifm_height      (12'd418),               // Templated
                       .num_channel     (12'd16),                // Templated
                       .exe_1row_done   (exe_1row_done),
                       .RVALID          (M_AXI_RVALID),          // Templated
                       .RLAST           (M_AXI_RLAST),           // Templated
                       .RREADY          (M_AXI_RREADY),          // Templated
                       .RDATA           (M_AXI_RDATA),           // Templated
                       .ifm_data_valid  (ifm_data_valid),
                       .wgt_data_valid  (wgt_data_valid),
                       .ofm_data_valid  (ofm_data_valid));

  /*
   buffer_array AUTO_TEMPLATE (
   .read_en(rd_en_buffer),
   .write_en(wr_en_buffer),
   .write_addr(wr_ifm_addr),
   .data_in(M_AXI_RDATA),
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
                  .data_in              (M_AXI_RDATA),           // Templated
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

endmodule

// Local Variables:
// verilog-library-directories: ("/home/luu_k64/project/DNN_accelerator_base_Systolic_Array/vivado/DNN_core/DNN_core.srcs/sources_1/new_1")
// End:
// End:
