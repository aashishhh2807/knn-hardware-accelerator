`timescale 1ns / 1ps

module knn_system #(
    parameter DATA_WIDTH  = 8,
    parameter LABEL_WIDTH = 2,
    parameter NUM_CLASSES = 4,
    parameter NUM_SAMPLES = 32,
    parameter K_MAX       = 5
)(
    input  wire clk,
    input  wire reset,

    output wire [LABEL_WIDTH-1:0] predicted,
    output wire done_final,
    output wire [31:0] latency
);

    // -----------------------------------
    // Processor Outputs
    // -----------------------------------

    wire [DATA_WIDTH-1:0] query_x;
    wire [DATA_WIDTH-1:0] query_y;
    wire [7:0]            k_value;
    wire                  start_knn;
    wire                  halt;

    knn_processor_top processor (
        .clk(clk),
        .reset(reset),

        .query_x(query_x),
        .query_y(query_y),
        .k_value(k_value),
        .start(start_knn),
        .halt(halt)
    );

    // -----------------------------------
    // Distance Engine
    // -----------------------------------

    wire [2*DATA_WIDTH:0] distance;
    wire [LABEL_WIDTH-1:0] label;
    wire valid_distance;
    wire done_distance;

    distance_engine #(
        .DATA_WIDTH(DATA_WIDTH),
        .LABEL_WIDTH(LABEL_WIDTH),
        .NUM_SAMPLES(NUM_SAMPLES)
    ) dist_engine (
        .clk(clk),
        .reset(reset),
        .start(start_knn),

        .query_x(query_x),
        .query_y(query_y),

        .distance(distance),
        .label(label),
        .valid(valid_distance),
        .done(done_distance)
    );

    // -----------------------------------
    // Top-K Selector
    // -----------------------------------

    wire done_topk;

    wire [LABEL_WIDTH-1:0] class1;
    wire [LABEL_WIDTH-1:0] class2;
    wire [LABEL_WIDTH-1:0] class3;
    wire [LABEL_WIDTH-1:0] class4;
    wire [LABEL_WIDTH-1:0] class5;

    top_k_selector #(
        .DATA_WIDTH(DATA_WIDTH),
        .LABEL_WIDTH(LABEL_WIDTH),
        .K_MAX(K_MAX)
    ) topk (
        .clk(clk),
        .reset(reset),

        .valid(valid_distance),
        .done_distance(done_distance),

        .distance(distance),
        .class_in(label),
        .k_value(k_value[2:0]),

        .done_topk(done_topk),

        .class1(class1),
        .class2(class2),
        .class3(class3),
        .class4(class4),
        .class5(class5)
    );

    // -----------------------------------
    // Voting Logic
    // -----------------------------------

    wire done_vote;

    voting_logic #(
        .LABEL_WIDTH(LABEL_WIDTH),
        .NUM_CLASSES(NUM_CLASSES),
        .K_MAX(K_MAX)
    ) voter (
        .clk(clk),
        .reset(reset),
        .done_topk(done_topk),

        .k_value(k_value[2:0]),

        .class1(class1),
        .class2(class2),
        .class3(class3),
        .class4(class4),
        .class5(class5),

        .predicted(predicted),
        .done_vote(done_vote)
    );

    assign done_final = done_vote;

    // -----------------------------------
    // Latency Counter
    // -----------------------------------

    latency_counter latency_unit (
        .clk(clk),
        .reset(reset),

        .start(start_knn),
        .done(done_final),

        .latency(latency)
    );

endmodule