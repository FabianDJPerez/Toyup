// Module: shift_register_8bit
// Written by: Faián De Jesús Pérez Salazar.
// Latest update: April 30, 2025
// Description: An 8-bit shift register that shifts one bit at a time (left or right)
module shift_register_8bit (
    input wire clk,
    input wire rst_n,        // Active-low reset
    input wire shift_left,   // Direction control: 1 = left, 0 = right
    input wire load_en,      // Enable parallel load
    input wire [7:0] data_in, // Data from internal bus
    output reg [7:0] data_out // Shifted result
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 8'h00; // Reset to zero
        end else if (load_en) begin
            data_out <= data_in; // Load new value in parallel
        end else if (shift_left) begin
            data_out <= {data_out[6:0], 1'b0}; // Shift left by 1 bit
        end else begin
            data_out <= {1'b0, data_out[7:1]}; // Shift right by 1 bit
        end
    end

endmodule