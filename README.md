# Sistema de Ocupação Inteligente com FPGA

## Visão Geral do Projeto

Este projeto tem como objetivo desenvolver um **Sistema de Ocupação Inteligente** implementado em uma **FPGA (Field-Programmable Gate Array)**. O coração do sistema é um **System-on-Chip (SoC)** baseado em um processador **RISC-V soft-core** de arquitetura de conjunto de instruções reduzido (RISC), totalmente open-source. A ideia é simular a funcionalidade de um microcontrolador capaz de interagir com o ambiente para detectar e responder a eventos relacionados à ocupação de um espaço.

O sistema será capaz de processar instruções e controlar diversos **periféricos** (como LEDs e comunicação serial), demonstrando a integração de hardware e software para criar uma solução de sistema embarcado flexível e reconfigurável.

## Tecnologias e Ferramentas

### Hardware

*   **Placas FPGA:**

    *   **Basys3:** Uma placa popular da Digilent, utilizada para experimentação e desenvolvimento.
    *   **Colorlight i9:** Uma placa suportada por ferramentas open-source, oferecendo uma alternativa para síntese e programação.

### Linguagem de Descrição de Hardware (HDL)

*   **Verilog HDL:** A linguagem principal utilizada para descrever o hardware digital do SoC. Verilog-2001 é o padrão utilizado, conhecido por sua sintaxe similar à linguagem C.

### Processador

*   **RISC-V Soft-core:** Uma implementação flexível da arquitetura RISC-V de 32 bits (RV32I), desenvolvida modularmente e sem pipeline para fins didáticos e de verificação.

### Ferramentas de Desenvolvimento

*   **Xilinx Vivado Design Suite:** Ambiente de desenvolvimento integrado para FPGAs da Xilinx (como a Basys3), abrangendo desde a criação de projetos até a geração de bitstream e gerenciamento de IPs.

*   **OSS-CAD-Suite (Yosys, NextPNR, OpenFPGALoader):** Um conjunto de ferramentas open-source para o fluxo de design de hardware, incluindo síntese (Yosys), placement & routing (NextPNR) e carregamento de bitstream na FPGA (OpenFPGALoader).

*   **IVerilog:** Um simulador Verilog open-source utilizado para verificação funcional dos módulos.

*   **GTKWave:** Uma ferramenta para visualização de formas de onda geradas durante a simulação.

*   **ModelSim:** Outro simulador HDL, amplamente utilizado na indústria.

*   **RISC-V Online Assembler:** Ferramenta online para converter código Assembly RISC-V em código de máquina hexadecimal, que é então carregado na memória do processador.

*   **Xilinx SDK/Vitis:** Para o desenvolvimento de firmware em C, caso o projeto seja expandido para incluir um microcontrolador como o MicroBlaze.

## Estrutura do Projeto

A organização do projeto segue uma estrutura modular e hierárquica para facilitar o desenvolvimento, teste e reuso dos componentes.

```
Sistema_Ocupacao_Inteligente_FPGA/
├── docs/                      # Documentação do projeto
├── hdl/                       # Arquivos de descrição de hardware (Verilog)
│   ├── riscv_processor_core/  # Módulos fundamentais do núcleo RISC-V
│   ├── riscv_datapath/        # Caminho de Dados do processador
│   ├── soc_interconnect/      # Interconexão do SoC e Módulo de Memória
│   ├── peripherals/           # Módulos dos periféricos
│   └── top_level/             # Módulo Top-Level do SoC
├── firmware/                  # Código Assembly (software) para o processador RISC-V
├── constraints/               # Arquivos de restrições da FPGA (.xdc, .lpf)
├── sim/                       # Arquivos de simulação e testbenches
└── build/                     # Arquivos gerados pelas ferramentas de EDA
```

### Componentes de Hardware Principais

*   **Núcleo RISC-V:**

    *   **ALU (Arithmetic Logic Unit):** Realiza operações lógicas e aritméticas de 32 bits.

    *   **ALU Control:** Gera os sinais de controle para a ALU com base nos opcodes e campos de função da instrução.

    *   **Banco de Registradores:** Armazena 32 registradores de propósito geral de 32 bits, com suporte para leitura de dois registradores e escrita em um por ciclo, e o registrador `x0` fixo em zero.

    *   **Gerador de Imediato:** Extrai e estende com sinal os valores imediatos das instruções RISC-V.

    *   **Unidade de Controle (FSM):** Uma máquina de estados que orquestra as operações do processador multiciclo em cada ciclo, controlando multiplexadores e write-enables.

    *   **Datapath (`core.v`):** Integra todos os módulos do processador, conectando-os para formar o fluxo de dados completo, incluindo a lógica do PC e registradores temporários.

*   **Módulo de Memória (`memory.v`):** Simula uma SDRAM, capaz de armazenar 32 bits por posição, inicializada a partir de arquivos (`programa.txt` ou `memfile.dat`). Aceita endereços em bytes e alinha acessos de 4 em 4 bytes.

*   **Interconexão de Barramentos (`bus_interconnect.v`):** Roteia as comunicações entre o processador, a memória e os periféricos, com base no mapeamento de memória.

*   **Periféricos:**

    *   **Periférico de LEDs (`led_peripheral.v`):** Um dispositivo mapeado em memória que permite ao processador controlar LEDs (endereço `0x80000000` base, `0x00` para escrita, `0x04` para leitura).

    *   **Comunicação Serial UART (`uart_tx.v`, `uart_rx.v`):** Módulos para transmissão e recepção de dados seriais, seguindo o protocolo UART.

    *   **FIFO (First-In, First-Out):** Um buffer para comunicação assíncrona, com largura de 8 bits e profundidade de 4 posições.

    *   **Encoder Rotativo:** Módulo para detecção de direção de um encoder.

    *   **Controlador de Display de 7 Segmentos:** Para exibir informações numéricas.

### Firmware (Software)

*   **Programas em Assembly RISC-V (`programa.txt`):** O código que o processador RISC-V executará, escrito diretamente em Assembly e convertido para formato hexadecimal por um montador online. Exemplos incluem a sequência de Fibonacci e controle de LEDs.

## Como Iniciar

1.  **Clonar o Repositório:** Obtenha uma cópia local do projeto.

2.  **Instalação das Ferramentas:** Siga as instruções para instalar as ferramentas de design necessárias (Vivado para Xilinx ou OSS-CAD-Suite para open-source). Consulte `docs/instalacao.md` ou `docs/manual.pdf` (se disponíveis).


3.  **Compilação e Síntese:** Utilize os Makefiles e scripts `run.sh` fornecidos no diretório `sim/` para automatizar o processo de síntese dos módulos Verilog e geração da netlist e bitstream.

4.  **Simulação:** Execute os testbenches (`tb.v`) usando o IVerilog e visualize as formas de onda com o GTKWave para verificar o comportamento funcional de cada módulo e do SoC completo.

5.  **Programação da FPGA:**

    *   Para placas Xilinx (Basys3), utilize o Vivado para gerar o bitstream e programar a placa.

    *   Para placas Lattice (Colorlight i9), use o OpenFPGALoader para carregar o bitstream.

6.  **Laboratório Remoto:** Caso esteja utilizando a infraestrutura de laboratório remoto, consulte `docs/guia_remoto.md` para instruções sobre como enviar seu código e observar o comportamento na placa física.

## Status do Projeto

Este projeto está em **desenvolvimento contínuo**, com a adição gradual de módulos e funcionalidades para construir um sistema completo de ocupação inteligente.

## Contribuidores

* Ubiratan Tavares

## Licença

MIT, Apache 2.0, ou outra licença de código aberto.
