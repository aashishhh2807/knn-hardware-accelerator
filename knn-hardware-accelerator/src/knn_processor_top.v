module knn_processor_top (
    input  wire clk,
    input  wire reset,

    output wire [7:0] query_x,
    output wire [7:0] query_y,
    output wire [7:0] k_value,
    output wire       start,
    output wire       halt
);

// Internal wires
wire [7:0] pc_addr;
wire [15:0] instruction;

// PC
pc u_pc (
    .clk(clk),
    .reset(reset),
    .halt(halt),
    .pc_out(pc_addr)
);

// Instruction Memory
instruction_memory u_imem (
    .addr(pc_addr),
    .instruction(instruction)
);

// Decoder
decoder u_decoder (
    .clk(clk),
    .reset(reset),
    .instruction(instruction),

    .query_x(query_x),
    .query_y(query_y),
    .k_value(k_value),
    .start(start),
    .halt(halt)
);

endmodule