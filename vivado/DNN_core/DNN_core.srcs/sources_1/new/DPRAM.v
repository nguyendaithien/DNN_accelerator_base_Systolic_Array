
`timescale 1 ns / 1 ps
module DPRAM #(
  parameter RAM_SIZE          = 256 ,
  parameter DATA_WIDTH        = 16     ,
  parameter INOUT_WIDTH       = 256    ,
  parameter SYSTOLIC_SIZE     = 16
) (
    input                                 clk            ,

    input                                 re_a           ,
    input      [$clog2(RAM_SIZE) - 1 : 0] addr_a         ,
    output reg [INOUT_WIDTH      - 1 : 0] dout_a         , 
    
    input                                 we_b           ,
    input      [$clog2(RAM_SIZE) - 1 : 0] addr_b         ,
    input      [INOUT_WIDTH - 1 : 0] din_b          
    
);

    reg [DATA_WIDTH - 1 : 0] mem     [0 : RAM_SIZE      - 1] ;
    reg [DATA_WIDTH - 1 : 0] data_in [0 : SYSTOLIC_SIZE - 1] ;

    integer i;

    always @(*) begin
        for (i = 0; i < SYSTOLIC_SIZE ; i = i + 1) begin
            data_in[i] = din_b[i*DATA_WIDTH +: DATA_WIDTH];
        end
    end
	wire [DATA_WIDTH-1:0] data_check_0;
	wire [DATA_WIDTH-1:0] data_check_1;
	wire [DATA_WIDTH-1:0] data_check_2;
	wire [DATA_WIDTH-1:0] data_check_3;
	wire [DATA_WIDTH-1:0] data_check_4;
	wire [DATA_WIDTH-1:0] data_check_5;
	wire [DATA_WIDTH-1:0] data_check_6;
	wire [DATA_WIDTH-1:0] data_check_7;
	wire [DATA_WIDTH-1:0] data_check_8;
	wire [DATA_WIDTH-1:0] data_check_9;
	wire [DATA_WIDTH-1:0] data_check_10;
	wire [DATA_WIDTH-1:0] data_check_11;
	wire [DATA_WIDTH-1:0] data_check_12;
	wire [DATA_WIDTH-1:0] data_check_13;
	wire [DATA_WIDTH-1:0] data_check_14;
	wire [DATA_WIDTH-1:0] data_check_15;

	
	assign	data_check_0 = data_in  [0 ];
	assign	data_check_1  = data_in [1 ];
	assign	data_check_2  = data_in [2 ];
	assign	data_check_3  = data_in [3 ];
	assign	data_check_4  = data_in [4 ];
	assign	data_check_5  = data_in [5 ];
	assign	data_check_6  = data_in [6 ];
	assign	data_check_7  = data_in [7 ];
	assign	data_check_8  = data_in [8 ];
	assign	data_check_9  = data_in [9 ];
	assign	data_check_10 = data_in [10];
	assign	data_check_11 = data_in [11];
	assign	data_check_12 = data_in [12];
	assign	data_check_13 = data_in [13];
	assign	data_check_14 = data_in [14];
	assign	data_check_15 = data_in [15];

    
    //Port A: read 
    always @(posedge clk) begin
        if (re_a) begin
            for (i = 0; i < SYSTOLIC_SIZE; i = i + 1) begin
                dout_a[i*DATA_WIDTH +: DATA_WIDTH] <= mem[addr_a + i];
            end
        end 
        else begin
            dout_a <= {INOUT_WIDTH{1'b0}};
        end
    end

    //Port B: Write 
    always @(posedge clk) begin
        if (we_b) begin
            for (i = 0; i < SYSTOLIC_SIZE; i = i + 1) begin
            	mem[addr_b + i]                  <= data_in[i];
            end
        end
    end

endmodule
