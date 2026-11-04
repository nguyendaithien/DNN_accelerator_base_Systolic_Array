`timescale 1 ns / 1 ps
localparam task_1 = 1;
localparam task_2 = 0;
localparam task_3 = 0;
localparam task_4 = 0;


module PE_array_tb #(
);



localparam DATA_WIDTH    = 16            ;
localparam SYSTOLIC_SIZE = 16            ;
localparam HEIGHT        = 16            ;
localparam WIDTH         = 27            ;
localparam DEPTH         = HEIGHT*WIDTH  ;
localparam OFM_RAM_SIZE  = 256           ;
localparam ADDR_WIDTH    = $clog2(DEPTH) ;

    // ============================================================
    // Signal declarations
    // ============================================================

    logic                                           clk;
    logic                                           rst_n;
    logic [SYSTOLIC_SIZE * 2 - 2 : 0]               reset_pe_1;
    logic [SYSTOLIC_SIZE * 2 - 2 : 0]               reset_pe_2;
    logic                                           enable;
    logic                                           write_out_en;
    logic                                           sel_out_mux;
    logic                                           sel_out_de_mux;

//    logic [SYSTOLIC_SIZE * DATA_WIDTH - 1 : 0]     wgt_in;
//    logic [SYSTOLIC_SIZE * DATA_WIDTH - 1 : 0]     ifm_in;

    logic [SYSTOLIC_SIZE * DATA_WIDTH - 1 : 0] ofm_out;


    // ============================================================
    // DUT: PE_array
    // ============================================================


	integer fd;
	integer i;
	integer k;
	integer j;
	integer value;
	reg signed [DATA_WIDTH-1:0] A1_RAM [0:(16*27)-1];
	reg signed [DATA_WIDTH-1:0] A2_RAM [0:(16*75)-1];
	reg signed [DATA_WIDTH-1:0] A3_RAM [0:(16*147)-1];

	logic [DATA_WIDTH*HEIGHT-1:0] dout_ifm;
	logic [ADDR_WIDTH*HEIGHT-1:0] addr_ifm;

	logic [DATA_WIDTH-1:0] din_ifm;
	logic [SYSTOLIC_SIZE-1:0]re_ifm;
	logic we_ifm;

	logic [DATA_WIDTH*HEIGHT-1:0] dout_wgt;
	logic [ADDR_WIDTH*HEIGHT-1:0] addr_wgt;
	logic [DATA_WIDTH-1:0] din_wgt;
	logic [SYSTOLIC_SIZE-1:0]re_wgt;
	logic we_wgt;

	logic [DATA_WIDTH*HEIGHT-1:0] dout_ofm;
	logic [ADDR_WIDTH*HEIGHT-1:0] addr_ofm;
	logic [DATA_WIDTH-1:0] din_ofm;

  PE_array #(
      .DATA_WIDTH    (DATA_WIDTH),
      .SYSTOLIC_SIZE (SYSTOLIC_SIZE)
  ) dut (
      .clk           (clk),
      .rst_n         (rst_n),
      .reset_pe_1    (reset_pe_1),
      .reset_pe_2    (reset_pe_2),
      .enable        (enable),
      .write_out_en  (write_out_en),
      .sel_out_mux   (sel_out_mux),
      .sel_out_de_mux(sel_out_de_mux),
      .wgt_in        (dout_wgt),
      .ifm_in        (dout_ifm),
      .ofm_out       (ofm_out)
  );

	logic      [$clog2(OFM_RAM_SIZE) - 1 : 0] ofm_write_addr;
	logic we_ofm;
	logic [$clog2(256) - 1 : 0] ofm_read_addr  ;
	logic re_ofm;

DPRAM #(
  .RAM_SIZE          ( OFM_RAM_SIZE) ,
  .DATA_WIDTH        ( DATA_WIDTH )    ,
  .INOUT_WIDTH       ( DATA_WIDTH*SYSTOLIC_SIZE)    ,
  .SYSTOLIC_SIZE     ( 16 )  
) ofm_ram_rtl_1 (
    .clk     (clk            ) ,
    .re_a    (re_ofm         ) ,
    .addr_a  (ofm_read_addr     ) ,
    .dout_a  (dout_ofm       ) ,
    .we_b    (we_ofm         ) ,
    .addr_b  (ofm_write_addr     ) ,
    .din_b   (ofm_out        )
    
);
RAM #(
    .DATA_WIDTH (DATA_WIDTH )            ,
		.HEIGHT     (HEIGHT     )            , 
		.WIDTH      (WIDTH      )            , 
		.DEPTH      ( HEIGHT*WIDTH)          ,
		.ADDR_WIDTH ( $clog2(DEPTH))
) ifm_bank_a1(
		.clk  (clk  ) ,
		.rst_n(rst_n) ,
		.we   (we_ifm   ) ,
		.re   (re_ifm   ) ,
		.addr (addr_ifm ) ,
		.din  (din_ifm ) ,
		.dout (dout_ifm )  
);
RAM #(
    .DATA_WIDTH (DATA_WIDTH )            ,
		.HEIGHT     (HEIGHT     )            , 
		.WIDTH      (WIDTH      )            , 
		.DEPTH      ( HEIGHT*WIDTH)          ,
		.ADDR_WIDTH ( $clog2(DEPTH))
) wgt_bank_b1(
		.clk  (clk  ) ,
		.rst_n(rst_n) ,
		.we   (we_wgt   ) ,
		.re   (re_wgt   ) ,
		.addr (addr_wgt ) ,
		.din  (din_wgt ) ,
		.dout (dout_wgt )  
);
RAM #(
    .DATA_WIDTH (DATA_WIDTH )            ,
		.HEIGHT     (HEIGHT     )            , 
		.WIDTH      (WIDTH      )            , 
		.DEPTH      ( HEIGHT*WIDTH)          ,
		.ADDR_WIDTH ( $clog2(DEPTH))
) ofm_bank_c1(
		.clk  () ,
		.rst_n() ,
		.we   () ,
		.re   () ,
		.addr () ,
		.din  () ,
		.dout ()  
);


`include "task.sv"

always #5 clk = ~clk;

initial begin
	if(task_1) begin
////// start with reg 1
	clk = 0;
	enable = 0;
	addr_ifm = '0;
	addr_wgt = '0;
	re_ifm = '0;
	re_wgt = '0;
	rst_n = 1;
	#10;
	rst_n=0;
	#10;
	rst_n = 1;
	#50;
	$display ("=======================================");
	$display ("============TEST WITH REG 1============");
	$display ("=======================================");
	fork
		display_matrix (16, 27, "MATRIX A1", ifm_bank_a1.ram);
		display_matrix (16, 27, "MATRIX B1", wgt_bank_b1.ram);
		display_matrix (16, 16, "MATRIX C1", ofm_bank_c1.ram);
	join
	/////// START COMPUTING /////////////////////
	set_pe_reg1;
	fork
			set_ifm_addr   (27,0);
			set_wgt_addr   (27,0);
			buffer_control (27,0);
	join
	#160; // 16 cycle before read OFM
  // start store OFMs	
	read_ofm;
	#10
	compare(1);
	#1000;

	end

	if(task_2) begin
////// start with reg 2
	$display ("=======================================");
	$display ("============TEST WITH REG 2============");
	$display ("=======================================");
	enable = 0;
	addr_ifm = '0;
	addr_wgt = '0;
	re_ifm = '0;
	re_wgt = '0;
	rst_n = 1;
	#50;

	fork
		display_matrix (16, 27, "MATRIX A1", ifm_bank_a1.ram);
		display_matrix (16, 27, "MATRIX B1", wgt_bank_b1.ram);
		display_matrix (16, 16, "MATRIX C1", ofm_bank_c1.ram);
	join
	/////// START COMPUTING /////////////////////
	set_pe_reg2;
	fork
			set_ifm_addr   (27,9);
			set_wgt_addr   (27,9);
			buffer_control (27,9);
	join
	#160; // 16 cycle before read OFM
  // start store OFMs	
	read_ofm;
	#10
	compare(1);
	#1000;
	end
	#1000;
	$finish;
end

// DISPLAY 3 MATRIX //
task automatic display_matrix (
     input int rows,
     input int cols,
     input string matrix_name,
	   ref logic signed [DATA_WIDTH-1:0] ram [0:HEIGHT*WIDTH-1]);
	  #100;
    $display(" ================================================= ");
    $display(" ====== MATRIX %s =========", matrix_name);
    $display(" row: %d, cols: %d", rows, cols);

    for (int i = 0; i < rows; i++) begin
        for (int j = 0; j < cols; j++) begin
            $write("%4d ", ram[i * cols + j]);
        end
        $write("\n");
    end
endtask


initial begin

    fd = $fopen("A.txt", "r");

    if (fd == 0) begin
        $display("ERROR: Cannot open A.txt");
        $finish;
    end

    // ========================================================
    // Load A1: 16 x 27
    // ========================================================

    for (i = 0; i < 16*27; i = i + 1) begin

        if ($fscanf(fd, "%d", value) != 1) begin
            $display("ERROR: Cannot read A1[%0d]", i);
            $finish;
        end

        ifm_bank_a1.ram[i] = value;

    end


    // ========================================================
    // Load A2: 16 x 75
    // ========================================================

    for (i = 0; i < 16*75; i = i + 1) begin

        if ($fscanf(fd, "%d", value) != 1) begin
            $display("ERROR: Cannot read A2[%0d]", i);
            $finish;
        end

        A2_RAM[i] = value;

    end


    // ========================================================
    // Load A3: 16 x 147
    // ========================================================

    for (i = 0; i < 16*147; i = i + 1) begin

//        if ($fscanf(fd, "%d", value) != 1) begin
//            $display("ERROR: Cannot read A3[%0d]", i);
//            $finish;
//        end
//
        A3_RAM[i] = value;

    end


    $fclose(fd);

    $display("A.txt loaded successfully.");

end
integer fd_b;
integer value_b;
reg signed [DATA_WIDTH-1:0] B1_RAM [0:27*16-1];
reg signed [DATA_WIDTH-1:0] B2_RAM [0:75*16-1];
reg signed [DATA_WIDTH-1:0] B3_RAM [0:147*16-1];
initial begin

    fd_b = $fopen("B.txt", "r");

    if (fd_b == 0) begin
        $display("ERROR: Cannot open B.txt");
        $finish;
    end

    // B1: 27 x 16
    for (i = 0; i < 27*16; i = i + 1) begin
        $fscanf(fd_b, "%d", value_b);
        wgt_bank_b1.ram[i] = value_b;
    end

    // B2: 75 x 16
    for (i = 0; i < 75*16; i = i + 1) begin
        $fscanf(fd_b, "%d", value_b);
        B2_RAM[i] = value_b;
    end

    // B3: 147 x 16
    for (i = 0; i < 147*16; i = i + 1) begin
        $fscanf(fd_b, "%d", value_b);
        B3_RAM[i] = value_b;
    end

    $fclose(fd_b);

end
reg signed [DATA_WIDTH-1:0] C1_RAM [0:16*16-1];
reg signed [DATA_WIDTH-1:0] C2_RAM [0:16*16-1];
reg signed [DATA_WIDTH-1:0] C3_RAM [0:16*16-1];
integer fd_c;
integer value_c;

initial begin

    fd_c = $fopen("C.txt", "r");

    if (fd_c == 0) begin
        $display("ERROR: Cannot open C.txt");
        $finish;
    end

    // C1: 16 x 16
    for (i = 0; i < 16*16; i = i + 1) begin
        $fscanf(fd_c, "%d", value_c);
        ofm_bank_c1.ram[i] = value_c;
    end

    // C2: 16 x 16
    for (i = 0; i < 16*16; i = i + 1) begin
        $fscanf(fd_c, "%d", value_c);
        C2_RAM[i] = value_c;
    end

    // C3: 16 x 16
    for (i = 0; i < 16*16; i = i + 1) begin
        $fscanf(fd_c, "%d", value_c);
        C3_RAM[i] = value_c;
    end

    $fclose(fd_c);

end
endmodule
