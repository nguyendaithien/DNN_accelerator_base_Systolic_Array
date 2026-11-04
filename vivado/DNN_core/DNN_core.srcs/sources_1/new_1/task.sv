	task set_pe_reg1 ();
    $display(" ====== Start set reg 1 config %d=========", $time);
		force reset_pe_1 = 1;
		force reset_pe_2 = 1;
		#10;
		force reset_pe_1 = 0;
		force reset_pe_2 = 0;
		force write_out_en = 0;
		force sel_out_mux = 0;
		force sel_out_de_mux = 0;
		we_ofm = 0;
		ofm_write_addr   = '0;   
		#10;
		enable = 1; 
    $display(" ====== End set reg 1 config %d =========", $time);
	endtask

	task set_pe_reg2 ();
    $display(" ====== Start set reg 2 config %d=========", $time);
		force reset_pe_1 = 1;
		force reset_pe_2 = 1;
		#10;
		force reset_pe_1 = 0;
		force reset_pe_2 = 0;
		force write_out_en = 0;
		force sel_out_mux = 1;
		force sel_out_de_mux = 1;
		we_ofm = 0;
		ofm_write_addr   = '0;   
		#10;
		enable = 1; 
    $display(" ====== End set reg 2 config %d =========", $time);
	endtask

	task read_ofm ();
		force write_out_en = 1;
		force sel_out_de_mux = 1;
		for (i = 0; i < 16; i++) begin
			we_ofm = 1;
			if( i>= 1) begin
			ofm_write_addr = ofm_write_addr + 16;
			end
			#10;
		end
		we_ofm = 0;
	endtask

	task postpone (integer delay_cycle);
		begin
			re_ifm = '0;
			re_wgt = '0;
			addr_ifm = addr_ifm;
			addr_wgt = addr_wgt;
			#(10 * (delay_cycle));
		end
	endtask

	task buffer_control_delay ();
		begin
			$display();
		end
	endtask

	task buffer_control ( input integer width = 27 , input integer delay=0);
    $display(" ====== Start set ifm/wgt read %d =========", $time);
		begin

		for (integer i = 0; i < 16 ; i = i + 1) begin
			re_ifm[i] = 1;
			re_wgt[i] = 1;
		if(i <= 14) begin
			#10;
		end
		end
		
		if (delay == '0) begin
		#((width-16 + 1)*10);
		end else begin
		#((width-16 + 1 - 5)*10 +10);
		for (integer i = 0; i < 16 ; i = i + 1) begin
			re_ifm[i] = 0;
			re_wgt[i] = 0;
			enable = 0; 
		end
		#(delay * 10  );
		enable = 1; 
		#10;
		enable = 1; 
		for (integer i = 0; i < 16 ; i = i + 1) begin
			re_ifm[i] = 1;
			re_wgt[i] = 1;
		end
		#(5*10);
		end

		for (integer i = 0; i < 16 ; i = i + 1) begin
			re_ifm[i] = 0;
			re_wgt[i] = 0;
		if(i <= 14) begin
			#10;
		end
		end
			end
	endtask

	task control_with_delay (input integer delay);
		begin

		end
	endtask

	task set_ifm_addr (input integer width = 27, input integer delay=0);
    $display(" ====== Start set ifm addr %d =========", $time);
			#10;
// ============================================================
// 1. SKEW / FILL
// ============================================================
for (k = 0; k < HEIGHT; k = k + 1) begin

    for (integer j = 0; j <= k; j = j + 1) begin
        addr_ifm[j*ADDR_WIDTH +: ADDR_WIDTH] =
            addr_ifm[j*ADDR_WIDTH +: ADDR_WIDTH] + 1;
    end
    #10;
end


// ============================================================
// 2. STEADY STATE
// ============================================================
for (k = 0; k < (width - 16 - 1); k = k + 1) begin

    for (integer j = 0; j < HEIGHT; j = j + 1) begin
        addr_ifm[j*ADDR_WIDTH +: ADDR_WIDTH] =
        addr_ifm[j*ADDR_WIDTH +: ADDR_WIDTH] + 1;
		end
		if ( (delay != 0) && (k == (width -16 -6))) begin
				$display ("TIME DELAY %d", $time);
				addr_ifm = addr_ifm;
			#(delay * 10);
    end
    #10;
end


// ============================================================
// 3. DRAIN / FLUSH
// ============================================================
for (k = 0; k < HEIGHT; k = k + 1) begin

    for (integer j = k + 1; j < HEIGHT; j = j + 1) begin
        addr_ifm[j*ADDR_WIDTH +: ADDR_WIDTH] =
            addr_ifm[j*ADDR_WIDTH +: ADDR_WIDTH] + 1;
    end
    #10;
end
	#10;
    $display(" ====== End set ifm addr %d =========", $time);
	endtask

task set_wgt_addr (input integer width = 27, input integer delay=0); 
    $display(" ======Start set wgt addr %d =========", $time);
			#10;
// ============================================================
// 1. SKEW / FILL
// ============================================================
for (i = 0; i < HEIGHT; i = i + 1) begin

    for (integer j = 0; j <= i; j = j + 1) begin
        addr_wgt[j*ADDR_WIDTH +: ADDR_WIDTH] =
            addr_wgt[j*ADDR_WIDTH +: ADDR_WIDTH] + 1;
    end
    #10;
end


// ============================================================
// 2. STEADY STATE
// ============================================================
for (i = 0; i < (width - 16 -1); i = i + 1) begin

    for (integer j = 0; j < HEIGHT; j = j + 1) begin
        addr_wgt[j*ADDR_WIDTH +: ADDR_WIDTH] =
            addr_wgt[j*ADDR_WIDTH +: ADDR_WIDTH] + 1;
    end
		if ( (delay != 0) && (i == (width -16 -6))) begin
			addr_wgt = addr_wgt;
			#(delay * 10);
		end
    	#10;
end


// ============================================================
// 3. DRAIN / FLUSH
// ============================================================
for (i = 0; i < HEIGHT; i = i + 1) begin

    for (integer j = i + 1; j < HEIGHT; j = j + 1) begin
        addr_wgt[j*ADDR_WIDTH +: ADDR_WIDTH] =
            addr_wgt[j*ADDR_WIDTH +: ADDR_WIDTH] + 1;
    end
    #10;
end
	#10;
    $display(" ====== End set wgt addr read %d =========", $time);
endtask

integer cnt_err ;
task compare ( input integer id = 1);
	begin
		$display ("===================================================================================");
		$display ("===================================START COMPARE===================================");
		$display ("===================================================================================");

		cnt_err = 0;
		if (id == 1) begin
		for (i = 0; i < SYSTOLIC_SIZE * SYSTOLIC_SIZE ; i=i+1) begin
			if(ofm_bank_c1.ram[i] == ofm_ram_rtl_1.mem[i]) begin
				$display("OFM rtl = %d , OFM golden = %d", ofm_ram_rtl_1.mem[i], ofm_bank_c1.ram[i]);
			end else begin
				$display ("FAIL at %d : ofm golden = %d, ofm rtl = %d ", i, ofm_bank_c1.ram[i],ofm_ram_rtl_1.mem[i]); 
				cnt_err = cnt_err + 1;
			end
		end
		end
		if(cnt_err == 0) begin
			$display ("=====================================");
			$display ("=================PASS ALL============");
			$display ("=====================================");
		end else begin
			$display ("=================NUMBER OF FAILS: %d============", cnt_err);
		end
		end
endtask
