`timescale 1ns / 1ps

module latency_counter #(
    parameter COUNTER_WIDTH = 32
)(
    input  wire clk,
    input  wire reset,

    input  wire start,
    input  wire done,

    output reg [COUNTER_WIDTH-1:0] latency
);

reg running;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        latency <= 0;
        running <= 0;
    end
    else
    begin
        if(start && !running)
        begin
            latency <= 0;
            running <= 1;
        end

        if(running)
            latency <= latency + 1;

        if(done)
            running <= 0;
    end
end

endmodule