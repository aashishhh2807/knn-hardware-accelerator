module training_data #(
    parameter LABEL_WIDTH = 2,
    parameter NUM_SAMPLES = 32
)(
    input  wire [$clog2(NUM_SAMPLES)-1:0] addr,
    output reg  [LABEL_WIDTH+16-1:0] sample
);

    reg [LABEL_WIDTH+16-1:0] mem [0:NUM_SAMPLES-1];

    initial begin

    // -------- CLASS 0 (50,50 cluster) --------
    mem[0] = {2'd0,8'd48,8'd52};
    mem[1] = {2'd0,8'd52,8'd49};
    mem[2] = {2'd0,8'd50,8'd50};
    mem[3] = {2'd0,8'd47,8'd53};
    mem[4] = {2'd0,8'd51,8'd48};
    mem[5] = {2'd0,8'd49,8'd51};
    mem[6] = {2'd0,8'd53,8'd50};
    mem[7] = {2'd0,8'd50,8'd47};

    // -------- CLASS 1 (120,120 cluster) --------
    mem[8]  = {2'd1,8'd118,8'd121};
    mem[9]  = {2'd1,8'd122,8'd119};
    mem[10] = {2'd1,8'd120,8'd120};
    mem[11] = {2'd1,8'd121,8'd118};
    mem[12] = {2'd1,8'd119,8'd122};
    mem[13] = {2'd1,8'd123,8'd120};
    mem[14] = {2'd1,8'd120,8'd118};
    mem[15] = {2'd1,8'd118,8'd120};

    // -------- CLASS 2 (30,150 cluster) --------
    mem[16] = {2'd2,8'd29,8'd151};
    mem[17] = {2'd2,8'd31,8'd149};
    mem[18] = {2'd2,8'd30,8'd150};
    mem[19] = {2'd2,8'd32,8'd148};
    mem[20] = {2'd2,8'd28,8'd152};
    mem[21] = {2'd2,8'd30,8'd148};
    mem[22] = {2'd2,8'd27,8'd150};
    mem[23] = {2'd2,8'd31,8'd152};

    // -------- CLASS 3 (180,40 cluster) --------
    mem[24] = {2'd3,8'd178,8'd41};
    mem[25] = {2'd3,8'd182,8'd39};
    mem[26] = {2'd3,8'd180,8'd40};
    mem[27] = {2'd3,8'd181,8'd38};
    mem[28] = {2'd3,8'd179,8'd42};
    mem[29] = {2'd3,8'd183,8'd40};
    mem[30] = {2'd3,8'd180,8'd38};
    mem[31] = {2'd3,8'd178,8'd39};

    end

    always @(*) begin
        sample = mem[addr];
    end

endmodule