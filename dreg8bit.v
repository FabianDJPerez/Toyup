// 8 Bit D-type register.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 28, 2025.
module dreg8bit (input wire clk, input wire en,
	input wire rst, input wire[7:0] D, 
	output reg[7:0] Q);

	// D-type register.
	always @ (posedge clk or negedge rst) begin
		if (rst==0) begin
			Q <= 0;
		end else begin
			if (en==1) begin
				Q <= D;
			end
		end
	end
endmodule
