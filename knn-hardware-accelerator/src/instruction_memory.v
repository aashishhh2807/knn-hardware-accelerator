module instruction_memory (
    input  wire [7:0] addr,
    output reg  [15:0] instruction
);

reg [15:0] mem [0:255];

initial begin
    $readmemh("query.mem", mem);
end

always @(*) begin
    instruction = mem[addr];
end

endmodule