
module pe_arr_controller #(
    parameter DATA_WIDTH = 16,
    parameter SA_SIZE = 16
)(
	input  logic        clk  ,
	input  logic        rst_n,
	input  logic compute_en,
	input  logic [11:0] cnt_compute_max,

	output logic exe_1row_done,
	output logic exe_ready,
	output logic [15:0] reset_pe_1,
	output logic [15:0] reset_pe_2,
	output logic enable,
	output logic write_out_en,
	output logic sel_out_mux,
	output logic sel_out_de_mux
);

	localparam IDLE    = 3'b000;
	localparam INIT    = 3'b001;
	localparam SET_UP  = 3'b010;
	localparam COMPUTE = 3'b011;
	localparam WAIT    = 3'b100;

	reg [1:0] c_state, n_state;
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
			reset_pe_1     <= 0; 
			reset_pe_2     <= 0;
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
					reset_pe_1 <= 0;
				  reset_pe_2 <= 0;
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
					reset_pe_1 <= 0;
					reset_pe_2 <= 0;
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

//	reg [11:0] cnt_wr_ofm;
//	wire cnt_wr_ofm_clr, cnt_wr_ofm_en;
//	assign cnt_wr_ofm_en = (cnt_wr_ofm == 0) && (c_state == SET_UP);
//	always @(posedge clk or negedge rst_n) begin
//		if(!rst_n)
//			cnt_wr_ofm <= 0;
//		else if(c_state == SET_UP || c_state == COMPUTE)
//			cnt_wr_ofm <= (cnt_wr_ofm <= 16) ? cnt_wr_ofm + 1 : 0;
//	end

	wire write_out_en_nxt;
  assign write_out_en_nxt = write_out_en ? (cnt_compute <= 15) : (c_state == SET_UP);
  always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			write_out_en <= 0;
		else
			write_out_en <= write_out_en_nxt;
	end
endmodule
