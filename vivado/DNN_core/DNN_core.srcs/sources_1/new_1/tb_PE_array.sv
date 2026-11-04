`timescale 1 ns / 1 ps

module PE_array_tb #(
);

	localparam task_all = 0;
	localparam task_1   = 1;
	localparam task_2   = 0;
	localparam task_3   = 0;
	
	
	localparam DATA_WIDTH    = 16            ;
	localparam SYSTOLIC_SIZE = 16            ;
	localparam HEIGHT        = 16            ;
	localparam WIDTH         = 27            ;
	localparam DEPTH         = HEIGHT*WIDTH  ;
	localparam OFM_RAM_SIZE  = 256           ;
	localparam ADDR_WIDTH    = $clog2(DEPTH) ;
	localparam IFM_HEIGHT = 12;
	localparam IFM_WIDTH = 128;
//	localparam WGT_HEIGHT = ;
//	localparam WGT_WIDTH = 128;



  logic                                           clk;
  logic                                           rst_n;
  logic [SYSTOLIC_SIZE * 2 - 2 : 0]               reset_pe_1;
  logic [SYSTOLIC_SIZE * 2 - 2 : 0]               reset_pe_2;
  logic                                           enable;
  logic                                           write_out_en;
  logic                                           sel_out_mux;
  logic                                           sel_out_de_mux;

  logic [SYSTOLIC_SIZE * DATA_WIDTH - 1 : 0] ofm_out;

    // ============================================================
    // DUT: PE_array
    // ============================================================

	logic ifm_wea;
	logic ifm_web;
	logic [15:0] ifm_ena;
	logic [15:0] ifm_enb;
	logic [13*16 - 1 :0] ifm_addra ;
	logic [13*16 - 1 :0] ifm_addrb ;
	logic [16 * 16 - 1:0] ifm_douta;
	logic [16 * 16 - 1:0] ifm_doutb;

	logic wgt_wea;
	logic wgt_web;
	logic [15:0] wgt_ena;
	logic [15:0] wgt_enb;
	logic [6*16-1:0] wgt_addra ;
	logic [6*16-1:0] wgt_addrb ;
	logic [16 * 16 -1 :0] wgt_douta;
	logic [16 * 16 -1 :0] wgt_doutb;



  PE_array #(
      .DATA_WIDTH    (DATA_WIDTH),
      .SYSTOLIC_SIZE (SYSTOLIC_SIZE)
  ) dut (
      .clk           (clk            ) ,
      .rst_n         (rst_n          ) ,
      .reset_pe_1    (reset_pe_1     ) ,
      .reset_pe_2    (reset_pe_2     ) ,
      .enable        (enable         ) ,
      .write_out_en  (write_out_en   ) ,
      .sel_out_mux   (sel_out_mux    ) ,
      .sel_out_de_mux(sel_out_de_mux ) ,
      .wgt_in        (wgt_doutb      ) ,
      .ifm_in        (ifm_doutb      ) ,  // IFM BUFFEER TO SA
      .ofm_out       (ofm_out        )
  );

	genvar i;
	generate
	    for (i = 0; i < 16; i = i + 1) begin : GEN_IFM_BUFFER
	        dual_port_ram #(
	            .DATA_WIDTH (16),
	            .DEPTH      (6000),
	            .ADDR_WIDTH (13)
	        ) ifm_buffer (
	            .clka   (clk),
	            .ena    (ifm_ena[i]),
	            .wea    (ifm_wea),
	            .addra  (ifm_addra[ i*13 +: 13  ]),
	            .dina   (),  // WRITE PORT
	            .douta  (ifm_douta[ i*DATA_WIDTH +: DATA_WIDTH]),
	
	            .clkb   (clk),
	            .enb    (ifm_enb[i]),
	            .web    (ifm_web),
	            .addrb  (ifm_addrb[ i*13 +: 13 ]),
	            .dinb   (),
	            .doutb  (ifm_doutb [i*DATA_WIDTH +: DATA_WIDTH] ) // READ PORT
	        );
	    end
	endgenerate

	generate
	    for (i = 0; i < 16; i = i + 1) begin : GEN_WGT_BUFFER
	        dual_port_ram #(
	            .DATA_WIDTH (16),
	            .DEPTH      (50),
	            .ADDR_WIDTH (6)
	        ) wgt_buffer (
	            .clka   (clk),
	            .ena    (wgt_ena[i]),
	            .wea    (wgt_wea),
	            .addra  (wgt_addra[ i*6 +: 6 ]),
	            .dina   (),  // WRITE PORT
	            .douta  (wgt_douta[ i*DATA_WIDTH +: DATA_WIDTH  ]),
	
	            .clkb   (clk),
	            .enb    (wgt_enb[i]),
	            .web    (wgt_web),
	            .addrb  (wgt_addrb[ i*6 +: 6  ]),
	            .dinb   (),
	            .doutb  (wgt_doutb[ i*DATA_WIDTH +: DATA_WIDTH  ]) // READ PORT
	        );
	    end
	endgenerate
	integer fd;
	integer k;
	integer j;
	integer value;

	initial begin
		fd = $fopen ("./cnn_2d_data/ifm.dec", "r");
		if(fd == 0) begin
			$finish;
			$display (" ERROR: canot open file ifm.bin");
		end

		for (j = 0; j < 128*4*3 ; j = j + 1) begin
			if($fscanf(fd, "%d", value) != 1) begin
				$display("Canot read IFM[%0d]", j);
				$finish;
			end

			GEN_IFM_BUFFER[0].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[1].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[2].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[3].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[4].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[5].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[6].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[7].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[8].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[9].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[10].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[11].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[12].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[13].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[14].ifm_buffer.mem[j] = value;
			GEN_IFM_BUFFER[15].ifm_buffer.mem[j] = value;
		end
	end

integer fi;
integer file_idx;
integer ram_idx;
integer ram_addr;

string bin_str;
//logic signed [15:0] value;

initial begin

    fi = $fopen("./cnn_2d_data/weight.bin", "r");

    if (fi == 0) begin
        $display("ERROR: Cannot open weight.bin");
        $finish;
    end

    // 16 RAM × 27 values
    for (file_idx = 0; file_idx < 16*27; file_idx = file_idx + 1) begin

        // Read one binary 16-bit value
        if ($fscanf(fi, "%s", bin_str) != 1) begin
            $display("ERROR: Cannot read file[%0d]", file_idx);
            $finish;
        end

        // Binary string -> 16-bit value
        if ($sscanf(bin_str, "%b", value) != 1) begin
            $display("ERROR: Cannot convert file[%0d] = %s",
                     file_idx, bin_str);
            $finish;
        end

        // ------------------------------------------------
        // Determine RAM and address
        // ------------------------------------------------
        ram_idx  = file_idx / 27;
        ram_addr = file_idx % 27;

        // Debug
        $display("file[%0d] -> RAM[%0d].mem[%0d] = %0d",
                 file_idx,
                 ram_idx,
                 ram_addr,
                 $signed(value));

        // ------------------------------------------------
        // Write to corresponding RAM
        // ------------------------------------------------
        case (ram_idx)

            0: GEN_WGT_BUFFER[0].wgt_buffer.mem[ram_addr] = value;
            1: GEN_WGT_BUFFER[1].wgt_buffer.mem[ram_addr] = value;
            2: GEN_WGT_BUFFER[2].wgt_buffer.mem[ram_addr] = value;
            3: GEN_WGT_BUFFER[3].wgt_buffer.mem[ram_addr] = value;
            4: GEN_WGT_BUFFER[4].wgt_buffer.mem[ram_addr] = value;
            5: GEN_WGT_BUFFER[5].wgt_buffer.mem[ram_addr] = value;
            6: GEN_WGT_BUFFER[6].wgt_buffer.mem[ram_addr] = value;
            7: GEN_WGT_BUFFER[7].wgt_buffer.mem[ram_addr] = value;
            8: GEN_WGT_BUFFER[8].wgt_buffer.mem[ram_addr] = value;
            9: GEN_WGT_BUFFER[9].wgt_buffer.mem[ram_addr] = value;
            10: GEN_WGT_BUFFER[10].wgt_buffer.mem[ram_addr] = value;
            11: GEN_WGT_BUFFER[11].wgt_buffer.mem[ram_addr] = value;
            12: GEN_WGT_BUFFER[12].wgt_buffer.mem[ram_addr] = value;
            13: GEN_WGT_BUFFER[13].wgt_buffer.mem[ram_addr] = value;
            14: GEN_WGT_BUFFER[14].wgt_buffer.mem[ram_addr] = value;
            15: GEN_WGT_BUFFER[15].wgt_buffer.mem[ram_addr] = value;

        endcase

    end

    $fclose(fi);

    $display("======================================");
    $display("Finished loading %0d values", 16*27);
    $display("======================================");

end
task automatic display_matrix (
     input int rows,
     input int cols,
     input string matrix_name,
			input integer wgt = 0,
	input integer ifm = 0,
	ref reg signed [DATA_WIDTH-1:0] ram [0:6000 -1],
	ref reg signed [DATA_WIDTH-1:0] ram_1 [0:50 -1]);
	  #100;
    $display(" ================================================= ");
    $display(" ====== MATRIX %s =========", matrix_name);
    $display(" row: %d, cols: %d", rows, cols);

		if(ifm) begin
    for (int i = 0; i < rows; i++) begin
        for (int j = 0; j < cols; j++) begin
            $write("%d ", ram[i * cols + j]);
        end
        $write("\n");
    end
		end else if (wgt) begin
    for (int i = 0; i < rows; i++) begin
        for (int j = 0; j < cols; j++) begin
            $write("%d ", ram_1[i * cols + j]);
        end
        $write("\n");
    end
		end
endtask
initial begin 
	#100;
	display_matrix (12, 128, "IFM buffer 1",0,1,GEN_IFM_BUFFER[0].ifm_buffer.mem,GEN_WGT_BUFFER[0].wgt_buffer.mem );
	display_matrix (12, 128, "IFM buffer 1",0,1,GEN_IFM_BUFFER[7].ifm_buffer.mem, GEN_WGT_BUFFER[0].wgt_buffer.mem );
	display_matrix (3, 9, "WGT buffer 1",1,0,GEN_IFM_BUFFER[7].ifm_buffer.mem , GEN_WGT_BUFFER[0].wgt_buffer.mem);
	display_matrix (3, 9, "WGT buffer 1",1,0,GEN_IFM_BUFFER[7].ifm_buffer.mem ,GEN_WGT_BUFFER[7].wgt_buffer.mem);
	#1000;
	$finish;
end


endmodule
