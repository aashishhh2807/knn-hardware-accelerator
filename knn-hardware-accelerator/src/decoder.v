module decoder (
    input  wire        clk,
    input  wire        reset,
    input  wire [15:0] instruction,

    output reg  [7:0]  query_x,
    output reg  [7:0]  query_y,
    output reg  [7:0]  k_value,
    output reg         start,
    output reg         halt
);

wire [3:0] opcode = instruction[15:12];
wire [11:0] imm   = instruction[11:0];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        query_x <= 0;
        query_y <= 0;
        k_value <= 0;
        start   <= 0;
        halt    <= 0;
    end
    else begin
        start <= 0;  

        case (opcode)

            4'b0001: query_x <= imm[7:0];   // SET_X
            4'b0010: query_y <= imm[7:0];   // SET_Y
            4'b0011: k_value <= imm[7:0];   // SET_K
            4'b0100: start   <= 1;          // START
            4'b1111: halt    <= 1;          // HALT

            default: ;

        endcase
    end
end

endmodule