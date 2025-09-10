module display7seg_4dig(
    input  wire clk,              // clock do sistema
    input  wire reset,            // reset
    input  wire [15:0] bcd_in,    // 4 dígitos em BCD (cada 4 bits)
    output reg [6:0] seg,         // segmentos a-g (ativo em 0 se catodo comum)
    output reg [3:0] an           // enable de cada dígito (ativo em 0 se catodo comum)
);

    // Registradores internos
    reg [1:0] digit_sel;          // seleciona qual dígito está ativo (0–3)
    reg [3:0] current_digit;      // valor BCD do dígito atual

    // Divisor de clock para multiplexação (~1kHz)
    reg [15:0] clkdiv;
    always @(posedge clk or posedge reset) begin
        if (reset)
            clkdiv <= 0;
        else
            clkdiv <= clkdiv + 1;
    end

    // Seleção de dígito (a cada overflow parcial do divisor)
    always @(posedge clkdiv[15] or posedge reset) begin
        if (reset)
            digit_sel <= 0;
        else
            digit_sel <= digit_sel + 1;
    end

    // Ativa apenas um dígito por vez
    always @(*) begin
        case (digit_sel)
            2'd0: begin an = 4'b1110; current_digit = bcd_in[3:0];   end // dígito menos significativo
            2'd1: begin an = 4'b1101; current_digit = bcd_in[7:4];   end
            2'd2: begin an = 4'b1011; current_digit = bcd_in[11:8];  end
            2'd3: begin an = 4'b0111; current_digit = bcd_in[15:12]; end // dígito mais significativo
            default: begin an = 4'b1111; current_digit = 4'd0; end
        endcase
    end

    // Decodificação BCD → segmentos (a-g)
    always @(*) begin
        case (current_digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111; // apagado
        endcase
    end

endmodule
