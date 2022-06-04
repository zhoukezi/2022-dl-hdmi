module ComplexGenerator #(
    parameter CTRL_WIDTH    = 0,
    parameter COUNTER_WIDTH = 10,
    parameter DELAY         = 2
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

    // 参考映射（shadertoy默认）：
    // rgb = 0.5 + 0.5 * cos(time + pos.xyx + vec3(0, 2, 4))

    logic[25:0] counter;

    always_ff @(posedge clk_pixel, negedge reset_n)
        if (reset_n == '0)
            counter <= '0;
        else
            counter <= counter + 1'b1;

    logic[7:0] t;
    assign t = counter[25:18];

    logic[7:0] mid[2:0];

    CosLut cos1(
	    .clock(clk_pixel),
        .address_a(t + x[COUNTER_WIDTH-1:COUNTER_WIDTH-8]),
	    .address_b(t + y[COUNTER_WIDTH-1:COUNTER_WIDTH-8] + 8'd_64),
	    .q_a(mid[0]),
	    .q_b(mid[1])
    );

    CosLut cos2(
	    .clock(clk_pixel),
        .address_a(t + x[COUNTER_WIDTH-1:COUNTER_WIDTH-8] + 8'd_128),
	    .address_b('0),
	    .q_a(mid[2]),
	    .q_b()
    );

    logic[CTRL_WIDTH-1:0] ctrl_buf1;
    logic[CTRL_WIDTH-1:0] ctrl_buf2;

    always_ff @(posedge clk_pixel, negedge reset_n)
        if (reset_n == '0) begin
            ctrl_buf1 <= '0;
            ctrl_buf2 <= '0;
        end
        else begin
            ctrl_buf1 <= ctrl_in;
            ctrl_buf2 <= ctrl_buf1;
        end

    Buffer #(CTRL_WIDTH, COUNTER_WIDTH, DELAY - 2) buffer(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .r_in(mid[0]),
        .g_in(mid[1]),
        .b_in(mid[2]),
        .ctrl_in(ctrl_buf2),
        .r_out(r),
        .g_out(g),
        .b_out(b),
        .ctrl_out(ctrl_out)
    );

endmodule
