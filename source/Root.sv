module Root (
    input logic external_clk,
    input logic external_reset_n,
    input logic switch_key_n,

    output logic ddc_scl,
    output logic ddc_sda,
    output logic tmds_c_p,
    output logic tmds_c_n,
    output logic tmds_r_p,
    output logic tmds_r_n,
    output logic tmds_g_p,
    output logic tmds_g_n,
    output logic tmds_b_p,
    output logic tmds_b_n
);

    logic clk_pixel;
    logic clk_tmds_half;
    logic locked;
    logic reset_n;

    Pll pll(
        .areset(~external_reset_n),
        .inclk0(external_clk),
        .c0(clk_pixel),
        .c1(clk_tmds_half),
        .locked(locked)
    );

    assign reset_n = external_reset_n & locked;

    logic switch_pulse;
    PulseKey switch_key(
        .clk(clk_pixel),
        .reset_n(reset_n),
        .key_n(switch_key_n),
        .pos_pulse(switch_pulse)
    );

    assign ddc_scl = 1'b1;
    assign ddc_sda = 1'b1;

    logic[9:0] x;
    logic[9:0] y;
    logic hsync_tim;
    logic vsync_tim;
    logic en_tim;

    TimingController timing(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),

        .x(x),
        .y(y),
        .hsync(hsync_tim),
        .vsync(vsync_tim),
        .en(en_tim)
    );

    logic hsync_gen;
    logic vsync_gen;
    logic en_gen;
    logic[7:0] r;
    logic[7:0] g;
    logic[7:0] b;

    SwitchableGenerator #(3) pixel(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),

        .switch_pulse(switch_pulse),
        .x(x),
        .y(y),
        .ctrl_in({hsync_tim, vsync_tim, en_tim}),

        .r(r),
        .g(g),
        .b(b),
        .ctrl_out({hsync_gen, vsync_gen, en_gen})
    );

    HdmiController hdmi(
        .clk_pixel(clk_pixel),
        .clk_tmds_half(clk_tmds_half),
        .reset_n(reset_n),

        .r(r),
        .g(g),
        .b(b),
        .hsync(hsync_gen),
        .vsync(vsync_gen),
        .en(en_gen),

        .hdmi_c_p(tmds_c_p),
        .hdmi_c_n(tmds_c_n),
        .hdmi_r_p(tmds_r_p),
        .hdmi_r_n(tmds_r_n),
        .hdmi_g_p(tmds_g_p),
        .hdmi_g_n(tmds_g_n),
        .hdmi_b_p(tmds_b_p),
        .hdmi_b_n(tmds_b_n)
    );

endmodule
