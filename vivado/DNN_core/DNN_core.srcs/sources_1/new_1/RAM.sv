`timescale 1 ns / 1 ps
module RAM #(
    parameter DATA_WIDTH = 16,
		parameter HEIGHT     = 16, 
		parameter WIDTH      = 27 ,
		parameter DEPTH      = HEIGHT*WIDTH,
		parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  logic                      clk,
    input  logic                      rst_n,
    input  logic                      we,
		input  logic                      [HEIGHT-1:0]re,
    input  logic         [ADDR_WIDTH*HEIGHT-1:0]addr,
    input  logic signed [DATA_WIDTH-1:0] din,
    output logic signed [DATA_WIDTH*HEIGHT-1:0] dout
);
	  logic signed [DATA_WIDTH-1:0] ram  [0:DEPTH-1];
	  logic signed [DATA_WIDTH-1:0] bank_ram_0  [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_1  [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_2  [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_3  [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_4  [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_5  [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_6  [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_7  [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_8  [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_9  [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_10 [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_11 [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_12 [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_13 [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_14 [0:WIDTH-1];
    logic signed [DATA_WIDTH-1:0] bank_ram_15 [0:WIDTH-1];

	 reg signed [DATA_WIDTH-1:0] dout_0;
	 reg signed [DATA_WIDTH-1:0] dout_1;
	 reg signed [DATA_WIDTH-1:0] dout_2;
	 reg signed [DATA_WIDTH-1:0] dout_3;
	 reg signed [DATA_WIDTH-1:0] dout_4;
	 reg signed [DATA_WIDTH-1:0] dout_5;
	 reg signed [DATA_WIDTH-1:0] dout_6;
	 reg signed [DATA_WIDTH-1:0] dout_7;
	 reg signed [DATA_WIDTH-1:0] dout_8;
	 reg signed [DATA_WIDTH-1:0] dout_9;
	 reg signed [DATA_WIDTH-1:0] dout_10;
	 reg signed [DATA_WIDTH-1:0] dout_11;
	 reg signed [DATA_WIDTH-1:0] dout_12;
	 reg signed [DATA_WIDTH-1:0] dout_13;
	 reg signed [DATA_WIDTH-1:0] dout_14;
	 reg signed [DATA_WIDTH-1:0] dout_15;
	 assign dout = {dout_15,dout_14,dout_13,dout_12,dout_11,dout_10,dout_9,dout_8,
               dout_7,dout_6,dout_5,dout_4,dout_3,dout_2,dout_1,dout_0};

	wire [ADDR_WIDTH-1:0] addr0  ;  
	wire [ADDR_WIDTH-1:0] addr1    ;
	wire [ADDR_WIDTH-1:0] addr2    ;
	wire [ADDR_WIDTH-1:0] addr3    ;
	wire [ADDR_WIDTH-1:0] addr4    ;
	wire [ADDR_WIDTH-1:0] addr5    ;
	wire [ADDR_WIDTH-1:0] addr6    ;
	wire [ADDR_WIDTH-1:0] addr7    ;
	wire [ADDR_WIDTH-1:0] addr8    ;
	wire [ADDR_WIDTH-1:0] addr9    ;
	wire [ADDR_WIDTH-1:0] addr10   ;
	wire [ADDR_WIDTH-1:0] addr11   ;
	wire [ADDR_WIDTH-1:0] addr12   ;
	wire [ADDR_WIDTH-1:0] addr13   ;
	wire [ADDR_WIDTH-1:0] addr14   ;
	wire [ADDR_WIDTH-1:0] addr15   ;

	wire re_0,re_1,re_2,re_3,re_4,re_5,re_6,re_7,re_8,re_9,re_10,re_11,re_12,re_13,re_14,re_15;
	assign re_0 = re[0];
	assign re_1 = re[1];
	assign re_2 = re[2];
	assign re_3 = re[3];
	assign re_4 = re[4];
	assign re_5 = re[5];
	assign re_6 = re[6];
	assign re_7 = re[7];
	assign re_8 = re[8];
	assign re_9 = re[9];
	assign re_10 = re[10];
	assign re_11 = re[11];
	assign re_12 = re[12];
	assign re_13 = re[13];
	assign re_14 = re[14];
	assign re_15 = re[15];

	assign addr15  = addr[16*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr14  = addr[15*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr13  = addr[14*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr12  = addr[13*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr11  = addr[12*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr10  = addr[11*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr9  = addr[10*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr8  = addr[ 9*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr7  = addr[ 8*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr6  = addr[ 7*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr5 = addr[ 6*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr4 = addr[ 5*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr3 = addr[ 4*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr2 = addr[ 3*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr1 = addr[ 2*ADDR_WIDTH-1 -: ADDR_WIDTH];
	assign addr0 = addr[ 1*ADDR_WIDTH-1 -: ADDR_WIDTH];

	integer j;
	always @(negedge rst_n) begin
		if(~rst_n) begin
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_0[j] <= ram[0*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_1[j] <= ram[1*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_2[j] <= ram[2*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_3[j] <= ram[3*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_4[j] <= ram[4*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_5[j] <= ram[5*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_6[j] <= ram[6*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_7[j] <= ram[7*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_8[j] <= ram[8*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_9[j] <= ram[9*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_10[j] <= ram[10*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_11[j] <= ram[11*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_12[j] <= ram[12*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_13[j] <= ram[13*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_14[j] <= ram[14*WIDTH + j] ;
			end
			for (j = 0 ; j < WIDTH ; j++) begin
				bank_ram_15[j] <= ram[15*WIDTH + j] ;
			end
		end
	end
	always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
        end
        else if (we) begin
            bank_ram_0[addr0]   <= din;
            bank_ram_1[addr1]   <= din;
            bank_ram_2[addr2]   <= din;
            bank_ram_3[addr3]   <= din;
            bank_ram_4[addr4]   <= din;
            bank_ram_5[addr5]   <= din;
            bank_ram_6[addr6]   <= din;
            bank_ram_7[addr7]   <= din;
            bank_ram_8[addr8]   <= din;
            bank_ram_9[addr9]   <= din;
            bank_ram_10[addr10] <= din;
            bank_ram_11[addr11] <= din;
            bank_ram_12[addr12] <= din;
            bank_ram_13[addr13] <= din;
            bank_ram_14[addr14] <= din;
            bank_ram_15[addr15] <= din;

        end
    end
	// =========================================================
    // READ
    // =========================================================

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_0  <= '0;
            dout_1  <= '0;
            dout_2  <= '0;
            dout_3  <= '0;
            dout_4  <= '0;
            dout_5  <= '0;
            dout_6  <= '0;
            dout_7  <= '0;
            dout_8  <= '0;
            dout_9  <= '0;
            dout_10 <= '0;
            dout_11 <= '0;
            dout_12 <= '0;
            dout_13 <= '0;
            dout_14 <= '0;
            dout_15 <= '0;
        end
        else if (re) begin

				if (re_0)
            dout_0 <= bank_ram_0[addr0];
				else 
            dout_0 <= '0;
        if (re_1)
            dout_1 <= bank_ram_1[addr1];
				else 
            dout_1 <= '0;

        if (re_2)
            dout_2 <= bank_ram_2[addr2];
				else 
            dout_2 <= '0;

        if (re_3)
            dout_3 <= bank_ram_3[addr3];
				else 
            dout_3 <= '0;

        if (re_4)
            dout_4 <= bank_ram_4[addr4];
				else 
            dout_4 <= '0;

        if (re_5)
            dout_5 <= bank_ram_5[addr5];
				else 
            dout_5 <= '0;

        if (re_6)
            dout_6 <= bank_ram_6[addr6];
				else 
            dout_6 <= '0;

        if (re_7)
            dout_7 <= bank_ram_7[addr7];
				else 
            dout_7 <= '0;

        if (re_8)
            dout_8 <= bank_ram_8[addr8];
				else 
            dout_8 <= '0;

        if (re_9)
            dout_9 <= bank_ram_9[addr9];
				else 
            dout_9 <= '0;

        if (re_10)
            dout_10 <= bank_ram_10[addr10];
				else 
            dout_10 <= '0;

        if (re_11)
            dout_11 <= bank_ram_11[addr11];
				else 
            dout_11 <= '0;

        if (re_12)
            dout_12 <= bank_ram_12[addr12];
				else 
            dout_12 <= '0;

        if (re_13)
            dout_13 <= bank_ram_13[addr13];
				else 
            dout_13 <= '0;

        if (re_14)
            dout_14 <= bank_ram_14[addr14];
				else 
            dout_14 <= '0;

        if (re_15)
            dout_15 <= bank_ram_15[addr15];
				else 
            dout_15 <= '0;
        end else begin
            dout_0  <= '0;
            dout_1  <= '0;
            dout_2  <= '0;
            dout_3  <= '0;
            dout_4  <= '0;
            dout_5  <= '0;
            dout_6  <= '0;
            dout_7  <= '0;
            dout_8  <= '0;
            dout_9  <= '0;
            dout_10 <= '0;
            dout_11 <= '0;
            dout_12 <= '0;
            dout_13 <= '0;
            dout_14 <= '0;
            dout_15 <= '0;
				end
    end

endmodule
