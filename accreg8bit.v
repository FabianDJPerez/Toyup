// 8 Bit buffered-output accumulator register.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 24, 2025.
module accreg8bit (input wire clk, input wire en,
	input wire ldacc, input wire oe, 
	input wire[7:0] D,
	output wire[7:0] O);
	
	wire [7:0] X, Y;
	wire cout;
	reg [7:0] Q;

	assign {cout, X} = D + Q;  // Sum.
	assign Y = ldacc ? X : D;  // Mux.
	assign O = oe ? Q : 8'bzzzzzzzz;  // Buffer.

	// D-type register.
	always @ (posedge clk) begin
		if (en==1) begin
			Q <= Y;
		end
	end
endmodule
