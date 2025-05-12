
`timescale 1ns/1ps

// Testbench module to test serial input into Register A via IPORT[0]
module sipo_reg_tb;

    // Declare testbench signals
    reg clk;         // Clock signal
    reg rst;         // Active-high reset signal
    reg [7:0] IPORT; // Input port (only IPORT[0] used for serial input)
    wire [7:0] OPORT; // Output port (to observe result)

    // Instantiate the toy processor
    toyup Microprocessor (
        .clk(clk),
        .rst(rst),
        .IPORT(IPORT),
        .OPORT(OPORT)
    );

    // Clock generation: 10 ns period (5 ns high, 5 ns low)
    initial clk = 0;
    initial begin 
        rst = 0;
        #10 rst = 1;
    end
    always #5 clk = ~clk;

    initial begin
        // Open VCD file for waveform dumping
        $dumpfile("sipo_reg_tb.vcd");
        $dumpvars(0, sipo_reg_tb);

        // Initial state: assert reset
        rst = 0;
        IPORT = 8'h00; // Keep all inputs low initially
        #10 rst = 1;   // Deassert reset after 10 ns

        // Serial input of 0xA5 (binary: 10100101) bit by bit
        // LSB first (assuming that's how the design expects it)
        IPORT[0] = 1; #10; // Bit 0
        IPORT[0] = 0; #10; // Bit 1
        IPORT[0] = 1; #10; // Bit 2
        IPORT[0] = 0; #10; // Bit 3
        IPORT[0] = 0; #10; // Bit 4
        IPORT[0] = 1; #10; // Bit 5
        IPORT[0] = 0; #10; // Bit 6
        IPORT[0] = 1; #10; // Bit 7 - MSB sent last

        // Wait a bit more and check output
        #100 $display("Resultado en OPORT: %h", OPORT); // Should display A5

        // End simulation
        #200 $finish;
    end

endmodule