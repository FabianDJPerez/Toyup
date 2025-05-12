// 8 Bit up counter with parallel synchronous load.
// This design is part of the toy CPU, and is
// primarily used for the program counter.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 27, 2025.
module countup8bitld (input wire clk, input wire rst, 
	input wire en, input wire ld, input wire [7:0] D,
	output reg [7:0] Q);

	wire [8:0] sum;
	wire [7:0] mux;

	assign sum = Q + 1;
	assign mux = ld ? D : sum[7:0];

	always @ (posedge clk or negedge rst) begin //Reset=0 is an instntriction of not operation.
		if (rst==0) begin
			Q <= 8'hFF;
		end else begin
			if (en==1) begin
				Q <= mux;
			end
		end
	end
endmodule

