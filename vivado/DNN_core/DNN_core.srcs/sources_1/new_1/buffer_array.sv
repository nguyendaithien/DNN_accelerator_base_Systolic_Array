
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
