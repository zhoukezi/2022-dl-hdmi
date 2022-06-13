module HdmiController (
    input logic clk_pixel,
    input logic clk_tmds_half,
    input logic reset_n,

    input logic[7:0] r,
    input logic[7:0] g,
    input logic[7:0] b,
    input logic hsync,
    input logic vsync,
    input logic en,

    output logic hdmi_c_p,
    output logic hdmi_c_n,
    output logic hdmi_r_p,
    output logic hdmi_r_n,
    output logic hdmi_g_p,
    output logic hdmi_g_n,
    output logic hdmi_b_p,
    output logic hdmi_b_n
);

    logic[9:0] hdmi_r_enc;
    logic[9:0] hdmi_g_enc;
    logic[9:0] hdmi_b_enc;

    Encoder r_enc(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .hsync(hsync),
        .vsync(vsync),
        .en(en),
        .in(r),
        .out(hdmi_r_enc)
    );

    Encoder g_enc(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .hsync('0),
        .vsync('0),
        .en(en),
        .in(g),
        .out(hdmi_g_enc)
    );

    Encoder b_enc(
        .clk_pixel(clk_pixel),
        .reset_n(reset_n),
        .hsync('0),
        .vsync('0),
        .en(en),
        .in(b),
        .out(hdmi_b_enc)
    );

    logic[3:0] ser_h;
    logic[3:0] ser_l;

    Serializer r_ser(
        .clk_tmds_half(clk_tmds_half),
        .reset_n(reset_n),
        .in(hdmi_r_enc),
        .out_h(ser_h[3]),
        .out_l(ser_l[3])
    );

    Serializer g_ser(
        .clk_tmds_half(clk_tmds_half),
        .reset_n(reset_n),
        .in(hdmi_g_enc),
        .out_h(ser_h[2]),
        .out_l(ser_l[2])
    );

    Serializer b_ser(
        .clk_tmds_half(clk_tmds_half),
        .reset_n(reset_n),
        .in(hdmi_b_enc),
        .out_h(ser_h[1]),
        .out_l(ser_l[1])
    );

    Serializer c_ser(
        .clk_tmds_half(clk_tmds_half),
        .reset_n(reset_n),
        .in(10'b_11111_00000),
        .out_h(ser_h[0]),
        .out_l(ser_l[0])
    );

    logic[3:0] hdmi_p;
    logic[3:0] hdmi_n;

    DdioOut ddio_p(
        .datain_h(ser_h),
        .datain_l(ser_l),
        .outclock(~clk_tmds_half),
        .dataout(hdmi_p)
    );

    DdioOut ddio_n(
        .datain_h(~ser_h),
        .datain_l(~ser_l),
        .outclock(~clk_tmds_half),
        .dataout(hdmi_n)
    );

    assign {hdmi_r_p, hdmi_g_p, hdmi_b_p, hdmi_c_p} = hdmi_p;
    assign {hdmi_r_n, hdmi_g_n, hdmi_b_n, hdmi_c_n} = hdmi_n;

endmodule
