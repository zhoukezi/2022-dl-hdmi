module Encoder (
    input logic clk_pixel,
    input logic reset_n,
    input logic hsync,
    input logic vsync,
    input logic en,
    input logic[7:0] in,
    output logic[9:0] out
);

    byte signed counter;
    byte signed counter_next;

    always_ff @(posedge clk_pixel, negedge reset_n)
        if (reset_n == '0)
            counter <= 0;
        else if (en == '0)
            counter <= 0;
        else
            counter <= counter_next;

    logic[9:0] enc_out;
    logic[9:0] ctrl_out;
    logic[9:0] out_next;

    always_comb
        case ({vsync, hsync})
            2'b00: ctrl_out = 10'b1101010100;
            2'b01: ctrl_out = 10'b0010101011;
            2'b10: ctrl_out = 10'b0101010100;
            2'b11: ctrl_out = 10'b1010101011;
        endcase

    assign out_next = (en) ? enc_out : ctrl_out;
    always_ff @(posedge clk_pixel, negedge reset_n)
        if (reset_n == '0)
            out <= '0;
        else
            out <= out_next;

    logic[3:0] in_ones;
    logic[3:0] in_zeros;

    Popcnt popcnt_in(
        .in(in),
        .ones(in_ones),
        .zeros(in_zeros)
    );

    logic[8:0] m;
    always_comb
        if (in_ones > 8'd4 || (in_ones == 8'd4 && in[0] == '0)) begin
            m[0] = in[0];
            for (int i = 1; i < 8; i++) begin
                m[i] = m[i-1] ~^ in[i];
            end
            m[8] = 1'b0;
        end
        else begin
            m[0] = in[0];
            for (int i = 1; i < 8; i++) begin
                m[i] = m[i-1] ^ in[i];
            end
            m[8] = 1'b1;
        end

    logic[3:0] m_ones;
    logic[3:0] m_zeros;

    Popcnt popcnt_m (
        .in(m[7:0]),
        .ones(m_ones),
        .zeros(m_zeros)
    );

    always_comb
        if ((counter == '0) || (m_ones == m_zeros)) begin
            enc_out[9] = ~m[8];
            enc_out[8] = m[8];
            enc_out[7:0] = (m[8]) ? m[7:0] : ~m[7:0];

            if (m[8] == 0)
                counter_next = counter + (m_zeros - m_ones);
            else
                counter_next = counter + (m_ones - m_zeros);
        end
        else if ((counter > 0 && m_ones > m_zeros) ||
                 (counter < 0 && m_zeros > m_ones)) begin
            enc_out[9] = 1'b1;
            enc_out[8] = m[8];
            enc_out[7:0] = ~m[7:0];
            counter_next = counter + {m[8], 1'b0} + (m_zeros - m_ones);
        end
        else begin
            enc_out[9] = 1'b0;
            enc_out[8] = m[8];
            enc_out[7:0] = m[7:0];
            counter_next = counter - {~m[8], 1'b0} + (m_ones - m_zeros);
        end

endmodule
