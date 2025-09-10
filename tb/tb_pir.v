`timescale 1ns/1ps

module tb_pir();
    
    reg  clk;        // Sinal de clock para timing da simulação
    reg  rst_n;      // Sinal de reset (ativo em nível baixo, mas não usado diretamente pelo PIR)
    reg  pir_in_tb;  // Entrada do sensor PIR (controlada pelo testbench)
    wire ocupado_tb; // Saída do módulo PIR

    // Instanciação do Dispositivo Sob Teste (DUT)
    pir dut_pir (
        .pir_in  (pir_in_tb),
        .ocupado (ocupado_tb)
    );
    
    initial clk = 0;
    always #5 clk = ~clk; // Clock com período de 10ns (5ns alto, 5ns baixo)

    // Bloco inicial para gerar estímulo e exibir resultados
    initial begin
        // Configuração inicial para a simulação
        $dumpfile("pir_simulation.vcd"); // Cria arquivo VCD para visualização de waveform
        $dumpvars(0, tb_pir);            // Registra todos os sinais para o VCD
        $monitor("Tempo=%0t | pir_in_tb=%b | ocupado_tb=%b", $time, pir_in_tb, ocupado_tb); // Monitora e exibe valores

        // Reset inicial
        rst_n = 0;
        pir_in_tb = 0;
        #10; // Aguarda 10ns para o reset 
        rst_n = 1;

        // Teste 1: Ambiente Livre
        pir_in_tb = 0;
        #20; // Aguarda 20ns, ocupado_tb deve ser 0

        // Teste 2: Ambiente Ocupado
        pir_in_tb = 1;
        #20; // Aguarda 20ns, ocupado_tb deve ser 1

        // Teste 3: Transição para Livre
        pir_in_tb = 0;
        #20; // Aguarda 20ns, ocupado_tb deve ser 0

        // Teste 4: Transição para Ocupado novamente
        pir_in_tb = 1;
        #20; // Aguarda 20ns, ocupado_tb deve ser 1

        // Fim da simulação
        $display("Simulação do módulo PIR concluída.");
        $finish; // Termina a simulação
    end

endmodule
