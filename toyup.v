// Toy Microprocessor design.
// Written by Juan Bernardo Gómez-Mendoza.
// Latest update: April 27, 2025.
module toyup (input wire rst, input wire clk, 
    input wire [7:0] IPORT, output wire [7:0] OPORT);

    wire [7:0] bus;
    wire [7:0] add;  // Connects PC with mem.
    // A(IE, OE, ACC); B(IE, OE); I(OE); O(IE); 
    // PC(EN, LD); MEM(OE); IR(IE); IC(EN, CLR)
    wire [12:0] CW;  // Control word.
    wire [7:0] INSTRUCTION; // Current instruction.
    wire [2:0] STEP; // Current step of the instruction.

    // Component instantiation.
    countup8bitld PC (.clk(clk), .en(CW[5]), .rst(rst), 
        .ld(CW[4]), .D(bus), .Q(add));
    countup3bitclr IC (.clk(clk), .en(CW[1]), .rst(rst),
        .clr(CW[0]), .Q(STEP));
    accreg8bit A(.clk(clk), .en(CW[12]), .ldacc(CW[10]), 
        .oe(CW[11]), .D(bus), .O(bus));
    buffdreg8bit B(.clk(clk), .en(CW[9]), .oe(CW[8]), 
        .D(bus), .O(bus));
    buffdreg8bit I(.clk(clk), .en(1'b1), .oe(CW[7]), 
        .D(IPORT), .O(bus));
    buffdreg8bit O(.clk(clk), .en(CW[6]), .oe(1'b1), 
        .D(bus), .O(OPORT));
    dreg8bit IR (.clk(clk), .en(CW[2]), .rst(rst), 
        .D(bus), .Q(INSTRUCTION));    
    RAM8x64 MEM (.add(add), .oe(CW[3]), .O(bus));
    ControlUnit cu (.clk(clk), .instr(INSTRUCTION), 
        .step(STEP), .CW(CW));   

    // Registro Serie-Paralelo (SIPO)
    sipo_reg u_sipo (
        .clk(clk),
        .rst_n(rst),
        .en(CW[9]),         // Habilitado por CW[9]
        .din(IPORT[0]),     // Bit serie desde IPORT[0]
        .dout(bus)          // Conecta directamente al bus interno
    ); 

     // === Nuevo módulo de registro de desplazamiento ===
    wire [7:0] shift_data;

    shift_register_8bit u_shift_reg (
        .clk(clk),
        .rst_n(rst),
        .shift_left(CW[11]),     // Dirección de desplazamiento
        .load_en(CW[12]),       // Habilita carga paralela
        .data_in(bus),           // Datos desde el bus interno
        .data_out(shift_data)    // Salida después del desplazamiento
    );

    // Opcional: conectar salida al bus o al puerto de salida
    buffdreg8bit SHIFT_BUFFER (
        .clk(clk),
        .en(CW[12]),           // Habilitado con CW[12]
        .oe(1'b1),             // Siempre habilitado para debug
        .D(shift_data),         // Datos del registro de desplazamiento
        .O(bus)
    );
    

    

endmodule
