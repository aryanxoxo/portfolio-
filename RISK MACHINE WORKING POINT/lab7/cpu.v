// cpu cp((clk, reset, in, mdata, mem_cmd, addr_sel, load_pc, reset_pc, load_addr, datapath_out); // NEW cpu module instantiation (AS PER FIGURE 2)
module cpu(clk, reset, in, mdata, out, N, V, Z, mem_cmd, addr_sel, load_addr, load_pc, reset_pc);
    input clk, reset;
    input [15:0] in, mdata;
    output [15:0] out;
    output N, V, Z, load_pc, load_addr, reset_pc, addr_sel;
    output [1:0] mem_cmd;

    wire [13:0] mainout;
    wire [2:0] opcode, writenum, readnum;
    wire [1:0] op, shift, ALUop;
    wire [15:0] sximm8, sximm5, regout;
    wire load_ir;
    wire [2:0] zonk;

    // Z_out assignments
    assign Z = zonk[0]; // original status
    assign V = zonk[2]; // overflow status
    assign N = zonk[1]; // negative status

    vDFFE #(16) ireg(clk, load_ir, in, regout); // instruction register
    InDecoder id(regout, mainout[13:11], opcode, op, writenum, readnum, shift, ALUop, sximm8, sximm5); // instruction decoder
    state1 sm(s, reset, clk, w, opcode, op, mainout); // state machine
    datapath DP(sximm8, sximm5, mainout[10:7], writenum, mainout[0], readnum, clk, mainout[1], mainout[2], mainout[3], shift, mainout[5], mainout[6], ALUop, mainout[4], zonk, out, mdata);
endmodule

module InDecoder(in, nsel, opcode, op, writenum, readnum, shift, ALUop, sximm8, sximm5); // instruction decoder as in lab6 handout
    input [15:0] in;
    input [2:0] nsel; // 1 hot select to pick betweer Rn, Rd, Rm
    output [2:0] opcode, writenum;
    output [1:0] op;
    output [15:0] sximm8, sximm5;
    output [1:0] shift, ALUop;
    output reg [2:0] readnum;

    assign shift = in[4:3]; // shift values to be passed on to datapath
    assign ALUop = in[12:11]; // ALUop values to be passed on to datapath
    assign opcode = in[15:13]; // feeds into state machine
    assign op = in [12:11]; // feeds into state machine
    assign writenum = readnum; // Equating writenum and readnum

    SignExtend #(8) sx8(in[7:0], sximm8); // sign extention for sximm8
    SignExtend sx5(in[4:0], sximm5); // sign extention for sximm5

    always @(*) begin // MUX to select Rn, Rd, Rm
        case (nsel)
            3'b001: readnum = in[2:0]; // Rm
            3'b010: readnum = in[7:5]; // Rd
            3'b100: readnum = in[10:8]; // Rn
            default: readnum = 3'bxxx; // default value to avoid latches
        endcase
    end
endmodule

module SignExtend(inx, outx); // sign extend function used for sximm8 & sximm5 (Currently only for 5 or 8 bits)
    parameter n = 5;
    input [n-1:0] inx;
    output reg [15:0] outx;
    
    always @(*) begin // Adds enough 1's or 0's to make inx 16 bits based on MSB
        if (n == 5) begin
            if (inx[4] == 0) begin
                outx = {11'b00000000000,inx}; // if MSB == 0 for sximm5
            end else begin
                outx = {11'b11111111111,inx}; // if MSB == 1 for sximm5
            end
        end else begin
            if (inx[7] == 0) begin
                outx = {8'b00000000,inx}; // if MSB == 0 for sximm8
            end else begin
                outx = {8'b11111111,inx}; // if MSB == 1 for sximm8
            end
        end
    end
endmodule

// TODO for STATE MACHINE:
//    ADD load_ir
//    ADD load_pc
//    ADD load_addr
//    ADD addr_sel
//    ADD reset_pc
//    ADD mem_cmd
module state1(s, reset, clk, w, opcode, op, mainout); 
 // module I/O
`define waiting             4'b0001 // Wait State
`define decode              4'b0011 // Secode State
`define read_n_a            4'b0111 // Load into RegA
`define read_m_b            4'b1111 // Load into RegB
`define write_d_c           4'b1110 // Write Output into RegD
`define write_n_sx          4'b1100 // Write Into Register Rx
`define calculate_nb_na     4'b1000 // Send RegA and RegB Through ALUop
`define calculate_nb_a      4'b0000 // Send Reg into Shifter
`define status              4'b1001 // Output Status Values Z, V, N
`define clkwait             4'b1010 // Wait for Additional Clk Cycle
    // Module I/O
    input s, reset, clk;
    input [2:0] opcode;
    input [1:0] op;
    output w;
    output reg [13:0] mainout; 
   
    reg [3:0] next_state, state; // States

    assign w = state == `waiting ? 1'b1 : 1'b0; // Assigns W = 1 if in waiting state, otherwise 0, used for autograder

    always @(posedge clk) begin // reset block, handles reset value and returning to wait as a result
        if (reset == 1'b1) begin
            state = `waiting;
    end else begin
            state = next_state;
        end
    end
    
always@(*) begin
  case(state)
    `waiting        :next_state = s == 1'b1 ? `decode : `waiting; //1.final// 2.final //3.final //5.final //4.final // 6.final
    `decode         :begin if ({opcode,op}== 5'b10111) next_state = `read_m_b;  //6.a
                     else  if ({opcode,op}== 5'b11000) next_state = `read_m_b;  //2.a
                     else  if ({opcode,op}== 5'b11010) next_state = `write_n_sx;//1.a
                     else   next_state = `read_n_a; end //3.a //5.a //4.a
    `read_n_a       :next_state = `read_m_b;//3.b //5.b //4.b
    `read_m_b       :next_state = ({opcode,op}==5'b110xx) ? `calculate_nb_a :`calculate_nb_na; //2.b/nb_a //3.c/5.c/4.c/6.b/nb_nb 
    `calculate_nb_a :next_state = `write_d_c;  //2.c
    `calculate_nb_na:next_state = ({opcode,op}==5'b10101) ? `status :`write_d_c;  //4.d // 3.d/ 5.d/ 6.c else `write_d_c
    `write_n_sx     :next_state = `clkwait; //1.b WAITING
    `write_d_c      :next_state = `clkwait; //2.d //3.e/5.e/6.d was WAITING
    `status         :next_state = `clkwait; //4.e WAITING
    `clkwait        :next_state = `waiting; // ADDED
     default        :next_state = `waiting;
  endcase
end 

  always @(*)begin
   case(state) 
      `read_n_a        :mainout = 14'b100_0000_00_0001_0;  // read Rn into A
      `read_m_b        :mainout = 14'b001_0000_00_0010_0;  // read Rm into B
      `calculate_nb_a  :mainout = 14'b000_0000_01_0100_0; // Send reg through Shifter
      `calculate_nb_na :mainout = 14'b000_0000_00_0100_0; // ALUop values in RegA and RegB
      `write_d_c       :mainout = 14'b010_1000_00_0100_1;  //write C using vsel to Rd
      `write_n_sx      :mainout = 14'b100_0010_00_0000_1;  //write sximm8 using vsel to Rn
      `status          :mainout = 14'b000_0000_00_1000_0; // Output status values
      `clkwait         :mainout = 14'b000_0000_00_0100_0; // delay cycle
       default         :begin mainout = 14'b0; end  //default for waiting state, decode state, and any other ones for the porpose of debugging
   endcase 
end
endmodule
