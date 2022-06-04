module ColorGridGenerator #(
    parameter CTRL_WIDTH    = 0,
    parameter COUNTER_WIDTH = 10,
    parameter COLUMN_WIDTH  = 0,
    parameter ROW_HEIGHT    = 0,
    parameter DELAY         = 0
) (
    input logic clk_pixel,
    input logic reset_n,
    input logic[COUNTER_WIDTH-1:0] x,
    input logic[COUNTER_WIDTH-1:0] y,
    input logic[CTRL_WIDTH-1:0] ctrl_in,
    output logic[7:0] r,
    output logic[7:0] g,
    output logic[7:0] b,
    output logic[CTRL_WIDTH-1:0] ctrl_out
);

    localparam WHITE   = 24'hffffff;
    localparam YELLOW  = 24'hffff00;
    localparam CYAN    = 24'h00ffff;
    localparam GREEN   = 24'h00ff00;
    localparam MAGENTA = 24'hff00ff;
    localparam RED     = 24'hff0000;
    localparam BLUE    = 24'h0000ff;
    localparam BLACK   = 24'h000000;

    logic[23:0] rgb;
    always_comb begin
        logic[COUNTER_WIDTH-1:0] seg;

        seg = x / COLUMN_WIDTH[COUNTER_WIDTH-1:0];
        if (y >= ROW_HEIGHT)
            seg += 4'd4;

        case (seg)
            0:       rgb = WHITE;
            1:       rgb = YELLOW;
            2:       rgb = CYAN;
            3:       rgb = GREEN;
            4:       rgb = MAGENTA;
            5:       rgb = RED;
            6:       rgb = BLUE;
            7:       rgb = BLACK;
            default: rgb = '0;
        endcase
    end

    Buffer #(CTRL_WIDTH, COUNTER_WIDTH, DELAY) buffer(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .r_in(rgb[23:16]),
        .g_in(rgb[15:8]),
        .b_in(rgb[7:0]),
        .ctrl_in(ctrl_in),
        .r_out(r),
        .g_out(g),
        .b_out(b),
        .ctrl_out(ctrl_out)
    );

endmodule
