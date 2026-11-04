`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2026 08:29:00 PM
// Design Name: 
// Module Name: PE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PE #(
	parameter DATA_WIDTH = 16 
) (
	input                               clk            ,
	input                               rst_n          ,
	input                               reset_pe_1     ,
	input                               reset_pe_2     ,
	input                               enable         ,
	input                               write_out_en   ,
	input                               sel_out_mux    ,
	input                               sel_out_de_mux ,
	input      signed [DATA_WIDTH - 1 : 0   ]  top_in         ,
	input      signed [DATA_WIDTH - 1 : 0   ]  left_in        ,
	input      signed [DATA_WIDTH - 1 : 0   ]  mac_in         ,
	output reg signed [DATA_WIDTH - 1 : 0   ]  bottom_out     ,
	output reg signed [DATA_WIDTH - 1 : 0   ]  right_out      ,
	output reg signed [DATA_WIDTH - 1 : 0   ]  mac_out
);

	reg   signed [DATA_WIDTH - 1 : 0] m_reg      ;
	reg   signed [DATA_WIDTH - 1 : 0] result_1   ;
	reg   signed [DATA_WIDTH - 1 : 0] result_2   ;
	wire  signed [DATA_WIDTH - 1 : 0] result_out ;

	assign result_out = (sel_out_mux) ? result_2 : result_1;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			result_1     <= {(DATA_WIDTH){1'b0}} ;
			result_2     <= {(DATA_WIDTH){1'b0}} ;
			bottom_out   <= {DATA_WIDTH{1'b0}}     ;
			right_out    <= {DATA_WIDTH{1'b0}}     ;
			mac_out      <= {DATA_WIDTH{1'b0}}     ;
			m_reg <= '0;
		end
		else if (enable) begin
		  m_reg      <= left_in * top_in;
		  result_1   <= (reset_pe_1) ? {(DATA_WIDTH){1'b0}} : (!sel_out_de_mux ) ? (result_1 + m_reg) : result_1 ;
		  result_2   <= (reset_pe_2) ? {(DATA_WIDTH){1'b0}} : (sel_out_de_mux ) ? (result_2 + m_reg) : result_2  ;
		  bottom_out <= top_in                               ;
		  right_out  <= left_in                              ;
		  mac_out    <= (write_out_en) ? mac_in : result_out ;
		end
		else begin
			mac_out    <= (write_out_en) ? mac_in : result_out ;
		  bottom_out <= bottom_out                               ;
		  right_out  <= right_out                              ;
		end
	end
endmodule
