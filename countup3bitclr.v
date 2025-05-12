// 3 Bit up counter with synchronous clear.
// This design is part of the toy CPU, and is used
// for the instruction counter.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 27, 2025.
module countup3bitclr (input wire clk, input wire rst,
	input wire en, input wire clr, output reg[2:0] Q);

	always @ (posedge clk or negedge rst) begin
		if (rst==0) begin
			Q <= 0;
		end else begin
			if (en==1) begin
				if (clr==1) begin
					Q <= 3'b000;
				end else begin
					Q <= Q + 1;
				end
			end
		end
	end
	
endmodule
