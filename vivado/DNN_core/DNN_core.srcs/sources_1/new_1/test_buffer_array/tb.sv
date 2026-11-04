`timescale 1ns / 1ps

module tb_buffer_array;

    parameter int DATA_WIDTH = 16;
    parameter int ROWS       = 5;
    parameter int COLS       = 32;
    parameter int TOTAL      = ROWS * COLS;

    logic clk;
    logic rst_n;

    logic [15:0] read_en;
    logic        write_en;
    logic [DATA_WIDTH-1:0] data_in;


   	logic [11:0] write_addr;
    logic [11:0] read_addr_0;
    logic [11:0] read_addr_1;
    logic [11:0] read_addr_2;
    logic [11:0] read_addr_3;
    logic [11:0] read_addr_4;
    logic [11:0] read_addr_5;
    logic [11:0] read_addr_6;
    logic [11:0] read_addr_7;
    logic [11:0] read_addr_8;
    logic [11:0] read_addr_9;
    logic [11:0] read_addr_10;
    logic [11:0] read_addr_11;
    logic [11:0] read_addr_12;
    logic [11:0] read_addr_13;
    logic [11:0] read_addr_14;
    logic [11:0] read_addr_15;

    logic [DATA_WIDTH-1:0] data_out_0;
    logic [DATA_WIDTH-1:0] data_out_1;
    logic [DATA_WIDTH-1:0] data_out_2;
    logic [DATA_WIDTH-1:0] data_out_3;
    logic [DATA_WIDTH-1:0] data_out_4;
    logic [DATA_WIDTH-1:0] data_out_5;
    logic [DATA_WIDTH-1:0] data_out_6;
    logic [DATA_WIDTH-1:0] data_out_7;
    logic [DATA_WIDTH-1:0] data_out_8;
    logic [DATA_WIDTH-1:0] data_out_9;
    logic [DATA_WIDTH-1:0] data_out_10;
    logic [DATA_WIDTH-1:0] data_out_11;
    logic [DATA_WIDTH-1:0] data_out_12;
    logic [DATA_WIDTH-1:0] data_out_13;
    logic [DATA_WIDTH-1:0] data_out_14;
    logic [DATA_WIDTH-1:0] data_out_15;

    logic [DATA_WIDTH-1:0] random_data [0:ROWS-1][0:COLS-1];

    int index;
    int row;
    int col;

    buffer_array #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(160)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),

        .read_en(read_en),
        .write_en(write_en),
        .data_in(data_in),

        .write_addr(write_addr),

        .read_addr_0 (read_addr_0),
        .read_addr_1 (read_addr_1),
        .read_addr_2 (read_addr_2),
        .read_addr_3 (read_addr_3),
        .read_addr_4 (read_addr_4),
        .read_addr_5 (read_addr_5),
        .read_addr_6 (read_addr_6),
        .read_addr_7 (read_addr_7),
        .read_addr_8 (read_addr_8),
        .read_addr_9 (read_addr_9),
        .read_addr_10(read_addr_10),
        .read_addr_11(read_addr_11),
        .read_addr_12(read_addr_12),
        .read_addr_13(read_addr_13),
        .read_addr_14(read_addr_14),
        .read_addr_15(read_addr_15),

        .data_out_0(data_out_0),
        .data_out_1(data_out_1),
        .data_out_2(data_out_2),
        .data_out_3(data_out_3),
        .data_out_4(data_out_4),
        .data_out_5(data_out_5),
        .data_out_6(data_out_6),
        .data_out_7(data_out_7),
        .data_out_8(data_out_8),
        .data_out_9(data_out_9),
        .data_out_10(data_out_10),
        .data_out_11(data_out_11),
        .data_out_12(data_out_12),
        .data_out_13(data_out_13),
        .data_out_14(data_out_14),
        .data_out_15(data_out_15)
    );

		initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 1'b0;
        write_en = 1'b0;
        read_en = '0;
        data_in = '0;

        read_addr_0  = '0;
        read_addr_1  = '0;
        read_addr_2  = '0;
        read_addr_3  = '0;
        read_addr_4  = '0;
        read_addr_5  = '0;
        read_addr_6  = '0;
        read_addr_7  = '0;
        read_addr_8  = '0;
        read_addr_9  = '0;
        read_addr_10 = '0;
        read_addr_11 = '0;
        read_addr_12 = '0;
        read_addr_13 = '0;
        read_addr_14 = '0;
        read_addr_15 = '0;


        repeat (3) @(negedge clk);
        rst_n = 1'b1;

        // Generate random positive values.
        for (int r = 0; r < ROWS; r++) begin
            for (int c = 0; c < COLS; c++) begin
                random_data[r][c] = $urandom_range(1, 10);
            end
        end

        $display("Generated random data:");

        for (int r = 0; r < ROWS; r++) begin
            for (int c = 0; c < COLS; c++) begin
                $write("%5d ", random_data[r][c]);
            end
            $display("");
        end

        // Write one value per clock cycle.
        index = 0;

        for (int r = 0; r < ROWS; r++) begin
            for (int c = 0; c < COLS; c++) begin
                @(negedge clk);

                data_in = random_data[r][c];

                // Sequential addresses: 0 to 159.
                write_addr  = index;

                write_en = 1'b1;


                index++;
            end
        end

        @(negedge clk);
        write_en = 1'b0;
        data_in = '0;

			  $display ("================ READ OPERATION ====================");
			  #10; read_addr_0 = 0;
			  #5; read_en[0] = 1;
			  #5; read_addr_0 = 1;
			  #10; read_addr_0 = 2;
			  #10; read_addr_0 = 32;
			  #10; read_addr_0 = 33;
			  #10; read_addr_0 = 34;
			  #10; read_addr_0 = 64;
			  #10; read_addr_0 = 65;
			  #10; read_addr_0 = 66;

			  #10; read_addr_1 = 0;
			  #5;  read_en[1] = 1;
			  #5;  read_addr_1 = 1;
			  #10; read_addr_1 = 2;
			  #10; read_addr_1 = 32;
			  #10; read_addr_1 = 33;
			  #10; read_addr_1 = 34;
			  #10; read_addr_1 = 64;
			  #10; read_addr_1 = 65;
			  #10; read_addr_1 = 66;

			  #10; read_addr_2 = 0;
			  #5;  read_en[2] = 1;
			  #5;  read_addr_2 = 1;
			  #10; read_addr_2 = 2;
			  #10; read_addr_2 = 32;
			  #10; read_addr_2 = 33;
			  #10; read_addr_2 = 34;
			  #10; read_addr_2 = 64;
			  #10; read_addr_2 = 65;
			  #10; read_addr_2 = 66;
				
        repeat (3) @(negedge clk);
		end

	initial begin
		dut.rlast_cond = 0;
		dut.axi_read_fire = 0;
		dut.cnt_ifm = 0;
		dut.cnt_ifm_load = 0;
		dut.ifm_height_tile = 9;
		dut.ifm_width_tile = 128;
		dut.wr_addr_buffer = 0;
		dut.cnt_channel_read = 0;
// CHANNEL COUNTER = 0
		#1000;
		dut.cnt_channel_read = 0;
		dut.cnt_ifm_load = 100;
		#20;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 101;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 102;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 103;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 104;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 105;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 106;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;
// CHANNEL COUNTER = 1
		#1000;
		dut.cnt_channel_read = 1;
		dut.cnt_ifm_load = 225;
		#20;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 226;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 227;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 228;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 229;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

// CHANNEL COUNTER = 2
		#1000;
		dut.cnt_channel_read = 2;
		$display(" CNT channel READ = 2 : %d", $time);
		dut.cnt_ifm_load = 320;
		#20;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 321;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

		#50;
		dut.cnt_ifm_load = 322;
		#10;
		dut.axi_read_fire = 1;
		#1270;
		dut.axi_read_fire = 1;
		dut.rlast_cond = 1;
		#10;
		dut.axi_read_fire = 0;
		dut.rlast_cond = 0;

	end

		initial begin 
			#100000;
			$finish;
		end
		initial begin

  force dut.exe_1row_done = 0;
	#10000;
			#16
  force dut.exe_1row_done = 1;
	#100;
  force dut.exe_1row_done = 0;
	#100;
  force dut.exe_1row_done = 1;
	#100;
  force dut.exe_1row_done = 0;
	#100;
  force dut.exe_1row_done = 1;
	#100;
  force dut.exe_1row_done = 0;
	#100;
  force dut.exe_1row_done = 1;
	#100;
  force dut.exe_1row_done = 0;
	#100;
  force dut.exe_1row_done = 1;
	#100;
  force dut.exe_1row_done = 0;
	#100;
		force dut.cnt_row_ofm_clr = 0; 
	#10;
		force dut.cnt_row_ofm_clr = 1; 
	#1000;
    end
// test SA controller
	initial begin
		dut.compute_en = 0;
    dut.cnt_compute_max = 0;
		#100;
    dut.cnt_compute_max = 27;
		#1000;	
		dut.compute_en = 1;

		#10000;
	end



endmodule
