module shifter(in, shift, sout); // shifter module, modifies input from register B/loadb input depending on shift value (00, 01, 10, or 11)
input [15:0] in; // input value
input [1:0] shift; // operation selection
output reg [15:0] sout; // output

parameter k = 16; // width parameter

always @(*)begin // primary module logic, selects 'sout' based on shift value
 case (shift) // selects 'sout' based on shift value
  2'b00: sout = in; // no changes to input
  2'b01: sout = {in[15:0],1'b0}; // shifts left 1 bit (LSB = 0)
  2'b10: sout = {1'b0,in[15:1]}; // shifts right 1 bit (MSB = 0)
  2'b11: sout = {1'b1,in[15:1]}; // shifts right 1 bit (MSB = in[15])
  default: sout = {k{1'bx}}; // default value to avoid latches
 endcase
end
endmodule

