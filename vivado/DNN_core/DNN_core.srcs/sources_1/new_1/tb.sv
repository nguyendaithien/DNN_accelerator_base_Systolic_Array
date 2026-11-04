module tb ();
	localparam DATA_WIDTH = 16;
	localparam task_all = 0;
	localparam task_1 = 0;
	localparam task_2 = 1;

	logic                          clk            ;
	logic                          enable         ;                 
	logic                          rst_n          ;
	logic                          reset_pe_1     ;
	logic                          reset_pe_2     ;
	logic                          write_out_en   ;
	logic                          sel_out_mux    ;
	logic                          sel_out_de_mux ;
	logic     [DATA_WIDTH - 1 : 0] top_in         ;
	logic     [DATA_WIDTH - 1 : 0] left_in        ;
	logic     [DATA_WIDTH*2 - 1 : 0] mac_in     ;
	logic [DATA_WIDTH - 1 : 0]   bottom_out     ;
	logic [DATA_WIDTH - 1 : 0]   right_out      ;
	logic [DATA_WIDTH*2 - 1 : 0] mac_out        ;


	`define LEVEL2 2
	logic [4:0] err_cnt;
	logic [4:0] pass_cnt;

	task verify_1 ( input string in1 = "TB" , logic [63:0] signal, logic [63:0] expect_value);
		verify_0: assert (signal == expect_value) begin
			$display("*** [0]\033[0;34mPASS\033[m[%2d]: \"\033[0;32m%0s\033[m\" Actual = %0d Expect = %0d) (%0d ns)", pass_cnt, in1, signal, expect_value, $time);
			pass_cnt++;
		end
		else begin
			$error ("*** [1]\033[0;31FAIL\033[m[%2d]: \"\033[0;32m%0s\033[m\" Actual = %0d Expect = %0d) (%0d ns)", err_cnt, in1, signal, expect_value, $time);
				err_cnt++;
		end
	endtask

	task finish_task();
		#1ms;
		$finish;
	endtask

PE #(
	.DATA_WIDTH (16)
) pe_inst (
  .clk            (clk            ),
  .rst_n          (rst_n          ),
  .reset_pe_1     (reset_pe_1     ),
  .reset_pe_2     (reset_pe_2     ),
  .write_out_en   (write_out_en   ),
  .sel_out_mux    (sel_out_mux    ),
  .sel_out_de_mux (sel_out_de_mux ),
  .top_in         (top_in         ),
  .enable         (enable         ),
  .left_in        (left_in        ),
  .mac_in         (mac_in         ),
  .bottom_out     (bottom_out     ),
  .right_out      (right_out      ),
  .mac_out        (mac_out        )
);
logic [4:0] i;
always #5 clk = !clk;
initial begin

	// initial value 
	#10 rst_n = 1 ;
  clk = 0;
	err_cnt = 0;
	pass_cnt = 0;
	reset_pe_1 = 0;
	reset_pe_2 = 0;
	write_out_en = 0;
  sel_out_mux = 0;
	top_in = 0;
	left_in = 0;
	mac_in = 0;
  enable = 0;
	// reset 
	#10 rst_n = 0 ;
	#10 rst_n = 1 ;
	if(task_1 | task_all) begin
// MAC in register 1
	sel_out_de_mux = 0;
  enable = 1;
	for ( i = 0 ; i < 11 ; i = i + 1) begin
		#10 left_in = i; top_in = i;
	end
	#10
	left_in = 0; top_in = 0;
  sel_out_mux = 0;
	write_out_en = 0;
	verify_1(" Check result 1 of PE", pe_inst.result_1, 16'd385);
	verify_1(" Check result out of PE", pe_inst.result_out, 16'd385);
	#10;
	verify_1(" Check mac out of PE", pe_inst.mac_out, 16'd385);
	#10 
	reset_pe_1 = 1;
	#10 
	reset_pe_1 = 0;

// MAC in register 2
	sel_out_de_mux = 0;
	sel_out_de_mux = 1;
  sel_out_mux = 1;
	for ( i = 0 ; i < 11 ; i = i + 1) begin
		#10 left_in = i; top_in = i;
	end
	#10 
	left_in = 0; top_in = 0;
	write_out_en = 0;
  //enable = 0;
  sel_out_mux = 1;
	verify_1(" Check result 2 of PE", pe_inst.result_2, 16'd385);
	verify_1(" Check result out of PE", pe_inst.result_out, 16'd385);
	#10;
	verify_1(" Check mac out of PE", pe_inst.mac_out, 16'd385);
	#10 
	reset_pe_2 = 1;
	#10 
	reset_pe_2 = 0;
	verify_1(" Check mac out of PE", pe_inst.mac_out, 16'd385);

//	finish_task();
	end //end task 1
	if(task_2 | task_all) begin
  // MAC at result_1
	sel_out_de_mux = 0; // select register 1
  enable = 1;
	for ( i = 0 ; i < 11 ; i = i + 1) begin
		#10 left_in = i; top_in = i;
	end
	#10
	left_in = 0; top_in = 0;
  sel_out_mux = 0; // select result_1 to result_out
	write_out_en = 0; // select result_1 to mac_out
	verify_1(" Check result 1 of PE", pe_inst.result_1, 16'd385);
	verify_1(" Check result out of PE", pe_inst.result_out, 16'd385);
	verify_1(" Check result 2 of PE", pe_inst.result_2, 16'd0);
	#10; // after 1 cycle check mac_out register 
	verify_1(" Check mac out of PE", pe_inst.mac_out, 16'd385);
  // select to mac_out  
	reset_pe_1 = 1;
	write_out_en = 1; // select mac_in to mac_out
  $display (" result 2 = %d",pe_inst.result_2);
	for ( i = 0 ; i < 17 ; i = i + 1) begin
	  sel_out_de_mux = 1;
		#10 if(i < 11) begin
			left_in = i; top_in = i;
	    $display(" result 2 %d", top_in*left_in + pe_inst.result_2);
	    $display(" result 2 %d", pe_inst.result_2);
	    $display(" result 1 %d", pe_inst.result_1);
	  //  $display("top in %d, left in %d", pe_inst.top_in, pe_inst.left_in);
			mac_in = 2*i;
	    verify_1(" check mac out", pe_inst.mac_out, 2*(i-1));
			if( i == 10) begin

	    reset_pe_1 = 0;
			  left_in = i; top_in = i;
				#10
			 	verify_1(" Check result 2 of PE", pe_inst.result_2, 16'd385);
			end
		end else if(i == 11)  begin
			mac_in = 2*i;
      sel_out_mux = 1; // select result_1 to result_out
	    write_out_en = 1; // select result_1 to mac_out
	    verify_1(" check mac out", pe_inst.mac_out, 2*(i-1));
	    verify_1(" Check result out of PE", pe_inst.result_out, 16'd385);
		end else begin
			mac_in = 2*i;
	    verify_1(" check mac out", pe_inst.mac_out, 2*(i-1));
		end
	#10;
	end
	end // end task
	finish_task();

end // end initial 
endmodule
