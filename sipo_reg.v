// Module: serial in parallel out reg sipo_reg
// Written by: Faián De Jesús Pérez Salazar.
// Latest update: April 30, 2025
// Description: Converts an 8-bit serial input into a parallel output.
// This module receives one bit per clock cycle and outputs all 8 bits in parallel.
module sipo_reg (
    input wire clk,
    input wire rst,
    input wire en,
    input wire din,
    output reg [7:0] dout
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            dout <= 8'h00;
        end else if (en) begin
            // Shift left: new bit enters LSB
            dout <= {dout[6:0], din};
        end
    end

endmodule