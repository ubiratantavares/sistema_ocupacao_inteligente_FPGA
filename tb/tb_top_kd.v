`timescale 1ns/1ps

module tb_top_kd;

    reg clk;
    reg rst;
    reg [3:0] key_in;
    wire [6:0] seg;
    wire [3:0] an;

    // Instância do DUT
    top_kd dut (
        .clk(clk),
        .rst(rst),
        .key_in(key_in),
        .seg(seg),
        .an(an)
    );

    // Clock 50 MHz
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // período 20ns
    end

    // Estímulos
    initial begin
        $dumpfile("sim/top_kd_simulation.vcd");
        $dumpvars(0, tb_top_kd);

        // Reset inicial
        rst = 1;
        key_in = 4'b1111; // nenhuma tecla
        #100;
        rst = 0;

        // Pressiona tecla "3"
        $display(">>> Pressionando tecla 3");
        key_in = 4'b0010;  // tecla "3"
        #2000;             
        key_in = 4'b1111;  // solta tecla
        #2000;

        // Pressiona tecla "0"
        $display(">>> Pressionando tecla 0");
        key_in = 4'b1101;  // tecla "0"
        #2000;
        key_in = 4'b1111;
        #2000;

        // Finaliza
        $display(">>> Simulação finalizada.");
        #1000;
        $finish;
    end

    // Monitoramento
    initial begin
        $monitor("T=%0t | key_in=%b | seg=%b | an=%b | number=%h",
                  $time, key_in, seg, an, dut.number);
    end

endmodule
