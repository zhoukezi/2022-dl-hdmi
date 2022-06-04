module TimingController #(
    parameter H_ACTIVE_PIXELS  = 640,
    parameter H_FRONT_PORCH    = 16,
    parameter H_SYNC_WIDTH     = 96,
    parameter H_BACK_PORCH     = 48,
    parameter H_BLANKING_TOTAL = 160,
    parameter H_TOTAL_PIXELS   = 800,

    parameter V_ACTIVE_LINES   = 480,
    parameter V_FRONT_PORCH    = 10,
    parameter V_SYNC_WIDTH     = 2,
    parameter V_BACK_PORCH     = 33,
    parameter V_BLANKING_TOTAL = 45,
    parameter V_TOTAL_LINES    = 525,

    parameter WIDTH            = 10
) (
    input logic clk_pixel,
    input logic reset_n,
    output logic[WIDTH-1:0] x,
    output logic[WIDTH-1:0] y,
    output logic hsync,
    output logic vsync,
    output logic en
);

    logic[WIDTH-1:0] h_counter;
    logic[WIDTH-1:0] v_counter;

    always_ff @(posedge clk_pixel, negedge reset_n) begin
        logic[WIDTH-1:0] h_counter_inc;
        logic[WIDTH-1:0] v_counter_inc;

        if (reset_n == '0) begin
            h_counter <= '0;
            v_counter <= '0;
        end
        else begin
            h_counter_inc = h_counter + 1'd1;
            v_counter_inc = v_counter + 1'd1;

            if (h_counter_inc == H_TOTAL_PIXELS) begin
                h_counter <= '0;

                if (v_counter_inc == V_TOTAL_LINES)
                    v_counter <= '0;
                else
                    v_counter <= v_counter_inc;
            end
            else
                h_counter <= h_counter_inc;
        end
    end

    logic h_sync;
    logic h_active;

    assign h_sync = h_counter < H_SYNC_WIDTH;
    assign h_active =
        (H_SYNC_WIDTH + H_BACK_PORCH <= h_counter) &&
        (h_counter < H_SYNC_WIDTH + H_BACK_PORCH + H_ACTIVE_PIXELS);

    logic v_sync;
    logic v_active;

    assign v_sync = v_counter < V_SYNC_WIDTH;
    assign v_active =
        (V_SYNC_WIDTH + V_BACK_PORCH <= v_counter) &&
        (v_counter < V_SYNC_WIDTH + V_BACK_PORCH + V_ACTIVE_LINES);

    assign x = (h_active && v_active) ?
        h_counter - (H_SYNC_WIDTH[WIDTH-1:0] + H_BACK_PORCH[WIDTH-1:0]) :
        '0;
    assign y = (h_active && v_active) ?
        v_counter - (V_SYNC_WIDTH[WIDTH-1:0] + V_BACK_PORCH[WIDTH-1:0]) :
        '0;

    assign hsync = h_sync;
    assign vsync = v_sync;
    assign en = h_active && v_active;

endmodule
