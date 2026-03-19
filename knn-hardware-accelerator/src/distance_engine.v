`timescale 1ns / 1ps

module distance_engine #(
    parameter DATA_WIDTH  = 8,
    parameter LABEL_WIDTH = 2,
    parameter NUM_SAMPLES = 32
)(
    input  wire clk,
    input  wire reset,
    input  wire start,

    input  wire [DATA_WIDTH-1:0] query_x,
    input  wire [DATA_WIDTH-1:0] query_y,

    output reg  [2*DATA_WIDTH:0] distance,
    output reg  [LABEL_WIDTH-1:0] label,
    output reg  valid,
    output reg  done
);

localparam ADDR_WIDTH = $clog2(NUM_SAMPLES);

reg [ADDR_WIDTH-1:0] index;
reg running;

wire [LABEL_WIDTH+2*DATA_WIDTH-1:0] sample;

training_data #(
    .LABEL_WIDTH(LABEL_WIDTH),
    .NUM_SAMPLES(NUM_SAMPLES)
) td (
    .addr(index),
    .sample(sample)
);

wire [LABEL_WIDTH-1:0] train_label;
wire [DATA_WIDTH-1:0] train_x;
wire [DATA_WIDTH-1:0] train_y;

assign train_label = sample[LABEL_WIDTH+2*DATA_WIDTH-1:2*DATA_WIDTH];
assign train_x     = sample[2*DATA_WIDTH-1:DATA_WIDTH];
assign train_y     = sample[DATA_WIDTH-1:0];


// pipeline stage registers
reg signed [DATA_WIDTH:0] dx_r, dy_r;
reg [2*DATA_WIDTH:0] dx_sq_r, dy_sq_r;
reg [LABEL_WIDTH-1:0] label_r;


// stage 1 : subtraction
always @(posedge clk) begin
    dx_r <= $signed({1'b0,query_x}) - $signed({1'b0,train_x});
    dy_r <= $signed({1'b0,query_y}) - $signed({1'b0,train_y});
    label_r <= train_label;
end


// stage 2 : square
always @(posedge clk) begin
    dx_sq_r <= dx_r * dx_r;
    dy_sq_r <= dy_r * dy_r;
end


// stage 3 : add
always @(posedge clk) begin
    distance <= dx_sq_r + dy_sq_r;
    label <= label_r;
end


always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        index <= 0;
        running <= 0;
        valid <= 0;
        done <= 0;
    end
    else
    begin
        valid <= 0;
        done <= 0;

        if(start && !running)
        begin
            running <= 1;
            index <= 0;
        end

        if(running)
        begin
            valid <= 1;

            if(index == NUM_SAMPLES-1)
            begin
                running <= 0;
                done <= 1;
            end
            else
            begin
                index <= index + 1;
            end
        end
    end
end

endmodule