`timescale 1ns / 1ps

module top_k_selector #(
    parameter DATA_WIDTH  = 8,
    parameter LABEL_WIDTH = 2,
    parameter K_MAX       = 5
)(
    input  wire clk,
    input  wire reset,

    input  wire valid,
    input  wire done_distance,

    input  wire [2*DATA_WIDTH:0] distance,
    input  wire [LABEL_WIDTH-1:0] class_in,
    input  wire [2:0] k_value,

    output reg done_topk,

    output reg [LABEL_WIDTH-1:0] class1,
    output reg [LABEL_WIDTH-1:0] class2,
    output reg [LABEL_WIDTH-1:0] class3,
    output reg [LABEL_WIDTH-1:0] class4,
    output reg [LABEL_WIDTH-1:0] class5
);

localparam MAX = 19'h7FFFF;

reg [18:0] d1,d2,d3,d4,d5;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        d1<=MAX; d2<=MAX; d3<=MAX; d4<=MAX; d5<=MAX;

        class1<=0;
        class2<=0;
        class3<=0;
        class4<=0;
        class5<=0;

        done_topk<=0;
    end
    else
    begin
        done_topk<=0;

        if(valid)
        begin
            if(distance < d1)
            begin
                d5<=d4; class5<=class4;
                d4<=d3; class4<=class3;
                d3<=d2; class3<=class2;
                d2<=d1; class2<=class1;

                d1<=distance;
                class1<=class_in;
            end
            else if(distance < d2)
            begin
                d5<=d4; class5<=class4;
                d4<=d3; class4<=class3;
                d3<=d2; class3<=class2;

                d2<=distance;
                class2<=class_in;
            end
            else if(distance < d3)
            begin
                d5<=d4; class5<=class4;
                d4<=d3; class4<=class3;

                d3<=distance;
                class3<=class_in;
            end
            else if(distance < d4)
            begin
                d5<=d4; class5<=class4;

                d4<=distance;
                class4<=class_in;
            end
            else if(distance < d5)
            begin
                d5<=distance;
                class5<=class_in;
            end
        end

        if(done_distance)
            done_topk <= 1;

    end
end

endmodule