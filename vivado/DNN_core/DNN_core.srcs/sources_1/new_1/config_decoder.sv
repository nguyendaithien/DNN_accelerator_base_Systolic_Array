module conv_config_decoder (
    input  logic [10:0] ifm_channel_in,
    input  logic [3:0]  kernel_size_in,
    input  logic [7:0]  num_filter_in,
    input  logic [7:0]  maxpool_mode_in,
    input  logic [1:0]  maxpool_stride_in,
    input  logic [2:0]  stride_in,

    input  logic [11:0] ifm_width_in,
    input  logic [11:0] ifm_height_in,
    input  logic [11:0] ifm_width_tile_in,
    input  logic [11:0] ifm_height_tile_in,

    input  logic [3:0]  maxpool_kernel_size_in,
    input  logic [3:0]  padding_in,

    output logic [11:0] conv_ofm_width,
    output logic [11:0] conv_ofm_height,
    output logic [10:0] conv_ofm_channel,

    output logic [11:0] ofm_width,
    output logic [11:0] ofm_height,
    output logic [10:0] ofm_channel,

    output logic [10:0] ifm_channel,
    output logic [3:0]  kernel_size,
    output logic [7:0]  num_filter,
    output logic [7:0]  maxpool_mode,
    output logic [1:0]  maxpool_stride,
    output logic [2:0]  stride,
    output logic [11:0] ifm_width_tile,
    output logic [11:0] ifm_height_tile,
    output logic [11:0] ifm_width,
    output logic [11:0] ifm_height
);

    logic [12:0] conv_width_temp;
    logic [12:0] conv_height_temp;
    logic [12:0] pool_width_temp;
    logic [12:0] pool_height_temp;
    logic [12:0] conv_width_input;
    logic [12:0] conv_height_input;

    assign ifm_channel     = ifm_channel_in;
    assign kernel_size     = kernel_size_in;
    assign num_filter      = num_filter_in;
    assign maxpool_mode    = maxpool_mode_in;
    assign maxpool_stride  = maxpool_stride_in;
    assign stride          = stride_in;
    assign ifm_width_tile  = ifm_width_tile_in;
    assign ifm_height_tile = ifm_height_tile_in;
    assign ifm_width       = ifm_width_in;
    assign ifm_height      = ifm_height_in;

    always_comb begin
        conv_width_temp  = 0;
        conv_height_temp = 0;
        pool_width_temp  = 0;
        pool_height_temp = 0;

        conv_width_input  = ifm_width_in + (padding_in << 1);
        conv_height_input = ifm_height_in + (padding_in << 1);

        conv_ofm_width   = 0;
        conv_ofm_height  = 0;
        conv_ofm_channel = {3'b000, num_filter_in};

        ofm_width  = 0;
        ofm_height = 0;
        ofm_channel = conv_ofm_channel;

        // CONV output dimensions
        if (stride_in != 0 && kernel_size_in != 0 &&
            conv_width_input >= kernel_size_in &&
            conv_height_input >= kernel_size_in) begin

            case (stride_in)
                1: begin
                    conv_width_temp  = conv_width_input - kernel_size_in + 1;
                    conv_height_temp = conv_height_input - kernel_size_in + 1;
                end

                2: begin
                    conv_width_temp  = ((conv_width_input - kernel_size_in) >> 1) + 1;
                    conv_height_temp = ((conv_height_input - kernel_size_in) >> 1) + 1;
                end

                4: begin
                    conv_width_temp  = ((conv_width_input - kernel_size_in) >> 2) + 1;
                    conv_height_temp = ((conv_height_input - kernel_size_in) >> 2) + 1;
                end

                default: begin
                    conv_width_temp  = 0;
                    conv_height_temp = 0;
                end
            endcase
        end

        conv_ofm_width  = conv_width_temp[11:0];
        conv_ofm_height = conv_height_temp[11:0];

        // Default: no MaxPool
        ofm_width  = conv_ofm_width;
        ofm_height = conv_ofm_height;

        // MaxPool output dimensions
        if (maxpool_mode_in != 0 &&
            maxpool_stride_in != 0 &&
            maxpool_kernel_size_in != 0 &&
            conv_ofm_width >= maxpool_kernel_size_in &&
            conv_ofm_height >= maxpool_kernel_size_in) begin

            case (maxpool_stride_in)
                1: begin
                    pool_width_temp  = conv_ofm_width - maxpool_kernel_size_in + 1;
                    pool_height_temp = conv_ofm_height - maxpool_kernel_size_in + 1;
                end

                2: begin
                    pool_width_temp  = ((conv_ofm_width - maxpool_kernel_size_in) >> 1) + 1;
                    pool_height_temp = ((conv_ofm_height - maxpool_kernel_size_in) >> 1) + 1;
                end

                default: begin
                    pool_width_temp  = 0;
                    pool_height_temp = 0;
                end
            endcase

            ofm_width  = pool_width_temp[11:0];
            ofm_height = pool_height_temp[11:0];
        end
    end

endmodule
