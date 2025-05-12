// Control Unit design.
// Written by Faián De Jesús Pérez Salazar.
// Latest update: April 30, 2025.
module ControlUnit(input wire clk, input wire [7:0] instr, 
    input wire [2:0] step, output wire[12:0] CW);

    //The control unit funtion with low flank because, I neet that the information be disponible before
    // that the register need.

    reg [12:0] word = 0;

    assign CW = word;
    reg [159:0] OP;

    // Control unit design.
    always @ (negedge clk) begin
        case(instr)
            8'h00: begin   // NOP.
                    OP = "NOP";
                    if (step==0) 
                        // PC <- PC+1; IC <- IC+1
                        word = 13'b0000000100010;
                    if (step==1) 
                        // IR <- MEM[PC]; IC <- 0
                       word = 13'b0000000001111;
                end
            8'h01: begin  // B <-A;    LD B, A
                    OP = "LD B, A";
                    if (step==0) 
                        // B <- A; PC <- PC+1; IC <- IC+1
                        word = 13'b0101000100010;
                    if (step==1) 
                        // IR <- MEM[PC]; IC <- 0
                        word = 13'b0000000001111;
                end
            8'h02: begin  // A <- MEM[PC+1];    LD A, MEM[PC+1]
                    OP = "LD A, MEM[PC+1]";
                    if (step==0) 
                        // PC <- PC+1; IC <- IC+1
                        word = 13'b0000000100010;
                    if (step==1) 
                        // A <- MEM[PC]; IC <- IC+1
                        word = 13'b1000000001010;
                    if (step==2) 
                        // PC <- PC+1; IC <- IC+1
                        word = 13'b0000000100010;
                    if (step==3) 
                        // IR <- MEM[PC]; IC <- 0
                        word = 13'b0000000001111;
                end
            8'h03: begin  // PC <- MEM[PC+1];    JMP MEM[PC+1]
                    OP = "JMP MEM[PC+1]";
                    if (step==0) 
                        // PC <- PC+1; IC <- IC+1
                        word = 13'b0000000100010;
                    if (step==1) 
                        // PC <- MEM[PC]; IC <- IC+1
                        word = 13'b0000000111010;
                    if (step==2) 
                        // IR <- MEM[PC]; IC <- 0
                        word = 13'b0000000001111;
                end
            8'h04: begin    // A <- A + B;    ACC A, B
                    OP = "ACC A, B";
                    if (step==0) 
                        // A <- A+B; PC <- PC+1; IC <- IC+1
                        word = 13'b1010100100010;
                    if (step==1) 
                        // IR <- MEM[PC]; IC <- 0
                        word = 13'b0000000001111;
                end
            8'h05: begin  // O <-A;    OUT A
                    OP = "OUT A";
                    if (step==0) 
                        // O <- A; PC <- PC+1; IC <- IC+1
                        word = 13'b0100001100010;
                    if (step==1) 
                        // IR <- MEM[PC]; IC <- 0
                        word = 13'b0000000001111;
                end  
            8'h06: begin  // ADD_SERIAL - Sumar dos operandos recibidos en serie
                OP = "ADD_SERIAL";

                if (step == 0)
                    word = 13'b0000000010010; // Enable serial adder
                if (step == 1)
                    word = 13'b0000000010010; // Continue for 8 cycles (manejar en HW)
                if (step == 2)
                    word = 13'b0000000001111; // Load IR again
                end
            8'h07: begin  // MOV A,B;
                OP = "MOV A,B";
                if (step==0)  // A <- B; PC <- PC+1; IC <- IC+1
                    word = 13'b1000100100010;
                if (step==1)  // IR <- MEM[PC]; IC <- 0
                    word = 13'b0000000001111;
                end  
            8'h08: begin  // LOAD_SERIAL_TO_BUS
                OP = "LOAD_SERIAL_TO_BUS";
                if (step == 0)
                    word = 13'b0000000001000; // Enable SIPO register (CW[9])
                if (step >= 1 && step <= 8) 
                    word = 13'b0000000001000; // Keep sipo_reg enabled
                if (step == 9)
                    word = 13'b0000000001111; // Load IR again
                end  
            8'h09: begin  // LOAD_A_TO_SHIFT_REG
                OP = "LOAD_A_TO_SHIFT_REG";
                if (step == 0)
                    word = 13'b0000000010010; // A_OE + load_en
                if (step == 1)
                    word = 13'b0000000000010; // Mantener enable
                if (step == 2)
                    word = 13'b0000000001111; // Finalizar
                end
            8'h11: begin  // SHIFT_LEFT_REG
                OP = "SHIFT_LEFT_REG";
                if (step == 0)
                    word = 13'b0000000010010; // load_en + shift_left
                if (step == 1)
                    word = 13'b0000000010010; // Continuar desplazando
                if (step == 2)
                    word = 13'b0000000001111; // Finalizar
                end
        endcase
    end

endmodule
