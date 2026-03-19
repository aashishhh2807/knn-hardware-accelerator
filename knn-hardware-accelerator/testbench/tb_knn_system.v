`timescale 1ns / 1ps

module tb_knn_system;

reg clk;
reg reset;

wire [1:0] predicted;
wire done_final;
wire [31:0] latency;   // <-- latency declared


//-------------------------------------
// DUT
//-------------------------------------

knn_system #(
    .DATA_WIDTH(8),
    .LABEL_WIDTH(2),
    .NUM_CLASSES(4),
    .NUM_SAMPLES(32),
    .K_MAX(5)
) uut (
    .clk(clk),
    .reset(reset),

    .predicted(predicted),
    .done_final(done_final),
    .latency(latency)   // <-- connected
);


//-------------------------------------
// Clock generation
//-------------------------------------

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


//-------------------------------------
// Stimulus
//-------------------------------------

initial begin

$display("---- Full KNN System Simulation Started ----");

reset = 1;
#20;
reset = 0;

wait(done_final);

$display("Prediction = %0d", predicted);
$display("Latency = %0d cycles", latency);

$display("---- Simulation Finished ----");

$stop;

end
endmodule