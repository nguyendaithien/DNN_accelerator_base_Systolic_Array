module buffer_controller #(
    parameter DATA_WIDTH = 16,
    parameter SA_SIZE = 16
)(
	input  logic        clk               ,
	input  logic        rst_n             ,
	
	input  logic [11:0] ifm_channel       , // number of ifm channel
	input  logic [11:0]  kernel_size       ,
	input  logic [11:0]  num_filter        , // number of channel out
	input  logic [11:0]  maxpool_stride    ,
	input  logic [11:0]  stride            ,
	input  logic [11:0] ifm_width_tile    , // IFM width (not fixed)
	input  logic [11:0] ifm_height_tile   , // IFM height (not fixed)
	input  logic [11:0] ofm_width   ,
	input  logic [11:0] ofm_height  ,
	input  logic [11:0] ifm_width   ,
	input  logic [11:0] ifm_height  ,
	input  logic [11:0] num_channel ,
	
// From Systolic Array	
	input logic exe_1row_done, // SA has been done a row of OFM

// ============== AXI connection ===================
	input logic RVALID, // From AXI master
	input logic RLAST,
	input logic RREADY,
	input logic [15:0] RDATA,
	input logic ifm_data_valid, // for distinguish between differental data: IFM, weight, ofm 
	input logic wgt_data_valid,
	input logic ofm_data_valid,

	// to AXI master 
	output logic ifm_req_valid,

	// to Buffer_array
	output logic [11:0] wr_ifm_addr,
	output logic [11:0] rd_ifm_addr,	
	output logic wr_en_buffer,
	output logic [15:0] rd_en_buffer,
	// IFM buffer read address

	output logic [11:0] ifm_buffer_address_0, 
	output logic [11:0] ifm_buffer_address_1, 
	output logic [11:0] ifm_buffer_address_2, 
	output logic [11:0] ifm_buffer_address_3, 
	output logic [11:0] ifm_buffer_address_4, 
	output logic [11:0] ifm_buffer_address_5, 
	output logic [11:0] ifm_buffer_address_6, 
	output logic [11:0] ifm_buffer_address_7, 
	output logic [11:0] ifm_buffer_address_8, 
	output logic [11:0] ifm_buffer_address_9, 
	output logic [11:0] ifm_buffer_address_10, 
	output logic [11:0] ifm_buffer_address_11, 
	output logic [11:0] ifm_buffer_address_12, 
	output logic [11:0] ifm_buffer_address_13, 
	output logic [11:0] ifm_buffer_address_14, 
	output logic [11:0] ifm_buffer_address_15, 

	// To PE array or PE array controller
	output wire compute_en
		
);

	logic [11:0] ofm_col_size; // width of OFM with differental stride
	logic [11:0] ofm_row_size_buffer; // height of OFM with differental stride
	logic [11:0] ifm_buffer_address;
	logic [11:0] wgt_address_max;
	
	assign wgt_address_max = kernel_size*kernel_size*ifm_channel*num_filter;

	// STATE MACHINE
	localparam IDLE           = 3'b000;
	localparam FIRST_WINDOW   = 3'b001;
	localparam OVERLAP_WINDOW = 3'b010;
  // ============================================================
  // Internal signals
  // ============================================================
	// COUNTER define 
	reg [5:0  ] cnt_pixel         ;
	reg [5:0  ] cnt_row           ; // cnt row of each kernel (Ex: kernel_size = 5 => cnt = 0,1,2,3,4)
	reg	[11:0 ] cnt_kernel        ; // kernel number: 256, 512...
	reg [11:0 ] cnt_ofm_row       ; // counter OFM row
	reg [11:0 ] cnt_row_buffer    ; // ID of first row of kernel, Ex: ifm_height_width = 4 => cnt_row_buffer = 0,1,2,3
	reg [11:0] cnt_tile_buffer;
	reg [11:0] cnt_row_ofm_buffer        ; // cnt row of all OFM (not only buffer)
	wire [11:0] cnt_ifm_reload_next;
	reg [11:0] cnt_ifm_reload;
	wire [11:0] cnt_ifm_reload_nxt;
	wire [11:0] cnt_row_ofm_image_nxt; 
	reg [11:0] cnt_row_ofm_image; 
	reg [11:0] cnt_ofm_image; // cnt_ofm_image is real ofm row of OFM (different to ofm row of buffer)
	reg [11:0] cnt_ifm_load;
	reg [11:0] cnt_channel_read;
	reg [11:0] cnt_ifm;
	reg [11:0] cnt_tile_col;
	wire cnt_channel_read_clr;
	wire cnt_ifm_load_en;
	wire cnt_ifm_load_clr;
	wire axi_read_fire, rlast_cond;

    // ============================================================
    // Controller logic
    // ============================================================
	
	wire cnt_pixel_match,cnt_row_match, cnt_kernel_match, cnt_ofm_col_buffer_match,cnt_row_ofm_buffer_match;
	wire cnt_tile_buffer_match; 
//	wire cnt_tile_ifm_row_match;
	assign cnt_pixel_match   = (cnt_pixel    == (kernel_size - 1    )) ;
	assign cnt_row_match     = (cnt_row      == (kernel_size - 1    )) ;
	assign cnt_kernel_match  = (cnt_kernel   == (ifm_channel  - 1    )) ;
	assign cnt_tile_buffer_match = (cnt_tile_buffer == ((ifm_width_tile % SA_SIZE) -1) ); 
//	assign cnt_row_ofm_match = (cnt_row_ofm == (ofm_height - 1));

	wire cnt_pixel_en, cnt_pixel_clr;
	wire cnt_row_en, cnt_row_clr;
	wire cnt_tile_ifm_row_en, cnt_tile_ifm_row_clr;

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

	wire cnt_kernel_clr;
	wire cnt_kernel_en; 
	assign cnt_kernel_clr = cnt_kernel_match && 
												  cnt_row_match && 
												  cnt_pixel_match;
	assign cnt_kernel_en  = cnt_row_match && 
												  cnt_pixel_match; 

	//============ COUNTER KERNEL ==============//
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_kernel <= '0;
		else if (cnt_kernel_clr)
			cnt_kernel <= '0;
		else if (cnt_kernel_en)
			cnt_kernel <= cnt_kernel + '1;
	end

	wire cnt_ofm_col_en,cnt_ofm_col_clr;
	assign cnt_ofm_col_clr = cnt_ofm_col_buffer_match && 
													 cnt_kernel_match && 
													 cnt_row_match && 
													 cnt_pixel_match;
	assign cnt_ofm_col_en  = cnt_kernel_match && 
													 cnt_row_match && 
													 cnt_pixel_match;



// =========================
//   cnt tile buffer: max = ifm_tile_width % SA_SIZE
// =========================
	wire cnt_tile_buffer_en; 
	wire cnt_tile_buffer_clr; 
	assign cnt_tile_buffer_en  =  cnt_kernel_match && 
													 			cnt_row_match && 
													 			cnt_pixel_match;
	assign cnt_tile_buffer_clr =  cnt_tile_buffer_match &&
																cnt_kernel_match &&
													 			cnt_row_match && 
													 			cnt_pixel_match;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_tile_buffer <= '0;
		else if(cnt_tile_buffer_clr)
			cnt_tile_buffer <= '0;
		else if(cnt_tile_buffer_en)
			cnt_tile_buffer <= cnt_tile_buffer + '1;
	end

// ======================= COMPUTE ENABLE AND LOAD ENABLE ==================================//
// COMPUTE BOUNDARY
	reg exe_1row_done_dly1, exe_1row_done_dly2;
	wire exe_1row_done_pl;
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
	wire cnt_row_ofm_en;
	assign exe_1row_done_pl = !exe_1row_done_dly2 && exe_1row_done;
	assign cnt_row_ofm_en = exe_1row_done_pl;
  assign cnt_row_ofm_image_nxt = cnt_row_ofm_image + 1;
	assign cnt_row_image_clr = (cnt_row_ofm_image == (ifm_height - 1)) && cnt_tile_buffer_clr;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_row_ofm_image <= '0;
		else if (cnt_row_image_clr)
			cnt_row_ofm_image <= '0;
		else if (cnt_row_ofm_en)
			cnt_row_ofm_image <= cnt_row_ofm_image_nxt;
	end

  wire [11:0] required_end;
	assign compute_en = (cnt_ifm_load >= required_end ) ? 1'b1 : 1'b0;
	assign required_end = (cnt_row_ofm_image + kernel_size); 

	wire [11:0] prefetch_require;
	wire ifm_req_valid_nxt;
	assign prefetch_require = (cnt_ifm_load - cnt_row_ofm_image);
	wire req_cond =  (prefetch_require < ifm_height_tile);
	assign ifm_req_valid_nxt    = ifm_req_valid ? (!rlast_cond) : req_cond; // ifm_height_tile is buffer size

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			ifm_req_valid <= '0;
		else
			ifm_req_valid <= ifm_req_valid_nxt;
	end
 // ===================== READ EN BUFFER ============================ 
	always @(negedge clk or negedge rst_n) begin
		if(!rst_n)
			rd_en_buffer <= 16'd0;
		else
			rd_en_buffer <= (rd_en_buffer << 1) | {15'b0,compute_en};
	end
	// ==================== WRITE BUFFER OPERATION: write_address, wr_en=====================================
	// cnt_ifm_load 
	assign axi_read_fire = RVALID && RREADY;
	assign rlast_cond = axi_read_fire && RLAST;
	assign cnt_ifm_load_en = cnt_channel_read_clr;
	assign cnt_ifm_load_clr = (cnt_ifm_load == ifm_height - 1) && rlast_cond;

	reg a1,a2;
	wire cnt_ifm_load_en_pl;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			a1 <= 1'b0;
		else
			a1 <= cnt_ifm_load_en;
	end
	always @(negedge clk or negedge rst_n) begin
		if(!rst_n)
			a2 <= 1'b0;
		else
			a2 <= a1;
	end
	assign cnt_ifm_load_en_pl = !a2 && cnt_ifm_load_en;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_ifm_load <= '0;
		else if(cnt_ifm_load_clr) 
			cnt_ifm_load <= '0;
		else if(cnt_ifm_load_en_pl) 
			cnt_ifm_load <= cnt_ifm_load + 1;
	end
	// write data en 
	always @(negedge clk or negedge rst_n) begin
		if(!rst_n)
			wr_en_buffer <= '0;
		else
			wr_en_buffer <= axi_read_fire;
	end
	// req buffer_row 
	wire [11:0] req_ifm_row;
	wire [11:0] req_buffer_row;
	assign req_ifm_row     = cnt_ifm_load + 1'b1;
	assign req_buffer_row  = req_ifm_row % ifm_height_tile;

	// cnt channel read
	assign get_max_channel = (cnt_channel_read == ifm_channel - 1);
	assign get_max_ifm =  (cnt_ifm == ifm_width_tile - 1);
	assign cnt_channel_read_clr = get_max_channel && get_max_ifm;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_channel_read <= '0;
		else if(cnt_channel_read_clr)
			cnt_channel_read <= '0;
		else if(rlast_cond)
			cnt_channel_read <= cnt_channel_read + 1;
	end

	// ================ WRITE ADDRESS BUFFER ======================
	wire [11:0] wr_addr_buffer_nxt;
	wire [11:0] wr_base_addr;
	assign wr_addr_buffer_nxt = wr_base_addr + cnt_ifm;
	assign wr_base_addr = req_buffer_row * ifm_width_tile +
			   ifm_width_tile*ifm_height_tile*cnt_channel_read;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) 
			wr_ifm_addr <= '0;
		else
			wr_ifm_addr <= wr_addr_buffer_nxt;
	end
	// cnt ifm: counting the pixel of each row of buffer (from 0-> 127)
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_ifm <= '0;
		else if(rlast_cond) // clear when get maximum = RLAST && RVALID && RREADY
			cnt_ifm <= '0;
		else if(axi_read_fire) // counting when new pixel loaded
			cnt_ifm <= cnt_ifm + 1;
	end
	// cnt_tile_col: ifm will be vertically load, then shift to right and continue next vertical load.
	wire cnt_tile_col_en;
	wire cnt_tile_col_clr;
	assign cnt_tile_col_en = (cnt_ifm_load == (ifm_height - 1)) && rlast_cond;
	assign cnt_tile_col_clr = (cnt_tile_col == (ifm_width % ifm_width_tile)) && cnt_ifm_load_clr;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_tile_col <= '0;
		else if(cnt_tile_col_clr)
			cnt_tile_col <= '0;
		else if(cnt_tile_col_en)
			cnt_tile_col <= cnt_tile_col + 1;
	end
	// read address: to AXI master
	wire [11:0] rd_ifm_addr_nxt; 
	assign rd_ifm_addr_nxt = req_ifm_row * ifm_width + cnt_channel_read*ifm_width*ifm_height
											 + cnt_tile_col * ifm_width_tile - kernel_size + 1; 
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
 			rd_ifm_addr <= '0;
		else
 			rd_ifm_addr <= rd_ifm_addr_nxt;
	end

	// =================================================================
	// ===================== sliding window address ====================
	// ================================================================= 
	wire [11:0] cnt_row_real;
	assign cnt_row_real = ((cnt_row + cnt_row_ofm_image*stride) % ifm_height_tile); 
	
	assign ifm_buffer_address_0  = 0*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_1  = 1*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_2  = 2*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_3  = 3*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_4  = 4*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_5  = 5*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_6  = 6*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_7  = 7*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_8  = 8*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_9  = 9*stride  + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_10 = 10*stride + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_11 = 11*stride + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_12 = 12*stride + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_13 = 13*stride + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_14 = 14*stride + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;
	assign ifm_buffer_address_15 = 15*stride + ifm_width_tile*(cnt_row_real + ifm_height_tile*cnt_kernel) + cnt_pixel + cnt_tile_buffer*SA_SIZE*stride;

endmodule
