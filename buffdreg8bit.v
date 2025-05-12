// 8 Bit buffered-output D-type register.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 24, 2025.
module buffdreg8bit (input wire clk, input wire en,
	input wire oe, input wire[7:0] D,
	output wire[7:0] O);
	
	reg [7:0] Q;
	assign O = oe ? Q : 8'bzzzzzzzz;  // Buffer.

	// D-type register.
	always @ (posedge clk) begin
		if (en==1) begin
			Q <= D;
		end
	end
endmodule
