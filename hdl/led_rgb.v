module led_rgb(
	input wire ocupado, // 1 = ocupado, 0 = livre
	output reg led_r,   // LED vermelho
	output reg led_g,   // LED verde
	output reg led_b   // LED azul (não usado)
);

	always @(*) begin
		if (ocupado) begin
			led_r = 1'b1; // acende vermelho
			led_g = 1'b0; // apaga verde
			led_b = 1'b0; // apaga azul
		end else begin
			led_r = 1'b0; // apaga vermelho
			led_g = 1'b1; // acende verde
			led_b = 1'b0; // apaga azul
		end
	end
endmodule
