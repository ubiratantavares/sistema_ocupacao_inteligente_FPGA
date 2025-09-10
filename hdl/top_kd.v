module top_kd(
    input  wire clk,            // clock do sistema
    input  wire rst,            // reset
    input  wire [3:0] key_in,   // entrada do teclado (linha/coluna simulada como 4 bits)
    output wire [6:0] seg,      // segmentos do display
    output wire [3:0] an        // seleção dos dígitos
);

    // sinais do teclado
    wire [3:0] key_value;       // tecla decodificada
    wire valid;                 // tecla válida
    wire [15:0] press_duration; // duração do pressionamento

    reg [15:0] number;          // valor acumulado em 4 dígitos BCD

	// edge detection para valid
	reg valid_prev;
	
    // instância do módulo teclado
    keys_4x4 u_keys (
        .clk(clk),
        .rst(rst),
        .in(key_in),
        .out(key_value),
        .valid(valid),
        .press_duration(press_duration)
    );

    // lógica de acumulação com edge detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            number <= 16'h0000;
    		valid_prev <= 1'b0;        
        end else begin
        	valid_prev <= valid;
        	// só acumula quando valid sobe de 0 para 1 - detecta borda de subida de valid
        	if (valid & ~valid_prev) begin
        	    if (key_value == 4'hD) begin
        	    	// clear (tecla D)
        	    	number <= 16'h0000;
        	    end else begin
            		// desloca 3 dígitos para a esquerda e insere novo na posição unidades
            		number <= {number[11:0], key_value};
            	end
            end
        end
    end

    // Instância do display
    display7seg_4dig u_disp (
        .clk(clk),
        .reset(rst),
        .bcd_in(number),
        .seg(seg),
        .an(an)
    );

endmodule
