
`timescale 1ns / 1ps
module buffer_array #(
    parameter int DATA_WIDTH = 16,
    parameter int DEPTH      = 432
)(
    input  logic                  clk,
    input  logic                  rst_n,

    input  logic [15:0]           read_en,
    input  logic                  write_en,
    input  logic [DATA_WIDTH-1:0] data_in,

    input  logic [11:0]           write_addr,

    input  logic [11:0]           read_addr_0,
    input  logic [11:0]           read_addr_1,
    input  logic [11:0]           read_addr_2,
    input  logic [11:0]           read_addr_3,
    input  logic [11:0]           read_addr_4,
    input  logic [11:0]           read_addr_5,
    input  logic [11:0]           read_addr_6,
    input  logic [11:0]           read_addr_7,
    input  logic [11:0]           read_addr_8,
    input  logic [11:0]           read_addr_9,
    input  logic [11:0]           read_addr_10,
    input  logic [11:0]           read_addr_11,
    input  logic [11:0]           read_addr_12,
    input  logic [11:0]           read_addr_13,
    input  logic [11:0]           read_addr_14,
    input  logic [11:0]           read_addr_15,

    output logic [DATA_WIDTH-1:0] data_out_0,
    output logic [DATA_WIDTH-1:0] data_out_1,
    output logic [DATA_WIDTH-1:0] data_out_2,
    output logic [DATA_WIDTH-1:0] data_out_3,
    output logic [DATA_WIDTH-1:0] data_out_4,
    output logic [DATA_WIDTH-1:0] data_out_5,
    output logic [DATA_WIDTH-1:0] data_out_6,
    output logic [DATA_WIDTH-1:0] data_out_7,
    output logic [DATA_WIDTH-1:0] data_out_8,
    output logic [DATA_WIDTH-1:0] data_out_9,
    output logic [DATA_WIDTH-1:0] data_out_10,
    output logic [DATA_WIDTH-1:0] data_out_11,
    output logic [DATA_WIDTH-1:0] data_out_12,
    output logic [DATA_WIDTH-1:0] data_out_13,
    output logic [DATA_WIDTH-1:0] data_out_14,
    output logic [DATA_WIDTH-1:0] data_out_15
);
// test cmt_row_ofm_image
	logic exe_1row_done;
	reg exe_1row_done_dly1, exe_1row_done_dly2, exe_1row_done_pl;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			exe_1row_done_dly1  <= 1'b0;
		else 
			exe_1row_done_dly1 <= exe_1row_done;
	end
	always @(negedge clk or negedge rst_n) begin
		if(!rst_n)
			exe_1row_done_dly2  <= 1'b0;
		else 
			exe_1row_done_dly2 <= exe_1row_done_dly1;
	end
	reg [11:0] cnt_row_ofm_image; 
	wire [11:0] cnt_row_ofm_image_nxt; 
	wire cnt_row_ofm_clr;
	assign exe_1row_done_pl = !exe_1row_done_dly2 && exe_1row_done;
	assign cnt_row_ofm_en = exe_1row_done_pl;
  assign cnt_row_ofm_image_nxt = cnt_row_ofm_image + 1;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_row_ofm_image <= '0;
		else if (cnt_row_ofm_clr)
			cnt_row_ofm_image <= '0;
		else if (cnt_row_ofm_en)
			cnt_row_ofm_image <= cnt_row_ofm_image_nxt;
	end
	wire [3:0] stride = 1;
	logic [11:0] cnt_kernel;
	logic [11:0] cnt_pixel;
	logic [11:0] cnt_row;
	logic compute_en;
	logic [11:0] kernel_size;
	logic [11:0] cnt_tile_buffer;
	logic [11:0] ifm_width_tile;
	logic  [11:0] ifm_height_tile;
	localparam SA_SIZE = 16;
	assign cnt_row_real = ((cnt_row + cnt_row_ofm_image*stride) % ifm_height_tile); 
	assign ifm_buffer_address_0  = 0*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_1  = 1*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_2  = 2*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_3  = 3*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;


	assign cnt_pixel_match   = (cnt_pixel    == (kernel_size - 1    )) ;
	wire cnt_pixel_en, cnt_pixel_clr;
	assign cnt_pixel_clr = cnt_pixel_match;
	//============ COUNTER PIXEL OF KERNEL ==============//
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) 
			cnt_pixel <= '0;
		else if (cnt_pixel_clr) 
			cnt_pixel <= '0;
		else if (compute_en)
			cnt_pixel <= cnt_pixel + '1 ;
	end

	assign cnt_row_match = (cnt_row  == (kernel_size - 1)) ;
	assign cnt_row_en  = cnt_pixel_match; 
	assign cnt_row_clr = cnt_row_match && 
											 cnt_pixel_match;

	//============ COUNTER ROW OF KERNEL ==============//
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_row <= '0;
		else if (cnt_row_clr)
			cnt_row <= '0;
		else if (cnt_row_en)
			cnt_row <= cnt_row + '1;
	end

	// test wr_addr_buffer // address for ifm stored in buffer after loading from off chip mem
	logic rlast_cond;
	logic axi_read_fire;
	reg [11:0] cnt_ifm;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_ifm <= '0;
		else if(rlast_cond) // clear when get maximum = RLAST && RVALID && RREADY
			cnt_ifm <= '0;
		else if(axi_read_fire) // counting when new pixel loaded
			cnt_ifm <= cnt_ifm + 1;
	end
	logic [11:0] cnt_ifm_load;
	wire  [11:0] req_ifm_row;
	wire  [11:0] req_buffer_row;
	assign req_ifm_row     = cnt_ifm_load + 1'b1;
	assign req_buffer_row  = req_ifm_row % ifm_height_tile;
	// wr_addr_buffer
	wire [11:0] wr_addr_buffer_nxt;
	wire [11:0] wr_base_addr;
	reg [11:0] wr_addr_buffer;
	logic [11:0] cnt_channel_read;
	assign wr_addr_buffer_nxt = wr_base_addr + cnt_ifm;
	assign wr_base_addr = req_buffer_row * ifm_width_tile + 
											 ifm_width_tile*ifm_height_tile*cnt_channel_read;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) 
			wr_addr_buffer <= '0;
		else
			wr_addr_buffer <= wr_addr_buffer_nxt;
	end

	// TEST SA controller //
	//
	
	logic [11:0] cnt_compute_max ;

	logic exe_ready         ;
	logic [15:0] reset_pe_1 ;
	logic [15:0] reset_pe_2 ;
	logic enable            ;
	logic write_out_en      ;
	logic sel_out_mux       ;
	logic sel_out_de_mux    ;

	localparam IDLE    = 3'b000;
	localparam INIT    = 3'b001;
	localparam SET_UP  = 3'b010;
	localparam COMPUTE = 3'b011;
	localparam WAIT    = 3'b100;

	reg [2:0] c_state, n_state;
	wire cnt_cmp_get_max; 
	reg [11:0] cnt_compute;
  wire cnt_compute_en, cnt_compute_clr;
	assign cnt_cmp_get_max = (cnt_compute == cnt_compute_max);
	
	assign cnt_compute_en = (c_state == COMPUTE) ? 1'b1 : 1'b0;
	assign cnt_compute_clr =((c_state == COMPUTE) && (cnt_compute == (cnt_compute_max)))? 1'b1 : 1'b0;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			exe_1row_done  <= 0;  
			exe_ready      <= 0;       		
			reset_pe_1     <= '0; 
			reset_pe_2     <= '0;
			enable         <= 0;
			sel_out_de_mux <= 0;    
      sel_out_mux    <= 0;
			c_state        <= IDLE;
		end else begin
			case(c_state)
				IDLE: begin
				 	if(compute_en) c_state <= INIT;
				end
				INIT: begin
					c_state <= COMPUTE;
					exe_ready <= 1;
					reset_pe_1 <= '0;
				  reset_pe_2 <= '0;
					enable <= 1;
					sel_out_de_mux <= 0;   // select reg 1 
          sel_out_mux    <= 0; // init with reg 1
					exe_1row_done <= 0;
				end
				SET_UP: begin
					exe_1row_done <= 0;
					exe_ready <= 0;
					reset_pe_1 <= (sel_out_mux) ? 16'h0 : 16'hFFFF;
					reset_pe_2 <= (sel_out_mux) ? 16'hFFFF : 16'h0;
					enable <= 1;
					sel_out_de_mux <= !sel_out_de_mux;   // select reg 1 
					exe_ready <= 1;
      		sel_out_mux    <= !sel_out_mux;
					exe_1row_done <= 1;
					if(compute_en) c_state <= COMPUTE;
				end
				COMPUTE: begin
				 	if(cnt_cmp_get_max) c_state <= SET_UP;
					exe_ready <= 1;
					reset_pe_1 <= '0;
					reset_pe_2 <= '0;
					enable <= 1;
					exe_1row_done <= 0;
				end
			default: c_state <= IDLE;
		endcase
	end
	end


	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_compute <= 0;
		else if(cnt_compute_clr)
			cnt_compute <= 0;
		else if(cnt_compute_en)
			cnt_compute <= cnt_compute + 1;
	end

///	reg [11:0] cnt_wr_ofm;
///	always @(posedge clk or negedge rst_n) begin
///		if(!rst_n)
///			cnt_wr_ofm <= 0;
///		else if(c_state == SET_UP || c_state == COMPUTE)
///			cnt_wr_ofm <= (cnt_wr_ofm <= 16) ? cnt_wr_ofm + 1 : 0;
///	end

	wire write_out_en_nxt;
  assign write_out_en_nxt = write_out_en ? (cnt_compute <= 15) : (c_state == SET_UP);
  always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			write_out_en <= 0;
		else
			write_out_en <= write_out_en_nxt;
	end
	// END // 

	    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_0 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[0]),
        .read_addr  (read_addr_0),
        .dout       (data_out_0)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_1 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[1]),
        .read_addr  (read_addr_1),
        .dout       (data_out_1)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_2 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[2]),
        .read_addr  (read_addr_2),
        .dout       (data_out_2)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_3 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[3]),
        .read_addr  (read_addr_3),
        .dout       (data_out_3)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_4 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[4]),
        .read_addr  (read_addr_4),
        .dout       (data_out_4)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_5 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[5]),
        .read_addr  (read_addr_5),
        .dout       (data_out_5)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_6 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[6]),
        .read_addr  (read_addr_6),
        .dout       (data_out_6)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_7 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[7]),
        .read_addr  (read_addr_7),
        .dout       (data_out_7)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_8 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[8]),
        .read_addr  (read_addr_8),
        .dout       (data_out_8)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_9 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[9]),
        .read_addr  (read_addr_9),
        .dout       (data_out_9)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_10 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[10]),
        .read_addr  (read_addr_10),
        .dout       (data_out_10)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_11 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[11]),
        .read_addr  (read_addr_11),
        .dout       (data_out_11)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_12 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[12]),
        .read_addr  (read_addr_12),
        .dout       (data_out_12)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_13 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[13]),
        .read_addr  (read_addr_13),
        .dout       (data_out_13)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_14 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[14]),
        .read_addr  (read_addr_14),
        .dout       (data_out_14)
    );

    RAM_2ports #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_15 (
        .clk        (clk),
        .rst        (~rst_n),
        .write_en   (write_en),
        .write_addr (write_addr),
        .write_data (data_in),
        .read_en    (read_en[15]),
        .read_addr  (read_addr_15),
        .dout       (data_out_15)
    );
endmodule
