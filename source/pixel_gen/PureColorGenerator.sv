module PureColorGenerator #(
    parameter CTRL_WIDTH    = 0,
    parameter COUNTER_WIDTH = 10,
    parameter COLOR         = 24'd0,
    parameter DELAY         = 0
) (
    input logic clk_pixel,
    input logic reset_n,
    input logic[CTRL_WIDTH-1:0] ctrl_in,
    output logic[7:0] r,
    output logic[7:0] g,
    output logic[7:0] b,
    output logic[CTRL_WIDTH-1:0] ctrl_out
);

    Buffer #(CTRL_WIDTH, COUNTER_WIDTH, DELAY) buffer(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .r_in(COLOR[23:16]),
        .g_in(COLOR[15:8]),
        .b_in(COLOR[7:0]),
        .ctrl_in(ctrl_in),
        .r_out(r),
        .g_out(g),
        .b_out(b),
        .ctrl_out(ctrl_out)
    );

endmodule
