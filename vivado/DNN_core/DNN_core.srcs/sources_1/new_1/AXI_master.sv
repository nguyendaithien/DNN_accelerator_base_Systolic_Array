`timescale 1ns / 1ps
module AXI_master #(
    parameter int ADDR_WIDTH = 12,
    parameter int DATA_WIDTH = 16,
    parameter int BURST_LEN  = 128,
    parameter int BEAT_SIZE  = 2
)(
    input  logic                   ACLK,
    input  logic                   ARESETN,

    // =========================================================
    // Buffer Controller interface
    // =========================================================
    input  logic                   ifm_req_valid,
    input  logic [11:0]            rd_ifm_addr,

    // =========================================================
    // AXI4 Read Address Channel (AR)
    // =========================================================
    output logic [ADDR_WIDTH-1:0]  M_AXI_ARADDR,
    output logic [7:0]             M_AXI_ARLEN,
    output logic [2:0]             M_AXI_ARSIZE,
    output logic [1:0]             M_AXI_ARBURST,
    output logic                   M_AXI_ARVALID,
    input  logic                   M_AXI_ARREADY,

    // =========================================================
    // AXI4 Read Data Channel (R)
    // =========================================================
    input  logic [DATA_WIDTH-1:0]  M_AXI_RDATA,
    input  logic [1:0]             M_AXI_RRESP,
    input  logic                   M_AXI_RLAST,
    input  logic                   M_AXI_RVALID,
    output logic                   M_AXI_RREADY,

    // =========================================================
    // Read data output to Buffer
    // =========================================================
    output logic [DATA_WIDTH-1:0]  ifm_data,
    output logic                   ifm_data_valid,
    output logic                   wgt_data_valid,
    output logic                   ifm_data_valid,
    output logic                   ofm_data_last,

    // =========================================================
    // AXI4 Write Address Channel (AW)
    // =========================================================
    output logic [ADDR_WIDTH-1:0]  M_AXI_AWADDR,
    output logic [7:0]             M_AXI_AWLEN,
    output logic [2:0]             M_AXI_AWSIZE,
    output logic [1:0]             M_AXI_AWBURST,
    output logic                   M_AXI_AWVALID,
    input  logic                   M_AXI_AWREADY,

    // =========================================================
    // AXI4 Write Data Channel (W)
    // =========================================================
    output logic [DATA_WIDTH-1:0]  M_AXI_WDATA,
    output logic [DATA_WIDTH/8-1:0] M_AXI_WSTRB,
    output logic                   M_AXI_WLAST,
    output logic                   M_AXI_WVALID,
    input  logic                   M_AXI_WREADY,

    // =========================================================
    // AXI4 Write Response Channel (B)
    // =========================================================
    input  logic [1:0]             M_AXI_BRESP,
    input  logic                   M_AXI_BVALID,
    output logic                   M_AXI_BREADY
);

	localparam [2:0] READ_IDLE = 3'b000;
	localparam [2:0] READ_ADDR = 3'b001;
	localparam [2:0] READ_DATA = 3'b010;
	
	reg [2:0] read_state;
	always @(posedge ACLK or negedge ARESETN) begin
	    if (!ARESETN) begin
	        read_state      <= READ_IDLE;
	        M_AXI_ARADDR    <= '0;
	        M_AXI_ARVALID   <= 1'b0;
	        M_AXI_RREADY    <= 1'b0;
	
	        ifm_data        <= '0;
	        ifm_data_valid  <= 1'b0;
	        ifm_data_last   <= 1'b0;
	    end else begin
	        ifm_data_valid <= 1'b0;
	        ifm_data_last  <= 1'b0;
	        case (read_state)
	            READ_IDLE: begin
	                M_AXI_ARVALID <= 1'b0;
	                M_AXI_RREADY  <= 1'b0;
	
	                if (ifm_req_valid) begin
	                    M_AXI_ARADDR  <= rd_ifm_addr;
	                    M_AXI_ARVALID <= 1'b1;
	                    read_state    <= READ_ADDR;
	                end
	            end
	
	            READ_ADDR: begin
	                if (M_AXI_ARVALID && M_AXI_ARREADY) begin
	                    M_AXI_ARVALID <= 1'b0;
	                    M_AXI_RREADY  <= 1'b1;
	                    read_state    <= READ_DATA;
	                end
	            end
	
	            READ_DATA: begin
	                if (M_AXI_RVALID && M_AXI_RREADY) begin
	                    ifm_data       <= M_AXI_RDATA;
	                    ifm_data_valid <= 1'b1;
	
	                    if (M_AXI_RLAST) begin
	                        ifm_data_last <= 1'b1;
	                        M_AXI_RREADY  <= 1'b0;
	                        read_state    <= READ_IDLE;
	                    end
	                end
	            end
	
	            default: begin
	                read_state    <= READ_IDLE;
	                M_AXI_ARVALID <= 1'b0;
	                M_AXI_RREADY  <= 1'b0;
	            end
	
	        endcase
	    end
	end
	
	always_comb begin
	    M_AXI_AWADDR  = '0;
	    M_AXI_AWLEN   = '0;
	    M_AXI_AWSIZE  = '0;
	    M_AXI_AWBURST = 2'b01;
	    M_AXI_AWVALID = 1'b0;
	
	    M_AXI_WDATA   = '0;
	    M_AXI_WSTRB   = '0;
	    M_AXI_WLAST   = 1'b0;
	    M_AXI_WVALID  = 1'b0;
	    M_AXI_BREADY  = 1'b0;
	end

endmodule

