`timescale 1ns/1ps

module tb_top_pir_led_rgb();

    // Declaração de sinais internos para conectar ao DUT (módulo 'top') [1-6]
    reg pir_in_tb;     // Sinal de entrada para simular o sensor PIR
    wire led_r_tb;     // Saída do LED vermelho do módulo 'top'
    wire led_g_tb;     // Saída do LED verde do módulo 'top'
    wire led_b_tb;     // Saída do LED azul do módulo 'top'

    // Sinal de clock para fins de temporização na simulação (opcional para combinacional, mas útil) [1, 7-11]
    reg clk;

    // Instanciação do Dispositivo Sob Teste (DUT) [1, 4, 5, 12-15]
    // O módulo 'top' é o nosso DUT
    top_pir_led_rgb dut_top ( // 'dut_top' é o nome da instância
        .pir_in  (pir_in_tb),
        .led_r   (led_r_tb),
        .led_g   (led_g_tb),
        .led_b   (led_b_tb)
    );

    // Gerador de Clock [1, 7-11]
    // Clock com período de 10ns (5ns alto, 5ns baixo)
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Bloco inicial para gerar estímulo e exibir/verificar resultados [1, 5, 10, 16-19]
    initial begin
        // Configuração para geração de formas de onda (VCD) e monitoramento no console [7, 11, 20-27]
        $dumpfile("top_simulation.vcd"); // Define o nome do arquivo VCD
        $dumpvars(0, tb_top_pir_led_rgb);           // Registra todos os sinais para o VCD
        // Monitora e exibe valores no console sempre que mudam [11, 20, 21, 28-32]
        $monitor("Tempo=%0t | pir_in_tb=%b | led_r_tb=%b led_g_tb=%b led_b_tb=%b", $time, pir_in_tb, led_r_tb, led_g_tb, led_b_tb);

        // --- Sequência de Testes ---

        // Inicialização [17]
        pir_in_tb = 1'b0; // Simula o sensor PIR iniciando como "livre"
        #10; // Aguarda 10ns para a estabilização inicial

        // Teste 1: Ambiente Livre (pir_in = 0)
        // O módulo led_rgb deve acender o LED verde (R=0, G=1, B=0)
        if (led_r_tb == 1'b0 && led_g_tb == 1'b1 && led_b_tb == 1'b0) begin
            $display("OK: pir_in=0 -> LED Verde ON. (R=%b, G=%b, B=%b)", led_r_tb, led_g_tb, led_b_tb);
        end else begin
            $display("ERRO: pir_in=0 -> Esperado R=0, G=1, B=0. Obtido R=%b, G=%b, B=%b", led_r_tb, led_g_tb, led_b_tb);
        end
        #20; // Aguarda 20ns

        // Teste 2: Ambiente Ocupado (pir_in = 1)
        // O módulo led_rgb deve acender o LED vermelho (R=1, G=0, B=0)
        pir_in_tb = 1'b1; // Simula o sensor PIR detectando ocupação
        #10; // Aguarda 10ns para a transição
        if (led_r_tb == 1'b1 && led_g_tb == 1'b0 && led_b_tb == 1'b0) begin
            $display("OK: pir_in=1 -> LED Vermelho ON. (R=%b, G=%b, B=%b)", led_r_tb, led_g_tb, led_b_tb);
        end else begin
            $display("ERRO: pir_in=1 -> Esperado R=1, G=0, B=0. Obtido R=%b, G=%b, B=%b", led_r_tb, led_g_tb, led_b_tb);
        end
        #20; // Aguarda 20ns

        // Teste 3: Transição de volta para Livre (pir_in = 0)
        pir_in_tb = 1'b0; // Simula o sensor PIR detectando ambiente livre novamente
        #10; // Aguarda 10ns para a transição
        if (led_r_tb == 1'b0 && led_g_tb == 1'b1 && led_b_tb == 1'b0) begin
            $display("OK: pir_in=0 -> LED Verde ON novamente. (R=%b, G=%b, B=%b)", led_r_tb, led_g_tb, led_b_tb);
        end else begin
            $display("ERRO: pir_in=0 -> Esperado R=0, G=1, B=0 novamente. Obtido R=%b, G=%b, B=%b", led_r_tb, led_g_tb, led_b_tb);
        end
        #20; // Aguarda 20ns

        $display("Simulação do módulo top concluída.");
        $finish; // Termina a simulação [7, 11, 16, 20, 33]
    end

endmodule
