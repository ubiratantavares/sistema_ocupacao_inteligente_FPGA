`timescale 1ns/1ps

module tb_led_rgb();

    // Declaração de sinais para conectar ao DUT
    reg  clk;           // Sinal de clock para referência temporal (opcional para combinacional, mas útil para simulação)
    reg  ocupado_tb;    // Entrada do módulo led_rgb (controlada pelo testbench)
    wire led_r_tb;      // Saída led_r do módulo led_rgb
    wire led_g_tb;      // Saída led_g do módulo led_rgb
    wire led_b_tb;      // Saída led_b do módulo led_rgb

    // Instanciação do Dispositivo Sob Teste (DUT)
    // O módulo led_rgb é o DUT
    led_rgb dut_led_rgb ( // dut_led_rgb é o nome da instância
        .ocupado (ocupado_tb),
        .led_r   (led_r_tb),
        .led_g   (led_g_tb),
        .led_b   (led_b_tb)
    );

    // Gerador de Clock (para referência de tempo na simulação)
    initial clk = 1'b0; // Inicialização explícita do clock [13]
    always #5 clk = ~clk; // Clock com período de 10ns (5ns alto, 5ns baixo) [13, 14]

    // Bloco inicial para gerar estímulo e exibir/verificar resultados
    initial begin
        // Configuração para geração de formas de onda (VCD) e monitoramento no console
        $dumpfile("led_rgb_simulation.vcd"); // Define o nome do arquivo VCD [14, 15]
        $dumpvars(0, tb_led_rgb);           // Registra todos os sinais para o VCD [14, 15]
        $monitor("Tempo=%0t | ocupado_tb=%b | led_r_tb=%b led_g_tb=%b led_b_tb=%b", $time, ocupado_tb, led_r_tb, led_g_tb, led_b_tb); // Monitora e exibe valores [18]

        // Inicialização dos sinais
        ocupado_tb = 1'b0; // Inicializa ocupado como livre
        #10; // Aguarda 10ns para a estabilização inicial

        // Teste 1: Ambiente Livre (ocupado = 0)
        // Esperado: led_r=0, led_g=1, led_b=0 (LED Verde aceso)
        if (led_r_tb == 1'b0 && led_g_tb == 1'b1 && led_b_tb == 1'b0) begin
            $display("OK: ocupado=0 -> LED Verde ON. (R=%b, G=%b, B=%b)", led_r_tb, led_g_tb, led_b_tb);
        end else begin
            $display("ERRO: ocupado=0 -> Esperado R=0, G=1, B=0. Obtido R=%b, G=%b, B=%b", led_r_tb, led_g_tb, led_b_tb);
        end
        #20; // Aguarda 20ns

        // Teste 2: Ambiente Ocupado (ocupado = 1)
        // Esperado: led_r=1, led_g=0, led_b=0 (LED Vermelho aceso)
        ocupado_tb = 1'b1; // Sinaliza ambiente ocupado
        #10; // Aguarda 10ns para a transição
        if (led_r_tb == 1'b1 && led_g_tb == 1'b0 && led_b_tb == 1'b0) begin
            $display("OK: ocupado=1 -> LED Vermelho ON. (R=%b, G=%b, B=%b)", led_r_tb, led_g_tb, led_b_tb);
        end else begin
            $display("ERRO: ocupado=1 -> Esperado R=1, G=0, B=0. Obtido R=%b, G=%b, B=%b", led_r_tb, led_g_tb, led_b_tb);
        end
        #20; // Aguarda 20ns

        // Teste 3: Transição de volta para Livre (ocupado = 0)
        ocupado_tb = 1'b0; // Sinaliza ambiente livre novamente
        #10; // Aguarda 10ns para a transição
        if (led_r_tb == 1'b0 && led_g_tb == 1'b1 && led_b_tb == 1'b0) begin
            $display("OK: ocupado=0 -> LED Verde ON novamente. (R=%b, G=%b, B=%b)", led_r_tb, led_g_tb, led_b_tb);
        end else begin
            $display("ERRO: ocupado=0 -> Esperado R=0, G=1, B=0 novamente. Obtido R=%b, G=%b, B=%b", led_r_tb, led_g_tb, led_b_tb);
        end
        #20; // Aguarda 20ns

        $display("Simulação do módulo led_rgb concluída.");
        $finish; // Termina a simulação [14, 15]
    end

endmodule
