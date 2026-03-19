module pc (
    input  wire clk,
    input  wire reset,
    input  wire halt,
    output reg  [7:0] pc_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc_out <= 8'd0;
    else if (!halt)
        pc_out <= pc_out + 1;
end

endmodule