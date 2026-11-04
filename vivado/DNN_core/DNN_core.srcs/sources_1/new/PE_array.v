`timescale 1 ns / 1 ps
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
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module PE_array #(
    parameter DATA_WIDTH    = 16 ,
    parameter SYSTOLIC_SIZE = 16
) (
    input                                           clk           ,
    input                                           rst_n         ,
    input  [SYSTOLIC_SIZE * 2 - 2 : 0]              reset_pe_1    ,
    input  [SYSTOLIC_SIZE * 2 - 2 : 0]              reset_pe_2    ,
    input                                           enable        ,
    input                                           write_out_en  ,
    input                                           sel_out_mux   ,
    input                                           sel_out_de_mux,
    input  [SYSTOLIC_SIZE * DATA_WIDTH - 1 : 0]     wgt_in        ,
    input  [SYSTOLIC_SIZE * DATA_WIDTH - 1 : 0]     ifm_in        ,
    output [SYSTOLIC_SIZE * DATA_WIDTH - 1 : 0]     ofm_out
);

wire [SYSTOLIC_SIZE * SYSTOLIC_SIZE * DATA_WIDTH     - 1 : 0] right_out ;
wire [SYSTOLIC_SIZE * SYSTOLIC_SIZE * DATA_WIDTH     - 1 : 0] bottom_out;
wire [SYSTOLIC_SIZE * SYSTOLIC_SIZE * DATA_WIDTH     - 1 : 0] mac_out   ;

genvar i, j;
generate
    for (i = 0; i < SYSTOLIC_SIZE; i = i + 1) begin : row
        for (j = 0; j < SYSTOLIC_SIZE; j = j + 1) begin : col
            PE #(.DATA_WIDTH (DATA_WIDTH)) pe_inst (
                .clk          ( clk                                                                                                                                        ) ,
                .rst_n        ( rst_n                                                                                                                                      ) ,
                .reset_pe_1   ( reset_pe_1 [i+j]                                                                                                                           ) ,
                .reset_pe_2   ( reset_pe_2 [i+j]                                                                                                                           ) ,
                .enable       ( enable                                                                                                                                     ) ,
                .write_out_en ( write_out_en                                                                                                                               ) ,
                .sel_out_mux  ( sel_out_mux                                                                                                                                ) ,
                .sel_out_de_mux( sel_out_de_mux                                                                                                                            ) ,
                .top_in       ( (i == 0                ) ? wgt_in [j*DATA_WIDTH +: DATA_WIDTH] : bottom_out [((i-1)*SYSTOLIC_SIZE + j) * DATA_WIDTH +: DATA_WIDTH]       ) ,
                .left_in      ( (j == 0                ) ? ifm_in [i*DATA_WIDTH +: DATA_WIDTH] : right_out  [(i*SYSTOLIC_SIZE + (j-1)) * DATA_WIDTH +: DATA_WIDTH]       ) ,
                .mac_in       ( (i == SYSTOLIC_SIZE - 1) ? {(DATA_WIDTH){1'b0}}                  : mac_out    [((i+1)*SYSTOLIC_SIZE + j) * DATA_WIDTH +: DATA_WIDTH]     ) ,
                .bottom_out   ( bottom_out [(i*SYSTOLIC_SIZE + j) * DATA_WIDTH   +: DATA_WIDTH]                                                                          ) ,
                .right_out    ( right_out  [(i*SYSTOLIC_SIZE + j) * DATA_WIDTH   +: DATA_WIDTH]                                                                          ) ,
                .mac_out      ( mac_out    [(i*SYSTOLIC_SIZE + j) * DATA_WIDTH +: DATA_WIDTH]                                                                        )
            );
        end
    end
endgenerate

assign ofm_out = {
    mac_out[15*DATA_WIDTH +: DATA_WIDTH],
    mac_out[14*DATA_WIDTH +: DATA_WIDTH],
    mac_out[13*DATA_WIDTH +: DATA_WIDTH],
    mac_out[12*DATA_WIDTH +: DATA_WIDTH],
    mac_out[11*DATA_WIDTH +: DATA_WIDTH],
    mac_out[10*DATA_WIDTH +: DATA_WIDTH],
    mac_out[9 *DATA_WIDTH +: DATA_WIDTH],
    mac_out[8 *DATA_WIDTH +: DATA_WIDTH],
    mac_out[7 *DATA_WIDTH +: DATA_WIDTH],
    mac_out[6 *DATA_WIDTH +: DATA_WIDTH],
    mac_out[5 *DATA_WIDTH +: DATA_WIDTH],
    mac_out[4 *DATA_WIDTH +: DATA_WIDTH],
    mac_out[3 *DATA_WIDTH +: DATA_WIDTH],
    mac_out[2 *DATA_WIDTH +: DATA_WIDTH],
    mac_out[1 *DATA_WIDTH +: DATA_WIDTH],
    mac_out[0 *DATA_WIDTH +: DATA_WIDTH]
};

endmodule
