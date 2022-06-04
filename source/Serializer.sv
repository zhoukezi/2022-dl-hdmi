module Serializer (
    input logic clk_tmds_half,
    input logic reset_n,
    input logic[9:0] in,
    output logic out_h,
    output logic out_l
);

    logic[2:0] counter;

    always_ff @(posedge clk_tmds_half, negedge reset_n)
        if (reset_n == '0)
            counter <= '0;
        else
            if (counter[2] == '1)
                counter <= '0;
            else
                counter <= counter + 1'b1;

    logic[9:0] buffer;
    logic[9:0] buffer_next;

    always_ff @(posedge clk_tmds_half, negedge reset_n)
        if (reset_n == '0)
            buffer <= '0;
        else
            buffer <= buffer_next;

    always_comb
        if (counter[2])
            buffer_next <= in;
        else
            buffer_next <= {2'b00, buffer[9:2]};

    assign out_h = buffer[0];
    assign out_l = buffer[1];

endmodule
