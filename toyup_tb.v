// Toy Microprocessor design test bench.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 27, 2025.
`timescale 1ns/1ps
module toyup_tb ();

    reg clk, rst;
    reg [7:0] IPORT;
    wire [7:0] OPORT;

    initial clk = 0;
    initial begin 
        rst = 0;
        #10 rst = 1;
    end
    always #5 clk = ~clk;

    toyup Microprocessor(.clk(clk), .rst(rst), 
        .IPORT(IPORT), .OPORT(OPORT));

    initial begin
        $dumpfile("toyup.vcd");
        $dumpvars;
        #500;
        $finish;
    end

endmodule
