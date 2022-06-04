module Buffer #(
    parameter CTRL_WIDTH    = 0,
    parameter COUNTER_WIDTH = 10,
    parameter DELAY         = 0
) (
    input logic clk_pixel,
    input logic reset_n,
    input logic[7:0] r_in,
    input logic[7:0] g_in,
    input logic[7:0] b_in,
    input logic[CTRL_WIDTH-1:0] ctrl_in,
    output logic[7:0] r_out,
    output logic[7:0] g_out,
    output logic[7:0] b_out,
    output logic[CTRL_WIDTH-1:0] ctrl_out
);

    logic[CTRL_WIDTH+24-1:0] buffer[DELAY:0];

    assign buffer[0] = {r_in, g_in, b_in, ctrl_in};
    assign {r_out, g_out, b_out, ctrl_out} = buffer[DELAY];

    always_ff @(posedge clk_pixel, negedge reset_n)
        if (reset_n == '0)
            for (int i = 0; i < DELAY; i++) begin
                buffer[i + 1] <= '0;
            end
        else
            for (int i = 0; i < DELAY; i++) begin
                buffer[i + 1] <= buffer[i];
            end

endmodule
