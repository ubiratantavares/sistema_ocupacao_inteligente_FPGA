module keys_4x4(
    input wire clk,                // Clock do sistema
    input wire rst,                // Reset síncrono
    input wire [3:0] in,           // Entrada da tecla (linha/coluna)
    output reg [3:0] out,          // Valor decodificado da tecla
    output reg valid,              // Indica se a tecla foi validada
    output reg [15:0] press_duration // Duração da tecla pressionada
);

    reg [3:0] in_prev;
    reg [15:0] debounce_counter;
    reg [15:0] duration_counter;

    // reduzido para simulação (antes era 250000)
    parameter DEBOUNCE_LIMIT = 18'd10;

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'h0;
            valid <= 1'b0;
            debounce_counter <= 16'd0;
            duration_counter <= 16'd0;
            press_duration <= 16'd0;
            in_prev <= 4'hF;
        end else begin
            if (in == in_prev) begin
                // Incrementa contador de debounce
                if (debounce_counter < DEBOUNCE_LIMIT) begin
                    debounce_counter <= debounce_counter + 1'b1;
                end else begin
                    // Tecla estável
                    valid <= 1'b1;
                    duration_counter <= duration_counter + 1'b1;
                    press_duration <= duration_counter;

                    case (in)
                        4'b0000: out <= 4'h1;
                        4'b0001: out <= 4'h2;
                        4'b0010: out <= 4'h3;
                        4'b0011: out <= 4'hA;
                        4'b0100: out <= 4'h4;
                        4'b0101: out <= 4'h5;
                        4'b0110: out <= 4'h6;
                        4'b0111: out <= 4'hB;
                        4'b1000: out <= 4'h7;
                        4'b1001: out <= 4'h8;
                        4'b1010: out <= 4'h9;
                        4'b1011: out <= 4'hC;
                        4'b1100: out <= 4'hF;
                        4'b1101: out <= 4'h0;
                        4'b1110: out <= 4'hE;
                        4'b1111: 
                        begin
                        	out <= 4'h0; // nada pressionado
                        	valid <= 1'b0; // não gera tecla válida
                        end
                        default: out <= 4'h0;
                    endcase
                end
            end else begin
                // Tecla mudou: reinicia debounce
                in_prev <= in;
                debounce_counter <= 16'd0;
                duration_counter <= 16'd0;
                valid <= 1'b0;
                press_duration <= 16'd0;
            end
        end
    end
endmodule
