`timescale 1ns / 1ps

// Declaração do módulo testbench. Um testbench não possui portas de entrada/saída [25-27].
module tb_keys_4x4;

    // Declaração de sinais internos que atuarão como entradas para o DUT (Device Under Test) [2-23, 27-33]
    reg clk;                       // Clock do sistema
    reg rst;                       // Reset síncrono (assumindo ativo alto, conforme keys_4x4.pdf) [1]
    reg [3:0] in;                  // Entrada da tecla (linha/coluna) [1]

    // Declaração de sinais internos que atuarão como saídas do DUT [2-23, 27-33]
    wire [3:0] out;                // Valor decodificado da tecla [1]
    wire valid;                    // Indica se a tecla foi validada (após debounce) [1]
    wire [15:0] press_duration;    // Duração da tecla pressionada [1]

    // Parâmetro local para controle do tempo de simulação do debounce.
    // Este valor NÃO altera o DEBOUNCE_LIMIT interno do módulo keys_4x4.v.
    // Ele define por quanto tempo o testbench mantém um estímulo de tecla para que o debounce do DUT seja concluído.
    localparam SIM_DEBOUNCE_DELAY = 100; // Tempo em ns para simular o período de estabilização do debounce no TB

    // Instanciação do módulo `keys_4x4`, conectando seus pinos aos sinais do testbench [2-11, 13, 14, 17-20, 23, 26-28, 32-45]
    keys_4x4 DUT (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out),
        .valid(valid),
        .press_duration(press_duration)
    );

    // Geração do clock: um sinal de clock com período de 10ns (frequência de 100MHz para simulação) [4-6, 9-11, 14, 18-20, 24, 30, 37-41, 43, 44, 46-54]
    always #5 clk = ~clk;

    // Bloco `initial` para aplicar os estímulos e controlar a simulação [4-6, 9-11, 18-20, 24, 27-30, 33, 37-41, 43, 50-59]
    initial begin
        // Geração do arquivo VCD (Value Change Dump) para visualização das formas de onda [2-7, 9-11, 18-20, 24, 39-41, 43, 44, 52-54, 58]
        $dumpfile("../sim/keys_4x4.vcd");
        $dumpvars(0, tb_keys_4x4); // Registra todos os sinais no módulo 'tb_keys_4x4' para o VCD [24]

        // Configura o monitoramento de sinais para imprimir no console a cada alteração [9, 30, 33, 43, 51, 54, 58-74]
        $monitor("Tempo=%0t | rst=%b | in=%b | out=%b | valid=%b | duracao=%0d", $time, rst, in, out, valid, press_duration);
        $display("------------------------------------------------------------------");
        $display("Iniciando simulação do teclado 4x4...");
        $display("NOTA: Para simulação rápida, o parâmetro DEBOUNCE_LIMIT no keys_4x4.v deve ser ajustado para um valor pequeno (ex: 10).");
        $display("------------------------------------------------------------------");

        // Inicialização de sinais de controle e entrada [4, 5, 9-11, 19, 30, 38, 39, 43, 50-54, 58, 59, 74, 75]
        clk = 0;
        rst = 1;      // Inicia em reset (ativo alto)
        in = 4'b1111; // Assumindo 4'b1111 como "nenhuma tecla pressionada"

        // Pulso de reset: mantém reset ativo por 10ns, depois desativa [4, 5, 9-11, 19, 29, 30, 37-39, 43, 50-54, 58, 59, 74, 75]
        #10;
        rst = 0;      // Libera o reset
        $display("Reset liberado. Teclado inicializado.");
        #20; // Aguarda 2 ciclos de clock para estabilização

        // --- Teste 1: Pressionar tecla '1' (entrada 4'b0000, saída esperada 4'h1) ---
        $display("--- Teste 1: Pressionando Tecla '1' (entrada 4'b0000) ---");
        in = 4'b0000;
        #SIM_DEBOUNCE_DELAY; // Aguarda o período simulado de debounce no TB
        $display("Tecla '1' estabilizada. Valid=1 e duração aumentando devem ser observados.");
        #200; // Mantém a tecla pressionada para observar a duração

        // --- Teste 2: Liberar tecla '1' (voltar para "nenhuma tecla pressionada" 4'b1111) ---
        $display("--- Teste 2: Liberando Tecla '1' ---");
        in = 4'b1111; // Retorna ao estado de nenhuma tecla
        #SIM_DEBOUNCE_DELAY; // Aguarda o período simulado de debounce de liberação
        $display("Tecla '1' liberada. Valid=0 e duração=0 devem ser observados.");
        #100; // Aguarda estabilização

        // --- Teste 3: Pressionar tecla 'A' (entrada 4'b0011, saída esperada 4'hA) ---
        $display("--- Teste 3: Pressionando Tecla 'A' (entrada 4'b0011) ---");
        in = 4'b0011;
        #SIM_DEBOUNCE_DELAY; // Aguarda o debounce
        $display("Tecla 'A' estabilizada. Valid=1 e duração aumentando devem ser observados.");
        #200; // Mantém a tecla pressionada

        // --- Teste 4: Pressionar tecla 'F' (entrada 4'b1100, saída esperada 4'hF) enquanto 'A' está pressionada (simulando múltiplas teclas, mas o módulo lida com uma por vez) ---
        $display("--- Teste 4: Pressionando Tecla 'F' (entrada 4'b1100) - Simulação de mudança de tecla ---");
        in = 4'b1100;
        #SIM_DEBOUNCE_DELAY; // Aguarda o debounce da nova tecla
        $display("Tecla 'F' estabilizada. Valid=1 e duração aumentando devem ser observados.");
        #150; // Mantém a tecla pressionada

        // --- Teste 5: Liberar tecla 'F' ---
        $display("--- Teste 5: Liberando Tecla 'F' ---");
        in = 4'b1111;
        #SIM_DEBOUNCE_DELAY;
        $display("Tecla 'F' liberada.");
        #100;

        // --- Finalizar simulação ---
        $display("------------------------------------------------------------------");
        $display("Simulação concluída. Verifique 'keys_4x4.vcd' para as formas de onda.");
        #10; // Pequeno atraso final para capturar últimos eventos no VCD
        $finish;    // Termina a simulação [4, 11, 24, 30, 33, 38, 39, 50, 55, 64, 69, 71, 72, 75-87]
    end

endmodule
