
module simple_rc_solution(

    //////////// CLOCK //////////
    CLOCK_50,

    //////////// LED //////////
    LEDR,

    //////////// KEY //////////
    KEY,

    //////////// SW //////////
    SW,

    //////////// SEG7 //////////
    HEX0,
    HEX1,
    HEX2,
    HEX3,
    HEX4,
    HEX5,

    
);
`define zero_pad(width,signal)  {{((width)-$size(signal)){1'b0}},(signal)}
//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input                       CLOCK_50;

//////////// LED //////////
output           [9:0]      LEDR;

//////////// KEY //////////
input            [3:0]      KEY;

//////////// SW //////////
input            [9:0]      SW;

//////////// SEG7 //////////
output           [6:0]      HEX0;
output           [6:0]      HEX1;
output           [6:0]      HEX2;
output           [6:0]      HEX3;
output           [6:0]      HEX4;
output           [6:0]      HEX5;

       
//=======================================================
//  parameter declarations
//=======================================================

//numbers
parameter character_0 =8'h30;
parameter character_1 =8'h31;
parameter character_2 =8'h32;
parameter character_3 =8'h33;
parameter character_4 =8'h34;
parameter character_5 =8'h35;
parameter character_6 =8'h36;
parameter character_7 =8'h37;
parameter character_8 =8'h38;
parameter character_9 =8'h39;


//Uppercase Letters
parameter character_A =8'h41;
parameter character_B =8'h42;
parameter character_C =8'h43;
parameter character_D =8'h44;
parameter character_E =8'h45;
parameter character_F =8'h46;
parameter character_G =8'h47;
parameter character_H =8'h48;
parameter character_I =8'h49;
parameter character_J =8'h4A;
parameter character_K =8'h4B;
parameter character_L =8'h4C;
parameter character_M =8'h4D;
parameter character_N =8'h4E;
parameter character_O =8'h4F;
parameter character_P =8'h50;
parameter character_Q =8'h51;
parameter character_R =8'h52;
parameter character_S =8'h53;
parameter character_T =8'h54;
parameter character_U =8'h55;
parameter character_V =8'h56;
parameter character_W =8'h57;
parameter character_X =8'h58;
parameter character_Y =8'h59;
parameter character_Z =8'h5A;

//Lowercase Letters
parameter character_lowercase_a= 8'h61;
parameter character_lowercase_b= 8'h62;
parameter character_lowercase_c= 8'h63;
parameter character_lowercase_d= 8'h64;
parameter character_lowercase_e= 8'h65;
parameter character_lowercase_f= 8'h66;
parameter character_lowercase_g= 8'h67;
parameter character_lowercase_h= 8'h68;
parameter character_lowercase_i= 8'h69;
parameter character_lowercase_j= 8'h6A;
parameter character_lowercase_k= 8'h6B;
parameter character_lowercase_l= 8'h6C;
parameter character_lowercase_m= 8'h6D;
parameter character_lowercase_n= 8'h6E;
parameter character_lowercase_o= 8'h6F;
parameter character_lowercase_p= 8'h70;
parameter character_lowercase_q= 8'h71;
parameter character_lowercase_r= 8'h72;
parameter character_lowercase_s= 8'h73;
parameter character_lowercase_t= 8'h74;
parameter character_lowercase_u= 8'h75;
parameter character_lowercase_v= 8'h76;
parameter character_lowercase_w= 8'h77;
parameter character_lowercase_x= 8'h78;
parameter character_lowercase_y= 8'h79;
parameter character_lowercase_z= 8'h7A;

//Other Characters
parameter character_colon = 8'h3A;          //':'
parameter character_stop = 8'h2E;           //'.'
parameter character_semi_colon = 8'h3B;   //';'
parameter character_minus = 8'h2D;         //'-'
parameter character_divide = 8'h2F;         //'/'
parameter character_plus = 8'h2B;          //'+'
parameter character_comma = 8'h2C;          // ','
parameter character_less_than = 8'h3C;    //'<'
parameter character_greater_than = 8'h3E; //'>'
parameter character_equals = 8'h3D;         //'='
parameter character_question = 8'h3F;      //'?'
parameter character_dollar = 8'h24;         //'$'
parameter character_space=8'h20;           //' '     
parameter character_exclaim=8'h21;          //'!'


//=======================================================================================================================
//
// Insert your code for Lab4 here!
//
//=======================================================================================================================
// Input and output declarations
logic CLK_50M;
logic  [9:0] LED;
logic [23:0] secret_key; 
assign CLK_50M =  CLOCK_50;
assign LEDR[9:0] = {LED[9:2], light};
//assign LED [9:0] = SW [9:0];

wire [7:0]  read_s_signal;
wire [7:0]  read_d_signal;
wire [7:0]  read_e_signal;
logic [7:0]  address_1,address_2, address_3;
logic [7:0]  data_1, data_2, data_3;
logic        wen_1, wen_2, wen_3; 
logic       wen, wen_d; 
logic       finito_task1;
logic       finito_task2;
logic [7:0] address;
logic [4:0] address_d,address_e;
logic [7:0] data, data_d;
logic       Clock_1kHz;
logic 	   ready;
logic			failure;
logic			res;
logic zonk;
logic [4:0] address_chose;
logic [4:0] address_FSM;
logic [1:0] potato;
logic [1:0] light;

// TA CHANGE .constant to 32'd25 IF CODE NOT WORKING(IT SHOULD WORK AS IS THOUGH)
LAB1V2 clk_1kHz(.rst(1'b0), .clk(CLK_50M), .constant(32'd5), .clk_div(Clock_1kHz)); //clock divider code from LAB 1

datapath_task1 inst_task1(.clk(Clock_1kHz), .q(read_s_signal), .wen(wen_1), .address(address_1), .data(data_1),.finito(finito_task1), .commenco(res), .restart(zonk));
datapath_task2 inst_task2a(.address(address_2),.q(read_s_signal),.data(data_2),.wen(wen_2),.commenco(finito_task1 && potato[0]),.clk(Clock_1kHz),.finito(finito_task2),.secret_key(secret_key), .restart(zonk));
datapath_task2b inst_task2b(.address(address_3),.q(read_s_signal),.q_e(read_e_signal),.data(data_3),.wen(wen_3),.commenco(finito_task2 && potato[1]),.clk(Clock_1kHz),.finito(finito_task2b),.address_d(address_d), .address_e(address_e), .data_d(data_d), .wen_d(wen_d), .restart(zonk));

key_find_fsm(.clk(Clock_1kHz), .secret_key(secret_key), .switch_on(SW[0]), .task_wait({finito_task2b,finito_task2,finito_task1}), .q_d(read_d_signal), .begin_task_1(res), .restart(zonk), .address_d(address_FSM), .continue_x(potato), .light(light));

assign address_chose = (finito_task2b)? address_FSM: address_d;

s_memory S(.address(address), .clock(CLK_50M), .data(data), .wren(wen), .q(read_s_signal));
d_memory D(.address(address_chose), .clock(CLK_50M), .data(data_d), .wren(wen_d), .q(read_d_signal));
e_rom E(.q(read_e_signal),.clock(CLK_50M),.address(address_e));

assign address = (finito_task2)? address_3 :(finito_task1)? address_2 :  address_1; 
assign wen =     (finito_task2)? wen_3     :(finito_task1)? wen_2     :  wen_1; 
assign data =    (finito_task2)? data_3    :(finito_task1)? data_2    :  data_1; 

 
//=====================================================================================
//
//  Seven-Segment 
//
//=====================================================================================

logic [7:0] Seven_Seg_Val[5:0];
logic [3:0] Seven_Seg_Data[5:0];       
logic [23:0] actual_7seg_output;
reg [23:0] regd_actual_7seg_output;   

assign actual_7seg_output =  secret_key;

always @(posedge Clock_1kHz)
begin
    regd_actual_7seg_output <= actual_7seg_output;
end

assign Seven_Seg_Data[0] = regd_actual_7seg_output[3:0];
assign Seven_Seg_Data[1] = regd_actual_7seg_output[7:4];
assign Seven_Seg_Data[2] = regd_actual_7seg_output[11:8];
assign Seven_Seg_Data[3] = regd_actual_7seg_output[15:12];
assign Seven_Seg_Data[4] = regd_actual_7seg_output[19:16];
assign Seven_Seg_Data[5] = regd_actual_7seg_output[23:20];
      
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst0(.ssOut(Seven_Seg_Val[0]), .nIn(Seven_Seg_Data[0]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1(.ssOut(Seven_Seg_Val[1]), .nIn(Seven_Seg_Data[1]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2(.ssOut(Seven_Seg_Val[2]), .nIn(Seven_Seg_Data[2]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst3(.ssOut(Seven_Seg_Val[3]), .nIn(Seven_Seg_Data[3]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst4(.ssOut(Seven_Seg_Val[4]), .nIn(Seven_Seg_Data[4]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst5(.ssOut(Seven_Seg_Val[5]), .nIn(Seven_Seg_Data[5]));
   
assign HEX0 = Seven_Seg_Val[0];
assign HEX1 = Seven_Seg_Val[1];
assign HEX2 = Seven_Seg_Val[2];
assign HEX3 = Seven_Seg_Val[3];
assign HEX4 = Seven_Seg_Val[4];
assign HEX5 = Seven_Seg_Val[5];
            
endmodule
//=====================================================================================
//
// end of main 
//
//=====================================================================================
/*
module COUNTER(clk, up, down, rst, count); 
 
input up, down, rst, clk; 
output reg [7:0] count; 
reg [7:0] counterino = 8'd0; 
always_ff @(posedge clk)
begin
    if (rst)    begin counterino <= 8'd0; end                 //if rst count = 0
    else if (up) begin counterino <= counterino + 8'd1; end     //if up then count > 0
    else if (down) begin counterino <= counterino - 8'd1; end   //if down then count < 0
    else begin counterino <= counterino; end
end 
assign count = counterino; 
endmodule
*/
module COUNTER(clk, up, down, rst, count); 
 
input up, down, rst, clk; 
output reg [8:0] count; 
reg [8:0] counterino = 9'd0; 
always_ff @(posedge clk)
begin
    if (rst)    begin counterino <= 9'd0; end                 //if rst count = 0
    else if (up) begin counterino <= counterino + 9'd1; end     //if up then count > 0
    else if (down) begin counterino <= counterino - 9'd1; end   //if down then count < 0
    else begin counterino <= counterino; end
end 
assign count = counterino; 
endmodule

module COUNTER_2(clk, up, down, rst, count); 
 
input up, down, rst, clk; 
output reg [7:0] count; 
reg [7:0] counterino = 8'd0; 
always_ff @(posedge clk, posedge rst)
begin
    if (rst)    begin counterino <= 8'd0; end                 //if rst count = 0
    else if (up) begin counterino <= counterino + 8'd1; end     //if up then count > 0
    else if (down) begin counterino <= counterino - 8'd1; end   //if down then count < 0
    else begin counterino <= counterino; end
end 
assign count = counterino; 
endmodule
//=========================================================================================================================================
module LAB1V2(rst, clk, constant, clk_div); //clock divider code from LAB 1
parameter n= 32;
input clk;  
input rst;
input [n-1:0] constant; 
output reg clk_div = 0; 
reg [n-1:0] counterboy; 
	
always@(posedge clk) 
    begin 
	    if (rst == 1) begin counterboy <= 0; clk_div <= 0; end 
	    else          begin if (counterboy < constant -1) begin counterboy <= counterboy + 1; end 
                            else                          begin counterboy <= 0; clk_div <= ~clk_div; end end 
	end
endmodule
//=========================================================================================================================================
module datapath_task1(clk, q, wen, address, data, finito, commenco, restart);
input  logic        clk; 
input  logic [7:0]  q;
input  logic        commenco;
output logic        wen; 
output logic        finito; 
output logic [7:0]  address;
output logic [7:0]  data;
       logic [4:0]  state; 
       logic        reset_task1; 
       logic [8:0]  out_data; 
       logic        wen_reg; 
       logic [7:0]  address_reg;
       logic [7:0]  data_reg;
		 input logic restart;

parameter idle                             = 5'b0000_1; 
parameter fill_s                           = 5'b0010_1; 
parameter end_state                        = 5'b1000_0; 

always_ff@(posedge clk) 
begin 
	case(state) 
	idle: begin
				if (commenco) begin
					state <= fill_s;
				end else begin
					state <= idle;
				end
			end	
	fill_s: begin
				if (reset_task1 || restart) begin
					state <= end_state;
				end else begin
					state <= fill_s;
				end
			  end      
   end_state: begin
					if (restart) begin
						state <= idle;
					end else begin
						state <= end_state;
					end
				  end	
	default: state <= idle; 
	endcase 
end

always_ff@(posedge clk) 
    begin 
	    case(state) 
		 // idle:
	    //default:   begin  data_reg = out_data; address_reg = out_data; wen_reg = state[0];end 
		 default:   begin  data_reg = out_data[7:0]; address_reg = out_data[7:0]; wen_reg = state[0];end 
	    endcase 
    end 
//COUNTER task1_counter(.clk(clk), .up(1'b1), .down(1'b0), .rst(reset_task1), .count(out_data)); 
COUNTER task1_counter(.clk(clk), .up(1'b1), .down(1'b0), .rst(reset_task1 || restart), .count(out_data));
//assign reset_task1 = (out_data == 8'b11111111)? 1 : 0;
assign reset_task1 = (out_data == 9'b100000000)? 1 : 0;
assign data = data_reg; 
assign address = address_reg; 
assign wen = wen_reg; 
assign finito = state[4];
 
endmodule
//=========================================================================================================================================
module datapath_task2(address,q,data,wen,commenco,clk,finito,secret_key, restart);
input  logic [7:0]  q; 
input  logic        clk;
input  logic        commenco;
input  logic [23:0] secret_key;
output logic [7:0]  address; 
output logic [7:0]  data; 
output logic        wen;
output logic        finito; 
       logic [6:0]  state; 
       logic [7:0]  secret_key_p;
       logic        wen_reg;               //output registers
       logic [7:0]  address_reg;
       logic [7:0]  data_reg;
		 input logic restart;

parameter idle          = 7'b000000_0; 
parameter read_si       = 7'b000010_0; 
parameter wait_read_si  = 7'b000100_0;
parameter compute_j     = 7'b000110_0;
parameter read_sj       = 7'b001000_0;
parameter wait_read_sj  = 7'b001010_0;
parameter write_sj      = 7'b001100_0;
parameter write_si      = 7'b001110_0;
parameter done_or       = 7'b010001_0;
parameter done_all      = 7'b010010_1;
parameter donedone      = 7'b010100_1; 

logic [7:0] i_value, i_index; 
logic [7:0] j_value, j_index; 
logic [7:0] counter_boy; 

//COUNTER task2_counter(.clk(state[1]), .up(1'b1), .down(1'b0), .rst(1'b0), .count(counter_boy)); 
COUNTER_2 task2_counter(.clk(state[1]), .up(1'b1), .down(1'b0), .rst(restart), .count(counter_boy)); 
assign secret_key_p = (i_index % 3 == 1'b0)? secret_key[23:16] : ((i_index % 3 == 1'b1)? secret_key[15:8] : secret_key[7:0]); 

always_ff@(posedge clk) 
begin 
    case(state)
        idle:         state <= (commenco)?                read_si: idle;
        read_si:      state <=                            wait_read_si; 
        wait_read_si: state <=                            compute_j;
        compute_j:    state <=                            read_sj; 
        read_sj:      state <=                            wait_read_sj; 
        wait_read_sj: state <=                            write_sj; 
        write_sj:     state <=                            write_si;
        write_si:     state <=                            done_or;
        done_or:      state <= (counter_boy == 8'd256)?   done_all:read_si;
        done_all:     state <=                            donedone; 
        donedone:     state <= (restart)? 					 idle: donedone; 
        default:      state <=                            idle; 
    endcase 
end 
always_ff@(posedge clk) 
begin 
    case(state)
        idle:        begin  address_reg = 8'b0; wen_reg = 1'b0; data_reg = 8'bx; end
        read_si:     begin  address_reg = counter_boy; wen_reg = 1'b0; data_reg = 8'bx; i_index =counter_boy; end
        wait_read_si:begin  i_value <= q; end
        compute_j:   begin  j_index = (counter_boy == 8'b0)? i_value + secret_key_p: i_value + j_index + secret_key_p; end
        read_sj:     begin  address_reg = j_index; wen_reg = 1'b0; data_reg = 8'bx; end
        wait_read_sj:begin  j_value <= q;  end
        write_sj:    begin  address_reg = j_index; wen_reg = 1'b1; data_reg = i_value;end
        write_si:    begin  address_reg = i_index; wen_reg = 1'b1; data_reg = j_value;end
        done_or:     begin  wen_reg = 1'b0; end

        default:     begin  address_reg = address_reg; wen_reg = wen_reg; data_reg = data_reg; 
                            i_index = i_index; j_index = j_index; 
                            i_value = i_value; j_value = j_value; end
    endcase 
end 
assign finito = state[0];
assign address = address_reg; 
assign data = data_reg; 
assign wen = wen_reg; 
endmodule

//=========================================================================================================================================
module datapath_task2b(clk,address,address_e,address_d,q,q_e,data,data_d,wen,wen_d,commenco,finito, restart);

input  logic        clk;

output logic [7:0]  address; 
output logic [4:0]  address_d; 
output logic [4:0]  address_e;
input  logic [7:0]  q; 
input  logic [7:0]  q_e; 
output logic [7:0]  data; 
output logic [7:0]  data_d; 
output logic        wen;
output logic        wen_d;

input logic         restart;
input  logic        commenco;
output logic        finito; 

       logic [6:0]  state; 
/////////////////////////////////////////////////////////////////////might not need 
       logic [7:0]  address_reg;
       logic [4:0]  address_d_reg, address_e_reg;
       logic [7:0]  data_reg;
       logic [7:0]  data_d_reg;
       logic        wen_reg;               //output registers
       logic        wen_d_reg;             //output registers
/////////////////////////////////////////////////////////////////////
       logic [7:0] i_value; 
       logic [7:0] i_index; 
       logic [7:0] j_value; 
       logic [7:0] j_index; 
       logic [7:0] k_value; 
       logic [7:0] f_value; 

parameter idle                 = 7'b000000_0; 
parameter incrament_i          = 7'b000001_0; 
parameter read_si              = 7'b000010_0; 
parameter wait_read_si         = 7'b000100_0;
parameter update_j             = 7'b000110_0;
parameter read_sj              = 7'b001000_0;
parameter wait_read_sj         = 7'b001001_0;
parameter write_sj             = 7'b001010_0;
parameter write_si             = 7'b001011_0;
parameter make_f_read_sum      = 7'b001100_0;
parameter wait_read_sum        = 7'b001101_0;
parameter wait_read_encrypted  = 7'b001110_0;
parameter write_decrypted      = 7'b001111_0;
parameter read_encrypted       = 7'b010000_0;
parameter done                 = 7'b010001_1;
parameter count_k_state        = 7'b010010_0;
parameter inc_k_state          = 7'b110011_0;
logic [7:0] counter_boy; 
//COUNTER task2b_counter(.clk(state[6]), .up(1'b1), .down(1'b0), .rst(1'b0), .count(counter_boy)); 
COUNTER_2 task2b_counter(.clk(state[6]), .up(1'b1), .down(1'b0), .rst(restart), .count(counter_boy)); 

always_ff@(posedge clk) 
begin 
    case(state)
        idle:                state <= (commenco)? incrament_i: idle; 
        incrament_i:         state <= read_si; 
        read_si:             state <= wait_read_si; 
        wait_read_si:        state <= update_j; 
        update_j:            state <= read_sj; 
        read_sj:             state <= wait_read_sj;
        wait_read_sj:        state <= write_sj;
        write_sj:            state <= write_si;
        write_si:            state <= make_f_read_sum;
        make_f_read_sum:     state <= wait_read_sum;
        wait_read_sum:       state <= read_encrypted;
        read_encrypted:      state <= wait_read_encrypted;
        wait_read_encrypted: state <= write_decrypted;
        write_decrypted:     state <= count_k_state; 
        count_k_state:       state <= (counter_boy < 31)? inc_k_state : done; 
        inc_k_state:         state <= incrament_i; 
		  done:                state <= (restart)? idle: done; 
        default:             state <= idle; 
    endcase 
end 
always_ff@(posedge clk) 
begin 
    case(state)
        idle:                begin  address_reg = 8'b0; address_d_reg = 8'b0; address_e_reg = 8'b0; 
												wen_reg = 1'b0;     wen_d_reg = 1'b0;          
												data_reg = 8'b0;    data_d_reg = 8'b0;  
												i_index = 8'b0; j_index = 8'b0; 
												i_value = 8'b0; j_value = 8'b0; k_value = 8'b0; 
												f_value = 8'b0; end


        incrament_i:         begin  i_index = i_index + 8'b1 ;  end
        read_si:             begin  address_reg = i_index;   end
        wait_read_si:        begin  i_value <= q; end
        update_j:            begin  j_index = j_index + i_value; end
        read_sj:             begin  address_reg = j_index; end
        wait_read_sj:        begin  j_value <= q;  end
        write_sj:            begin                          data_reg = i_value; wen_reg = 1'b1;end
        write_si:            begin  address_reg = i_index;  data_reg = j_value;                end
        make_f_read_sum:     begin  address_reg = (i_value + j_value); wen_reg = 1'b0; end
        wait_read_sum:       begin  f_value <= q; end 
        read_encrypted:      begin  address_e_reg = counter_boy[4:0];  end         
        wait_read_encrypted: begin  k_value <= q_e; end
        write_decrypted:     begin  address_d_reg = counter_boy[4:0]; data_d_reg = k_value ^ f_value; wen_d_reg = 1'b1;  end
		  count_k_state:     begin  wen_d_reg = 1'b0; end

        default:   			 begin  address_reg = address_reg; address_d_reg = address_d_reg; address_e_reg = address_e_reg; 
											  wen_reg = wen_reg;         wen_d_reg = wen_d_reg;          
											  data_reg = data_reg;       data_d_reg = data_d_reg;  
											  i_index = i_index; j_index = j_index; 
											  i_value = i_value; j_value = j_value; k_value = k_value; 
											  f_value = f_value; end
    endcase 
end 
assign finito = state[0];
assign address = address_reg; 
assign data = data_reg; 
assign wen = wen_reg; 

assign address_d = address_d_reg; 
assign wen_d = wen_d_reg;
assign data_d = data_d_reg; 
assign address_e = address_e_reg; 
 
endmodule
