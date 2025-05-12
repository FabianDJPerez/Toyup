// RAM 64, 8 Bit register Memory design.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 27, 2025.
module RAM8x64(input wire [7:0] add, input wire oe, 
    output wire [7:0] O);
    // Memory. Uses internal FPGA flip-flops.
    reg [7:0] MEM [63:0];

    assign O = oe ? MEM[add] : 8'bzzzzzzzz;

     // Program initialization, simulation data, with program.txt.
    integer i;
    initial begin
        for (i=0; i<64; i=i+1)
            MEM[i] = 8'h00;
        $readmemh ("program.txt", MEM);
    end

endmodule
