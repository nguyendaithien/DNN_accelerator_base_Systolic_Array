
`timescale 1ns / 1ps
module RAM_2ports #(
    parameter int DATA_WIDTH = 16,
    parameter int DEPTH      = 432
)(
     input  logic                  clk       
    ,input  logic                  rst
    ,input  logic                  write_en  
    ,input  logic [11:0] write_addr
    ,input  logic [DATA_WIDTH-1:0] write_data
    ,input  logic                  read_en   
    ,input  logic [11:0] read_addr 
    ,output logic [DATA_WIDTH-1:0] dout         
);

    logic [DATA_WIDTH-1:0] ram [0:DEPTH-1];

    always_ff @(posedge clk) begin
        if (rst) begin
            dout <= '0;
        end
        else begin
            if (write_en) begin
                ram[write_addr] <= write_data;
            end
            if (read_en) begin
                dout <= ram[read_addr];
            end
        end
    end
endmodule
