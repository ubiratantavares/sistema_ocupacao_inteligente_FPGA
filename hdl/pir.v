module pir (
	input wire pir_in,  // entrada digital do sensor PIR
	output reg ocupado  // 1 = ocupado, 0 = livre
);

	always @(*) begin
		ocupado = pir_in; // repassa o valor do PIR
	end
endmodule
