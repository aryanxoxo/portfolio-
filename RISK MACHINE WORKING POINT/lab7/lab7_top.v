module lab7_top(KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    `define MREAD 2'b00;
    `define MWRITE 2'b00;
    input [3:0] KEY;
    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire [8:0] mem_addr;
    wire [15:0] write_data;
    wire msel, mcmd; // outputs to equality comparators 8 and 9, respectivley
    wire ando; // fed into tri-state driver via and of msel and mcmd
    wire wcalc; // feeds into AND gate which powers write in RAM
    wire [8:0] addrm0, addrm1; // feed into addr select MUX from Data Address Reg and PC, respectivley
    wire swc, ledc; // switch and LED tri-state control wires, respectivley

    // primary module instantiation
    RAM MEM(clk, read_address, write_address, write, din, dout); // memory module instantiation
    cpu cp(clk, reset, read_data, read_data, write_data, N, V, Z, mem_cmd, addr_sel, load_addr, load_pc, reset_pc); // cpu module instantiation

    // R/W Memory block input logic
    assign msel = mem_addr[8] == 1'b0 ? 1'b1 : 1'b0; // fed into AND gate to determine ando (8)
    assign mcmd = (mem_cmd == `MREAD) ? 1'b1 : 1'b0; // fed into AND gate to determine ando (9)
    assign ando = msel & mcmd ? 1'b1 : 1'b0; // fed into tri-state driver (7)
    assign read_data = ando == 1'b1 ? dout : 32'bz; // Tri-state comparator (7)
    assign read_address = mem_addr[7:0];

    // PC and Data Address logic
    MUX2 pcSel((addrm1 + 1'b1), 9'b0, reset_pc, next_pc); // PC Select MUX (Might need to change first input)
    vDFFE #(9) PC(clk, load_pc, next_pc, addrm1); // Program Counter Register
    vDFFE #(9) dataA(clk, load_addr, write_data[8:0], addrm0); // Data Address Register
    MUX2 addrSel(addrm0, addrm1, addr_sel, mem_addr); // Address Select MUX

    // Section 2.3 --- Stage 3 (I/O Devices)
    assign wcalc = (mem_cmd == `MWRITE) ? 1'b1 : 1'b0;
    assign write = msel & wcalc ? 1'b1 : 1'b0; // fed into write
    assign write_address = mem_addr[7:0];
    assign din = write_data;

    // Switch controls (2.3)
    indevice id(mem_cmd, mem_addr, swc);
    assign read_data[15:8] = swc == 1'b1 ? 0'h00 : 8'bz; // tri-state converter
    assign read_data[7:0] = swc == 1'b1 ? SW[7:0] : 8'bz; // tri state converter

    // LED controls (2.3)
    outdevice od(mem_cmd, mem_addr, ledc);
    vDFFE #(8) ledload(clk, ledc, write_data[7:0], LEDR[7:0]); // register for LED outputs
endmodule

module RAM(clk, read_address, write_address, write, din, dout); // Taken from Slide-Set 7 as per Lab 7 document
  parameter data_width = 32; 
  parameter addr_width = 4;
  parameter filename = "data.txt";

  input clk;
  input [addr_width-1:0] read_address, write_address;
  input write;
  input [data_width-1:0] din;
  output [data_width-1:0] dout;
  reg [data_width-1:0] dout;

  reg [data_width-1:0] mem [2**addr_width-1:0];

  initial $readmemb(filename, mem);

  always @ (posedge clk) begin
    if (write)
      mem[write_address] <= din;
    dout <= mem[read_address]; // dout doesn't get din in this clock cycle 
                               // (this is due to Verilog non-blocking assignment "<=")
  end 
endmodule

module indevice(mem_cmd, mem_addr, out); // left block
  input [1:0] mem_cmd;
  input [8:0] mem_addr;
  output out;

  assign out = (mem_cmd == 2'b00) & (mem_addr == 0'h140) ? 1'b1 : 1'b0; // true if: read && mem_addr
endmodule

module outdevice(mem_cmd, mem_addr, out); // right block
  input [1:0] mem_cmd;
  input [8:0] mem_addr;
  output out;

    assign out = (mem_cmd == 2'b00) & (mem_addr == 0'h100) ? 1'b1 : 1'b0; // true if: write && mem_addr
endmodule