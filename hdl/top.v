module top(
    input wire pir_in,   // entrada do sensor PIR
    output wire led_r,   // saída LED vermelho
    output wire led_g,   // saída LED verde
    output wire led_b    // saída LED azul
);

    wire ocupado;

    // Instância do módulo PIR
    pir u_pir (
        .pir_in(pir_in),
        .ocupado(ocupado)
    );

    // Instância do módulo LED RGB
    led_rgb u_led (
        .ocupado(ocupado),
        .led_r(led_r),
        .led_g(led_g),
        .led_b(led_b)
    );

endmodule
