module regfile(data_in, writenum, write, readnum, clk, data_out); // primary register module
    // primary module I/O
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write, clk;
    output [15:0] data_out;
    
    // internal wire declarations
    wire [7:0] outs;
    wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;

    ANDer wn(writenum, write, outs); // decoder and ANDing

    vDFFE #(16) r0(clk, outs[0], data_in, R0); // instantiation of R0
    vDFFE #(16) r1(clk, outs[1], data_in, R1); // instantiation of R1
    vDFFE #(16) r2(clk, outs[2], data_in, R2); // instantiation of R2
    vDFFE #(16) r3(clk, outs[3], data_in, R3); // instantiation of R3
    vDFFE #(16) r4(clk, outs[4], data_in, R4); // instantiation of R4
    vDFFE #(16) r5(clk, outs[5], data_in, R5); // instantiation of R5
    vDFFE #(16) r6(clk, outs[6], data_in, R6); // instantiation of R6
    vDFFE #(16) r7(clk, outs[7], data_in, R7); // instantiation of R7
    
    regmux #(16) rn(R0, R1, R2, R3, R4, R5, R6, R7, readnum, data_out); // readnum decoder and mux selector
endmodule

module Dec(a, b) ; // n:m decoder taken from slide-set 6
  parameter n=2 ;
  parameter m=4 ;

  input  [n-1:0] a ;
  output [m-1:0] b ;

  wire [m-1:0] b = 1 << a;
endmodule

module regmux(R0, R1, R2, R3, R4, R5, R6, R7, sb, b); // code taken from slide-set 6, modified
    parameter k = 1; // width parameter
    input [k-1:0] R0, R1, R2, R3, R4, R5, R6, R7;  // register inputs
    input [2:0] sb;
    output [k-1:0] b;
    wire  [7:0] s; //  internal wire to pass output of decoder to MUX selection
  
    Dec #(3,8) rn(sb,s); // Decoder converts binary to one-hot to select register position
    Mux16 #(16) r(R0, R1, R2, R3, R4, R5, R6, R7, s, b); // multiplexer selects input
endmodule

module Mux16(R0, R1, R2, R3, R4, R5, R6, R7, s, b); // register selection multiplexer
    parameter k = 1; // bit parameter
    input [k-1:0] R0, R1, R2, R3, R4, R5, R6, R7;  // inputs
    input [7:0] s; // one-hot select
    output reg [k-1:0] b;

    always @(*) begin // sets 'b' to desired register based on one-hot input 's'
        case (s) // determines which register to output based of selection 's'
            8'b00000001: b <= R0; // R0 is selected
            8'b00000010: b <= R1; // R1 is selected
            8'b00000100: b <= R2; // R2 is selected
            8'b00001000: b <= R3; // R3 is selected
            8'b00010000: b <= R4; // R4 is selected
            8'b00100000: b <= R5; // R5 is selected
            8'b01000000: b <= R6; // R6 is selected
            8'b10000000: b <= R7; // R7 is selected
            default: b <= 16'bxxxxxxxxxxxxxxxx; // default value to avoid latches
        endcase
    end
endmodule

module ANDer(writenum, write, outA); // ANDs first decoder and write together for input of registers
    input [2:0] writenum;
    input write;
    output [7:0] outA;
    wire [7:0] oneh; // output from first decoder to be ANDed with write

    Dec #(3,8) wn(writenum, oneh); // writenum decoder

    // below assign statements set each bit of 'outA' to zero or one, based off ANDing of write and 'oneh'
    assign outA[0] = oneh[0] & write; 
    assign outA[1] = oneh[1] & write;
    assign outA[2] = oneh[2] & write;
    assign outA[3] = oneh[3] & write;
    assign outA[4] = oneh[4] & write;
    assign outA[5] = oneh[5] & write;
    assign outA[6] = oneh[6] & write;
    assign outA[7] = oneh[7] & write;

endmodule

module vDFFE(clk, en, in, out); // register with load enable taken from lab5 introduction slide set
  parameter n = 1;  // width
  input clk, en ;
  input  [n-1:0] in ;
  output [n-1:0] out ;
  reg    [n-1:0] out ;
  wire   [n-1:0] next_out ;

  assign next_out = en ? in : out;

  always @(posedge clk)
    out = next_out;
endmodule
