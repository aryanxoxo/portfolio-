module ALU(Ain, Bin, ALUop, out, Z); // Arithmetic Logic Unit Module
input [15:0] Ain, Bin; // Inputs
input [1:0] ALUop; // Determines operation to be made on Ain and Bin
output reg [15:0] out; // output value of operation
output [2:0] Z; // Used for status block

// Declared for lab 6/7/8 to be used to check for overflow
wire ovf, sub;
wire [15:0] s;

    always @(*) begin // Checks ALUop value and performs operations accordingly
        case (ALUop)
            2'b00: out = Ain + Bin; // Adds inputs
            2'b01: out = Ain - Bin; // subtracts inputs
            2'b10: out = Ain & Bin; // ANDs inputs
            2'b11: out = ~Bin; // NOTs Bin
            default: out = 16'bxxxxxxxxxxxxxxxx; // Default out value to avoid latches
        endcase
    end

    // Lab 6 onwards overflow check
    AddSub #(16) ovfcheck(Ain, Bin, sub, s, ovf);
    assign sub = ALUop == 2'b01 ? 1'b1: 1'b0; // assigns sub to approptiate value (1 if ALUop == 01, otherwise 0)

    // Updated Z values for lab 6 onwards MIGHT BE INCORRECT
    assign Z[0] = out == 16'b0 ? 1'b1 : 1'b0; // Z to be used for status block
    assign Z[1] = out[15] == 1'b1 ? 1'b1 : 1'b0; // negative flag, set to 1 if MSB of out == 1
    assign Z[2] = ovf == 1'b1 ? 1'b1 : 1'b0; // overflow flag, set to 1 if overflow in computation

endmodule

module AddSub(a, b, sub, s, ovf); // Used primarily to calculate overflow for Z[2] (Taken from slide-set 6)
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input sub;           // subtract if sub=1, otherwise add
  output [n-1:0] s ;
  output ovf ;          // 1 if overflow
  wire c1, c2 ;         // carry out of last two bits
  wire ovf = c1 ^ c2 ;  // overflow if signs don't match

  // add non sign bits
  Adder #(n-1) ai(a[n-2:0],b[n-2:0]^{n-1{sub}},sub,c1,s[n-2:0]);
  // add sign bits
  Adder #(1) as(a[n-1],b[n-1]^sub,c1,c2,s[n-1]);
endmodule

module Adder(a, b, cin, cout, s); // Used within AddSub to calculate overflow for Z[2] (Taken from slide-set 6)
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input cin ;
  output [n-1:0] s ;
  output cout ;
  wire [n-1:0] s;
  wire cout ;

  assign {cout, s} = a + b + cin;
endmodule 

