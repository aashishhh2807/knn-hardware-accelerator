`timescale 1ns / 1ps

module voting_logic #(
    parameter LABEL_WIDTH = 2,
    parameter NUM_CLASSES = 4,
    parameter K_MAX = 5
)(
    input wire clk,
    input wire reset,
    input wire done_topk,

    input wire [2:0] k_value,

    input wire [LABEL_WIDTH-1:0] class1,
    input wire [LABEL_WIDTH-1:0] class2,
    input wire [LABEL_WIDTH-1:0] class3,
    input wire [LABEL_WIDTH-1:0] class4,
    input wire [LABEL_WIDTH-1:0] class5,

    output reg [LABEL_WIDTH-1:0] predicted,
    output reg done_vote
);

reg [2:0] vote0,vote1,vote2,vote3;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        predicted <= 0;
        done_vote <= 0;
    end
    else
    begin
        done_vote <= 0;

        if(done_topk)
        begin

            vote0 = (class1==0)+(class2==0)+(class3==0)+(class4==0)+(class5==0);
            vote1 = (class1==1)+(class2==1)+(class3==1)+(class4==1)+(class5==1);
            vote2 = (class1==2)+(class2==2)+(class3==2)+(class4==2)+(class5==2);
            vote3 = (class1==3)+(class2==3)+(class3==3)+(class4==3)+(class5==3);

            predicted = 0;

            if(vote1>vote0) predicted=1;
            if(vote2>vote1 && vote2>vote0) predicted=2;
            if(vote3>vote2 && vote3>vote1 && vote3>vote0) predicted=3;

            done_vote <= 1;
        end
    end
end

endmodule