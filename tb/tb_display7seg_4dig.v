`timescale 1ns/1ps // Define a unidade de tempo de simulação como 1ns e a precisão como 1ps

module tb_display7seg();

    // Sinais de controle do testbench
    reg clk;                // Clock do sistema
    reg reset;              // Sinal de reset (ativo em nível alto, conforme o módulo)
    reg [15:0] bcd_in;      // Entrada de 4 dígitos BCD (cada 4 bits)

    // Saídas do DUT (conectadas ao testbench como wires)
    wire [6:0] seg;         // Saída dos segmentos a-g do display
    wire [3:0] an;          // Saída dos anodos (enable) de cada dígito

    // Instanciação do módulo display7seg_4dig (Device Under Test - DUT)
    // Conecta os sinais do testbench aos portos do DUT
    display7seg_4dig dut (
        .clk        (clk),
        .reset      (reset),
        .bcd_in     (bcd_in),
        .seg        (seg),
        .an         (an)
    );

    // Geração de clock: 10ns de período (equivalente a 100MHz para simulação)
    always #5 clk = ~clk; // Inverte o clock a cada 5 unidades de tempo, gerando um período de 10ns

    initial begin
        // Configuração para dump de formas de onda (Value Change Dump - VCD)
        // Isso permite visualizar os sinais no GTKWave ou ferramenta similar.
        $dumpfile("../sim/display7seg_simulation.vcd"); // Define o nome do arquivo VCD
        $dumpvars(0, tb_display7seg);      // Ativa o dump de todas as variáveis no módulo tb_display7seg

        // Inicialização de sinais no tempo 0
        clk = 0;        // Inicia o clock em nível baixo
        reset = 1;      // Ativa o reset (ativo em nível alto)
        bcd_in = 16'h0000; // Valor inicial para bcd_in

        $display("--------------------------------------------------");
        $display("Tempo=%0t: Testbench para display7seg_4dig iniciado.", $time);
        $display("--------------------------------------------------");

        // Aplicar reset por um curto período
        #20;            // Mantém o reset ativo por 20ns
        reset = 0;      // Desativa o reset
        $display("Tempo=%0t: Reset liberado.", $time);
        #50;            // Aguarda 50ns para estabilização após o reset

        // --- Casos de Teste ---

        // Teste 1: Exibir 0000
        bcd_in = 16'h0000;
        $display("\nTempo=%0t: Aplicando BCD_IN = %h (esperado: '0000' nos 4 dígitos)", $time, bcd_in);
        $display("  [Nota: 'seg' e 'an' mudarão dinamicamente devido à multiplexação de dígitos. Consulte o VCD para detalhes.]");
        #150_000; // Rodar por 150 microssegundos para observar vários ciclos de multiplexação

        // Teste 2: Exibir 1234
        bcd_in = 16'h1234;
        $display("\nTempo=%0t: Aplicando BCD_IN = %h (esperado: '1234' nos 4 dígitos)", $time, bcd_in);
        #150_000;

        // Teste 3: Exibir 9876
        bcd_in = 16'h9876;
        $display("\nTempo=%0t: Aplicando BCD_IN = %h (esperado: '9876' nos 4 dígitos)", $time, bcd_in);
        #150_000;

        // Teste 4: Exibir FFFF (dígitos BCD inválidos - módulo deve apagar ou mostrar um padrão padrão)
        bcd_in = 16'hFFFF;
        $display("\nTempo=%0t: Aplicando BCD_IN = %h (esperado: '- - - -' ou apagado para dígitos inválidos)", $time, bcd_in);
        #150_000;

        // Teste 5: Exibir um número com dígitos BCD específicos (ex: 0129)
        bcd_in = 16'h0129; // O dígito menos significativo (bcd_in[3:0]) é 9, o próximo 2, depois 1, e o mais significativo 0.
        $display("\nTempo=%0t: Aplicando BCD_IN = %h (esperado: '0129' nos 4 dígitos)", $time, bcd_in);
        #150_000;
        
        // Finalização da simulação
        $display("\nTempo=%0t: Testbench finalizado. Verifique 'display7seg_tb.vcd' para análise detalhada.", $time);
        $finish; // Termina a simulação
    end

endmodule
