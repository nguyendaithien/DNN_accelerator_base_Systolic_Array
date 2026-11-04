module ifm_buffer_addr_dut #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 16
) (
    input  wire                  clk,
    input  wire                  rst_n,

    // Control
    input  wire                  data_valid,
    input  wire                  compute_en,

    // Configuration
    input  wire [5:0]            kernel_size,
    input  wire [11:0]           num_kernel,
    input  wire [11:0]           ofm_col_size,
    input  wire [11:0]           ofm_row_size_buffer,
    input  wire [5:0]            stride,
    input  wire [11:0]           ifm_width_tile,
    input  wire [11:0]           ifm_height_tile,

    // Counter outputs for testbench
    output reg  [5:0]            cnt_pixel,
    output reg  [5:0]            cnt_row,
    output reg  [11:0]           cnt_kernel,
    output reg  [11:0]           cnt_ofm_buffer_col,
    output reg  [11:0]           cnt_row_ofm_buffer,
    output reg  [11:0]           cnt_ofm_row,

    // IFM buffer read interface
    output wire                  ifm_buffer_rd_en,
    output wire [ADDR_WIDTH-1:0] ifm_buffer_address
);

    // ---------------------------------------------------------
    // Counter match conditions
    // ---------------------------------------------------------

    wire cnt_pixel_match =
        (cnt_pixel == kernel_size - 1'b1);

    wire cnt_row_match =
        (cnt_row == kernel_size - 1'b1);

    wire cnt_kernel_match =
        (cnt_kernel == num_kernel - 1'b1);

    wire cnt_ofm_col_match =
        (cnt_ofm_buffer_col == ofm_col_size - 1'b1);

    wire cnt_ofm_row_buffer_match =
        (cnt_row_ofm_buffer == ofm_row_size_buffer - 1'b1);

    // Advance the address traversal only when computation is enabled
    wire step = compute_en && data_valid;

    wire pixel_done = step && cnt_pixel_match;
    wire kernel_row_done = pixel_done && cnt_row_match;
    wire kernel_done = kernel_row_done && cnt_kernel_match;
    wire ofm_col_done = kernel_done && cnt_ofm_col_match;
    wire ofm_row_done = ofm_col_done && cnt_ofm_row_buffer_match;

    // ---------------------------------------------------------
    // Pixel counter: position within a kernel row
    // ---------------------------------------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_pixel <= '0;
        else if (step) begin
            if (cnt_pixel_match)
                cnt_pixel <= '0;
            else
                cnt_pixel <= cnt_pixel + 1'b1;
        end
    end

    // ---------------------------------------------------------
    // Kernel row counter
    // ---------------------------------------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_row <= '0;
        else if (pixel_done) begin
            if (cnt_row_match)
                cnt_row <= '0;
            else
                cnt_row <= cnt_row + 1'b1;
        end
    end

    // ---------------------------------------------------------
    // Kernel/channel counter
    // ---------------------------------------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_kernel <= '0;
        else if (kernel_row_done) begin
            if (cnt_kernel_match)
                cnt_kernel <= '0;
            else
                cnt_kernel <= cnt_kernel + 1'b1;
        end
    end

    // ---------------------------------------------------------
    // OFM column counter
    // ---------------------------------------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_ofm_buffer_col <= '0;
        else if (kernel_done) begin
            if (cnt_ofm_col_match)
                cnt_ofm_buffer_col <= '0;
            else
                cnt_ofm_buffer_col <= cnt_ofm_buffer_col + 1'b1;
        end
    end

    // ---------------------------------------------------------
    // OFM row counter within the output buffer
    // ---------------------------------------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_row_ofm_buffer <= '0;
        else if (ofm_col_done) begin
            if (cnt_ofm_row_buffer_match)
                cnt_row_ofm_buffer <= '0;
            else
                cnt_row_ofm_buffer <= cnt_row_ofm_buffer + 1'b1;
        end
    end

    // ---------------------------------------------------------
    // Global OFM row counter
    // ---------------------------------------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_ofm_row <= '0;
        else if (ofm_row_done)
            cnt_ofm_row <= cnt_ofm_row + 1'b1;
    end

    // ---------------------------------------------------------
    // IFM buffer read address
    // ---------------------------------------------------------

    wire [31:0] ifm_row_global;
    wire [31:0] ifm_row_local;
    wire [31:0] ifm_col;
    wire [31:0] addr_calc;

    // Global IFM row needed for the current kernel position
    assign ifm_row_global =
        cnt_ofm_row * stride + cnt_row;

    // Map global IFM row to a circular row-buffer slot
    assign ifm_row_local =
        (ifm_height_tile != 0)
        ? (ifm_row_global % ifm_height_tile)
        : 32'd0;

    // IFM column needed for the current OFM column/kernel position
    assign ifm_col =
        cnt_ofm_buffer_col * stride + cnt_pixel;

    // Address units are DATA_WIDTH-sized IFM elements, not bytes
    assign addr_calc =
        cnt_kernel * ifm_height_tile * ifm_width_tile
        + ifm_row_local * ifm_width_tile
        + ifm_col;

    assign ifm_buffer_address = addr_calc[ADDR_WIDTH-1:0];

    // Read enable: asserted when a valid compute step is requested
    assign ifm_buffer_rd_en = step;

endmodule

