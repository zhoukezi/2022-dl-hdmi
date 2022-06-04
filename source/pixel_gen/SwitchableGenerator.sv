module SwitchableGenerator #(
    parameter CTRL_WIDTH    = 0,
    parameter COUNTER_WIDTH = 10
) (
    input logic clk_pixel,
    input logic reset_n,
    input logic switch_pulse,
    input logic[COUNTER_WIDTH-1:0] x,
    input logic[COUNTER_WIDTH-1:0] y,
    input logic[CTRL_WIDTH-1:0] ctrl_in,
    output logic[7:0] r,
    output logic[7:0] g,
    output logic[7:0] b,
    output logic[CTRL_WIDTH-1:0] ctrl_out
);

    logic[2:0] counter;
    logic[CTRL_WIDTH+24-1:0] out[7:0];

    always_ff @(posedge clk_pixel, negedge reset_n)
        if (reset_n == '0)
            counter <= '0;
        else if (switch_pulse == '1)
            counter <= counter + 1'b1;

    ColorBarGenerator #(CTRL_WIDTH, COUNTER_WIDTH, 640 / 8, 2) h_colorbar(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .pos(x),
        .ctrl_in(ctrl_in),
        .r(out[0][23:16]),
        .g(out[0][15:8]),
        .b(out[0][7:0]),
        .ctrl_out(out[0][CTRL_WIDTH+24-1:24])
    );

    ColorBarGenerator #(CTRL_WIDTH, COUNTER_WIDTH, 480 / 8, 2) v_colorbar(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .pos(y),
        .ctrl_in(ctrl_in),
        .r(out[1][23:16]),
        .g(out[1][15:8]),
        .b(out[1][7:0]),
        .ctrl_out(out[1][CTRL_WIDTH+24-1:24])
    );

    ColorGridGenerator #(CTRL_WIDTH, COUNTER_WIDTH, 640 / 4, 480 / 2, 2) grid(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .x(x),
        .y(y),
        .ctrl_in(ctrl_in),
        .r(out[2][23:16]),
        .g(out[2][15:8]),
        .b(out[2][7:0]),
        .ctrl_out(out[2][CTRL_WIDTH+24-1:24])
    );

    PureColorGenerator #(CTRL_WIDTH, COUNTER_WIDTH, 24'h804020, 2) purecolor1(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .ctrl_in(ctrl_in),
        .r(out[3][23:16]),
        .g(out[3][15:8]),
        .b(out[3][7:0]),
        .ctrl_out(out[3][CTRL_WIDTH+24-1:24])
    );

    PureColorGenerator #(CTRL_WIDTH, COUNTER_WIDTH, 24'hCC8833, 2) purecolor2(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .ctrl_in(ctrl_in),
        .r(out[4][23:16]),
        .g(out[4][15:8]),
        .b(out[4][7:0]),
        .ctrl_out(out[4][CTRL_WIDTH+24-1:24])
    );

    PureColorGenerator #(CTRL_WIDTH, COUNTER_WIDTH, 24'hFFFF00, 2) purecolor3(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .ctrl_in(ctrl_in),
        .r(out[5][23:16]),
        .g(out[5][15:8]),
        .b(out[5][7:0]),
        .ctrl_out(out[5][CTRL_WIDTH+24-1:24])
    );

    PureColorGenerator #(CTRL_WIDTH, COUNTER_WIDTH, 24'hFF9999, 2) purecolor4(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .ctrl_in(ctrl_in),
        .r(out[6][23:16]),
        .g(out[6][15:8]),
        .b(out[6][7:0]),
        .ctrl_out(out[6][CTRL_WIDTH+24-1:24])
    );

    ComplexGenerator #(CTRL_WIDTH, COUNTER_WIDTH, 2) complex(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .x(x),
        .y(y),
        .ctrl_in(ctrl_in),
        .r(out[7][23:16]),
        .g(out[7][15:8]),
        .b(out[7][7:0]),
        .ctrl_out(out[7][CTRL_WIDTH+24-1:24])
    );

    assign r = out[counter][23:16];
    assign g = out[counter][15:8];
    assign b = out[counter][7:0];
    assign ctrl_out = out[counter][CTRL_WIDTH+24-1:24];

endmodule
