module dual_port_ram #(
    parameter DATA_WIDTH = 16,
    parameter DEPTH      = 6000,
    parameter ADDR_WIDTH = 13
)(
    // =========================================================
    // PORT A
    // =========================================================
    input  wire                     clka,
    input  wire                     ena,
    input  wire                     wea,
    input  wire [ADDR_WIDTH-1:0]    addra,
    input  wire [DATA_WIDTH-1:0]    dina,
    output reg  [DATA_WIDTH-1:0]    douta,

    // =========================================================
    // PORT B
    // =========================================================
    input  wire                     clkb,
    input  wire                     enb,
    input  wire                     web,
    input  wire [ADDR_WIDTH-1:0]    addrb,
    input  wire [DATA_WIDTH-1:0]    dinb,
    output reg  [DATA_WIDTH-1:0]    doutb
);

    // =========================================================
    // MEMORY
    // =========================================================
    reg signed [DATA_WIDTH-1:0] mem [0:DEPTH-1];


    // =========================================================
    // PORT A
    //
    // Synchronous read
    // Write and read occur at rising edge of CLKA
    // =========================================================
    always @(posedge clka) begin

        if (ena) begin

            if (wea)
                mem[addra] <= dina;

            douta <= mem[addra];

        end

    end


    // =========================================================
    // PORT B
    //
    // Synchronous read
    // Write and read occur at rising edge of CLKB
    // =========================================================
    always @(posedge clkb) begin

        if (enb) begin
            if (web)
                mem[addrb] <= dinb;
            doutb <= mem[addrb];

        end

    end

endmodule
