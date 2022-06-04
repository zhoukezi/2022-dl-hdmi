module Popcnt #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 4
) (
    input logic [INPUT_WIDTH-1:0] in,
    output logic [OUTPUT_WIDTH-1:0] ones,
    output logic [OUTPUT_WIDTH-1:0] zeros
);

    logic[OUTPUT_WIDTH-1:0] count;

    always_comb	begin
        count = '0;
        for (int i = 0; i < INPUT_WIDTH; i++) begin
            count += in[i];
        end
    end

    assign ones = count;
    assign zeros = (INPUT_WIDTH[OUTPUT_WIDTH-1:0]) - count;

endmodule
