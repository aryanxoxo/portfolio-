module datapath(sximm8, sximm5, vsel, writenum, write, readnum, clk, loada, loadb, loadc, shift, asel, bsel, ALUop, loads, Z_out, datapath_out, mdata);
    // I/O declarations
    input [15:0] sximm5, sximm8, mdata; // added for lab 6 onwards
    input [3:0] vsel;
    input clk, write, loada, loadb, loadc, loads, asel, bsel;
    input [2:0] writenum, readnum; 
    input [1:0] shift, ALUop;
    output [2:0] Z_out; // changed to 3 bit width for lab 6 onwards
    output [15:0] datapath_out;

    // internal wire declarations
    wire [15:0] data_in, data_out, in, outA, Ain, Bin, out, sout;
    wire [2:0] Z; // changed to 3 bits from 1 bit for lab(s) 6/7/8
    wire [15:0] mdata; // wires to become inputs in labs 7 & 8
    wire [7:0] PC; // TBD for labs 7 and 8

    // placeholders for lab 6 (TBD for lab(s) 7 & 8)
    assign PC = 8'b00000000;
    // assign mdata = 16'b0000000000000000;

    // instantiations of all modules used
    MUX4 pos9(mdata, sximm8, {8'b0, PC}, datapath_out, vsel, data_in); // element (9) on lab handout, has 4 options in preparations for labs 7 & 8
    regfile REGFILE(data_in, writenum, write, readnum, clk, data_out); // element (1) on lab handout: primary register (8 regs of 16 bits each)
    vDFFE #(16) A(clk, loada, data_out, outA); // loada on lab handout, element (3)
    vDFFE #(16) B(clk, loadb, data_out, in); // loadb on lab handout, element (4)
    shifter T2(in, shift, sout); // shifter module, element (8)
    MUX2 pos7(sout, sximm5, bsel, Bin); // element (7) on lab handout, feeds into ALU
    MUX2 pos6(outA, 16'b0, asel, Ain); // element (6) on handout, feeds into ALU
    ALU T1(Ain, Bin, ALUop, out, Z); // ALU module, element (2)
    vDFFE #(3) status(clk, loads, Z, Z_out); // status register, element (10) (changed to 3 bit width on Z, Z_out for lab 6 onwards)
    vDFFE #(16) c(clk, loadc, out, datapath_out); // 'out' comes from ALU output (5), outputs datapath_out

    //assign datapath_out = C; 
endmodule

module MUX2(in0, in1, s, b); // 2 option selection multiplexer
    input [15:0] in0, in1;  // inputs
    input s; // binary select
    output reg [15:0] b; // output of multiplexer

    always @(*) begin // sets 'b' to desired register based on binary input 's'
        case (s) // case statement to deicide witch input to give to outbut 'b'
            1'b0: b <= in0; // position 2 select
            1'b1: b <= in1; // position 1 select
            default: b <= 16'bxxxxxxxxxxxxxxxx; // default value to avoid latches
        endcase
     end
endmodule

module MUX4(in0, in1, in2, in3, s, b); // 4 option selection multiplexer -- needs to be modified for later labs (7 & 8)
    input [15:0] in0, in1, in2, in3;  // inputs
    input [3:0] s; // one hot
    output reg [15:0] b; // output of multiplexer

    always @(*) begin // sets 'b' to desired register based on binary input 's'
        case (s) // case statement to deicide witch input to give to outbut 'b'
            4'b0001: b <= in0; // position 0 select
            4'b0010: b <= in1; // position 1 select
            4'b0100: b <= in2; // position 2 select
            4'b1000: b <= in3; // position 3 select
            default: b <= 16'bxxxxxxxxxxxxxxxx; // default value to avoid latches
        endcase
     end
endmodule
