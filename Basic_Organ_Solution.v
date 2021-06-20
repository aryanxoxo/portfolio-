
module Basic_Organ_Solution(

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

    //////////// Audio //////////
    AUD_ADCDAT,
    AUD_ADCLRCK,
    AUD_BCLK,
    AUD_DACDAT,
    AUD_DACLRCK,
    AUD_XCK,

    //////////// I2C for Audio  //////////
    FPGA_I2C_SCLK,
    FPGA_I2C_SDAT,
    
    //////// GPIO //////////
    GPIO_0,
    GPIO_1,
    
);

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

//////////// Audio //////////
input                       AUD_ADCDAT;
inout                       AUD_ADCLRCK;
inout                       AUD_BCLK;
output                      AUD_DACDAT;
inout                       AUD_DACLRCK;
output                      AUD_XCK;

//////////// I2C for Audio  //////////
output                      FPGA_I2C_SCLK;
inout                       FPGA_I2C_SDAT;

//////////// GPIO //////////
inout           [35:0]      GPIO_0;
inout           [35:0]      GPIO_1;                             


//=======================================================
//  REG/WIRE declarations
//=======================================================
// Input and output declarations
logic CLK_50M;
logic  [7:0] LED;
assign CLK_50M =  CLOCK_50;



wire            [7:0]      LCD_DATA;
wire                       LCD_EN;
wire                       LCD_ON;
wire                       LCD_RS;
wire                       LCD_RW;

assign GPIO_0[7:0] = LCD_DATA;
assign GPIO_0[8] = LCD_EN;
assign GPIO_0[9] = LCD_ON;
assign GPIO_0[10] = LCD_RS;
assign GPIO_0[11] = LCD_RS;
assign GPIO_0[12] = LCD_RW;


//Character definitions

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


wire Clock_1KHz, Clock_1Hz;
wire Sample_Clk_Signal;
wire CLOCK, CLOCK_TO_VOICE,CLOCK_1HZ,CLOCK_1KKHZ;

//=======================================================================================================================
//
// Insert your code for Lab1 here!
//
//
///////////////////////////////////////////////////////////////////Audio Generation Signal       
reg [31:0] counterino; 
always@(*) begin 
case(SW[3:1])  
3'b000:counterino=32'd47801;// 130Hz * 4 Do1
3'b001:counterino=32'd42589;// 146Hz * 4 Re
3'b010:counterino=32'd37936;// 164Hz * 4 Mi
3'b011:counterino=32'd35816;// 174Hz * 4 Fa
3'b100:counterino=32'd31928;// 195Hz * 4 So
3'b101:counterino=32'd28409;// 220Hz * 4 La
3'b110:counterino=32'd25329;// 246Hz * 4 Ci
3'b111:counterino=32'd23900;// 261Hz * 4 Do2
default:counterino=32'd25000;// 1KHz
endcase 
end           
LAB1V2 #(32) instant(.rst(SW[0]),.clk(CLK_50M),.constant(counterino),.clk_div(CLOCK));
assign CLOCK_TO_VOICE=SW[0]?0:CLOCK;

//Audio Generation Signal
//Note that the audio needs signed data - so convert 1 bit to 8 bits signed
wire [7:0] audio_data = {(~CLOCK_TO_VOICE),{7{CLOCK_TO_VOICE}}}; //generate signed sample audio signal

///////////////////////////////////////////////////////////////////Generating LED STUFF 

LAB1V2 #(32) instant2(.rst(SW[7]),.clk(CLK_50M),.constant(32'h17d7840),.clk_div(CLOCK_1HZ)); //make 1hz clock
//always @(posedge CLOCK_1HZ) begin
//casex(THINKERIN[3:0])
//4'bxxx0:LED_WIRE=10'b0000000001;
//4'bxxx1:LED_WIRE=10'b1000000000;
//4'bxx10:LED_WIRE=10'b0000000100;
//4'bxx11:LED_WIRE=10'b0000001000;
//4'bx100:LED_WIRE=10'b0000010000;
//4'bx101:LED_WIRE=10'b0000100000;
//4'bx110:LED_WIRE=10'b0001000000;
//4'bx111:LED_WIRE=10'b0010000000;
//4'b1000:LED_WIRE=10'b0100000000;
//4'b1001:LED_WIRE=10'b0000000010;
//default:LED_WIRE=10'b1111111111; 
//32'dxxxx0:LEDR= 10'b0000000001;
//32'dxxxx1:LEDR= 10'b0000000010;
//32'dxxxx2:LEDR= 10'b0000000100;
//32'dxxxx3:LEDR= 10'b0000001000;
//32'dxxxx5:LEDR= 10'b0000010000;
//32'dxxxx6:LEDR= 10'b0000100000;
//32'dxxxx7:LEDR= 10'b0001000000;
//32'dxxxx8:LEDR= 10'b0010000000;
//32'dxxxx9:LEDR= 10'b0100000000;
//default  :LEDR= 10'b1111111111; 
//endcase
//nd

harmony_LED instant1213(.clock(CLOCK_1HZ), .LED_WIRE(LEDR));


////////////////////////////////////////////////////////////////////////SIGNAL TAP - Different TONES and signal waveform 
LAB1V2 #(32) instant3(.rst(0),.clk(CLK_50M),.constant(32'd25000),.clk_div(CLOCK_1KKHZ));
assign Sample_Clk_Signal = CLOCK_1KKHZ;

reg [31:0] tapino; 
always@(*) begin 
case(SW[3:1])  
3'b000:tapino={character_D,character_lowercase_o,character_1,character_space};// 130Hz * 4
3'b001:tapino={character_R,character_lowercase_e,character_space,character_space};// 146Hz * 4
3'b010:tapino={character_M,character_lowercase_i,character_space,character_space};// 164Hz * 4
3'b011:tapino={character_F,character_lowercase_a,character_space,character_space};// 174Hz * 4
3'b100:tapino={character_S,character_lowercase_o,character_space,character_space};// 195Hz * 4
3'b101:tapino={character_L,character_lowercase_a,character_space,character_space};// 220Hz * 4
3'b110:tapino={character_C,character_lowercase_i,character_space,character_space};// 246Hz * 4
3'b111:tapino={character_D,character_lowercase_o,character_2,character_space};// 261Hz * 4
default:tapino={character_A,character_A,character_A,character_A};// 143Hz * 4
endcase 
end         
///////////////////////////////////////////////////////////////////////// SHOWING SWITCHES ON SIGNAL TAP 
reg [23:0] tapino2; 
always@(*) begin 
case(SW[3:1])  
3'b000:tapino2={character_0,character_0,character_0};// 130Hz * 4
3'b001:tapino2={character_0,character_0,character_1};// 146Hz * 4
3'b010:tapino2={character_0,character_1,character_0};// 164Hz * 4
3'b011:tapino2={character_0,character_1,character_1};// 174Hz * 4
3'b100:tapino2={character_1,character_0,character_0};// 195Hz * 4
3'b101:tapino2={character_1,character_0,character_1};// 220Hz * 4
3'b110:tapino2={character_1,character_1,character_0};// 246Hz * 4
3'b111:tapino2={character_1,character_1,character_1};// 261Hz * 4
default:tapino2={character_A,character_A,character_A};// 143Hz * 4
endcase 
end         
                
//=====================================================================================
//
// LCD Scope Acquisition Circuitry Wire Definitions                 
//
//=====================================================================================

wire allow_run_LCD_scope;
wire [15:0] scope_channelA, scope_channelB;
(* keep = 1, preserve = 1 *) wire scope_clk;
reg user_scope_enable_trigger;
wire user_scope_enable;
wire user_scope_enable_trigger_path0, user_scope_enable_trigger_path1;
wire scope_enable_source = SW[8];
wire choose_LCD_or_SCOPE =  SW[9];


doublesync user_scope_enable_sync1(.indata(scope_enable_source),
                  .outdata(user_scope_enable),
                  .clk(CLK_50M),
                  .reset(1'b1)); 

//Generate the oscilloscope clock
Generate_Arbitrary_Divided_Clk32 
Generate_LCD_scope_Clk(
.inclk(CLK_50M),
.outclk(scope_clk),
.outclk_Not(),
.div_clk_count(scope_sampling_clock_count),
.Reset(1'h1));

//Scope capture channels

(* keep = 1, preserve = 1 *) logic ScopeChannelASignal;
(* keep = 1, preserve = 1 *) logic ScopeChannelBSignal;

assign ScopeChannelASignal = Sample_Clk_Signal; //// here you assign signal waveforms - CLK
assign ScopeChannelBSignal = CLOCK_TO_VOICE;

scope_capture LCD_scope_channelA(
.clk(scope_clk),
.the_signal(ScopeChannelASignal),
.capture_enable(allow_run_LCD_scope & user_scope_enable), 
.captured_data(scope_channelA),
.reset(1'b1));

scope_capture LCD_scope_channelB
(
.clk(scope_clk),
.the_signal(ScopeChannelBSignal),
.capture_enable(allow_run_LCD_scope & user_scope_enable), 
.captured_data(scope_channelB),
.reset(1'b1));

assign LCD_ON   = 1'b1;
//The LCD scope and display
LCD_Scope_Encapsulated_pacoblaze_wrapper LCD_LED_scope(
                        //LCD control signals
                          .lcd_d(LCD_DATA),//don't touch
                    .lcd_rs(LCD_RS), //don't touch
                    .lcd_rw(LCD_RW), //don't touch
                    .lcd_e(LCD_EN), //don't touch
                    .clk(CLK_50M),  //don't touch
                          
                        //LCD Display values
                     .InH(8'h00),
                     .InG(audio_data),
                     .InF(8'h00),
                     .InE(audio_data),
                     .InD(8'h00),
                     .InC(audio_data),
                     .InB(8'h00),
                     .InA(audio_data),
                          
                     //LCD display information signals
                         .InfoH({character_S,character_1}),
                          .InfoG({character_colon,tapino2[7:0]}),
                          .InfoF({character_space,character_S}),
                          .InfoE({character_2,character_colon}),
                          .InfoD({tapino2[15:8],character_space}),
                          .InfoC({character_S,character_3}),
                          .InfoB({character_colon,tapino2[23:16]}),
                          .InfoA({character_space,character_space}),
                          
                  //choose to display the values or the oscilloscope
                          .choose_scope_or_LCD(choose_LCD_or_SCOPE),
                          
                  //scope channel declarations
                          .scope_channelA(scope_channelA), //don't touch
                          .scope_channelB(scope_channelB), //don't touch
                          
                  //scope information generation
                          .ScopeInfoA({character_1,character_K,character_H,character_lowercase_z}),
                          .ScopeInfoB(tapino),
                          
                 //enable_scope is used to freeze the scope just before capturing 
                 //the waveform for display (otherwise the sampling would be unreliable)
                          .enable_scope(allow_run_LCD_scope) //don't touch
                          
    );  
    

//=====================================================================================
//
//  Seven-Segment and speed control
//
//=====================================================================================

wire speed_up_event, speed_down_event;

//Generate 1 KHz Clock
Generate_Arbitrary_Divided_Clk32 
Gen_1KHz_clk
(
.inclk(CLK_50M),
.outclk(Clock_1KHz),
.outclk_Not(),
.div_clk_count(32'h61A6), //change this if necessary to suit your module
.Reset(1'h1)); 

wire speed_up_raw;
wire speed_down_raw;

doublesync 
key0_doublsync
(.indata(!KEY[0]),
.outdata(speed_up_raw),
.clk(Clock_1KHz),
.reset(1'b1));


doublesync 
key1_doublsync
(.indata(!KEY[1]),
.outdata(speed_down_raw),
.clk(Clock_1KHz),
.reset(1'b1));


parameter num_updown_events_per_sec = 10;
parameter num_1KHZ_clocks_between_updown_events = 1000/num_updown_events_per_sec;

reg [15:0] updown_counter = 0;
always @(posedge Clock_1KHz)
begin
      if (updown_counter >= num_1KHZ_clocks_between_updown_events)
      begin
            if (speed_up_raw)
            begin
                  speed_up_event_trigger <= 1;          
            end 
            
            if (speed_down_raw)
            begin
                  speed_down_event_trigger <= 1;            
            end 
            updown_counter <= 0;
      end
      else 
      begin
           updown_counter <= updown_counter + 1;
           speed_up_event_trigger <=0;
           speed_down_event_trigger <= 0;
      end     
end

wire speed_up_event_trigger;
wire speed_down_event_trigger;

async_trap_and_reset_gen_1_pulse 
make_speedup_pulse
(
 .async_sig(speed_up_event_trigger), 
 .outclk(CLK_50M), 
 .out_sync_sig(speed_up_event), 
 .auto_reset(1'b1), 
 .reset(1'b1)
 );
 
async_trap_and_reset_gen_1_pulse 
make_speedown_pulse
(
 .async_sig(speed_down_event_trigger), 
 .outclk(CLK_50M), 
 .out_sync_sig(speed_down_event), 
 .auto_reset(1'b1), 
 .reset(1'b1)
 );


wire speed_reset_event; 

doublesync 
key2_doublsync
(.indata(!KEY[2]),
.outdata(speed_reset_event),
.clk(CLK_50M),
.reset(1'b1));

parameter oscilloscope_speed_step = 100;

wire [15:0] speed_control_val;                      
speed_reg_control 
speed_reg_control_inst
(
.clk(CLK_50M),
.up_event(speed_up_event),
.down_event(speed_down_event),
.reset_event(speed_reset_event),
.speed_control_val(speed_control_val)
);

logic [15:0] scope_sampling_clock_count;
parameter [15:0] default_scope_sampling_clock_count = 12499; //2KHz


always @ (posedge CLK_50M) 
begin
    scope_sampling_clock_count <= default_scope_sampling_clock_count+{{16{speed_control_val[15]}},speed_control_val};
end 

        
        
logic [7:0] Seven_Seg_Val[5:0];
logic [3:0] Seven_Seg_Data[5:0];
    
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

            
wire Clock_2Hz;
            
Generate_Arbitrary_Divided_Clk32 
Gen_2Hz_clk
(.inclk(CLK_50M),
.outclk(Clock_2Hz),
.outclk_Not(),
.div_clk_count(32'h17D7840 >> 1),
.Reset(1'h1)
); 
        
logic [23:0] actual_7seg_output;
reg [23:0] regd_actual_7seg_output;

always @(posedge Clock_2Hz)
begin
    regd_actual_7seg_output <= actual_7seg_output;
    Clock_1Hz <= ~Clock_1Hz;
end


assign Seven_Seg_Data[0] = regd_actual_7seg_output[3:0];
assign Seven_Seg_Data[1] = regd_actual_7seg_output[7:4];
assign Seven_Seg_Data[2] = regd_actual_7seg_output[11:8];
assign Seven_Seg_Data[3] = regd_actual_7seg_output[15:12];
assign Seven_Seg_Data[4] = regd_actual_7seg_output[19:16];
assign Seven_Seg_Data[5] = regd_actual_7seg_output[23:20];

    
assign actual_7seg_output =  scope_sampling_clock_count;




//=======================================================================================================================
//
//   Audio controller code - do not touch
//
//========================================================================================================================
wire [$size(audio_data)-1:0] actual_audio_data_left, actual_audio_data_right;
wire audio_left_clock, audio_right_clock;

to_slow_clk_interface 
interface_actual_audio_data_right
 (.indata(audio_data),
  .outdata(actual_audio_data_right),
  .inclk(CLK_50M),
  .outclk(audio_right_clock));
   
   
to_slow_clk_interface 
interface_actual_audio_data_left
 (.indata(audio_data),
  .outdata(actual_audio_data_left),
  .inclk(CLK_50M),
  .outclk(audio_left_clock));
   

audio_controller 
audio_control(
  // Clock Input (50 MHz)
  .iCLK_50(CLK_50M), // 50 MHz
  .iCLK_28(), // 27 MHz
  //  7-SEG Displays
  // I2C
  .I2C_SDAT(FPGA_I2C_SDAT), // I2C Data
  .oI2C_SCLK(FPGA_I2C_SCLK), // I2C Clock
  // Audio CODEC
  .AUD_ADCLRCK(AUD_ADCLRCK),                    //  Audio CODEC ADC LR Clock
  .iAUD_ADCDAT(AUD_ADCDAT),                 //  Audio CODEC ADC Data
  .AUD_DACLRCK(AUD_DACLRCK),                    //  Audio CODEC DAC LR Clock
  .oAUD_DACDAT(AUD_DACDAT),                 //  Audio CODEC DAC Data
  .AUD_BCLK(AUD_BCLK),                      //  Audio CODEC Bit-Stream Clock
  .oAUD_XCK(AUD_XCK),                       //  Audio CODEC Chip Clock
  .audio_outL({actual_audio_data_left,8'b1}), 
  .audio_outR({actual_audio_data_right,8'b1}),
  .audio_right_clock(audio_right_clock), 
  .audio_left_clock(audio_left_clock)
);

endmodule
//=======================================================================================================================
//
//   End Audio controller code
//
//========================================================================================================================


//COMPARE BLOCK TO BE USED IN MODULE LAB1V2
module EqComp(a,b,eq);  
parameter n = 8;
input [n-1:0] a, b ;
output eq; 

assign eq = (a==b);
endmodule 


//RESET & ENABLE FLIPFLOP TO BE USED IN MODULE LAB1V2
module flop(enb,rst,clk,in,out); //SIMPLE flipflop WITH SYNC RESET AND ENABLE
parameter  n = 8;
input clk, enb, rst; 
input [n-1:0] in; 
output reg [n-1:0] out;  
 
always@(posedge clk) begin 
if (rst) out <= 0; 
else if (enb) out <= in;
end
endmodule 


//COUNTER TO BE USED IN MODULE LAB1V2
module counter(clk,rst,count); //COUNTER
parameter n = 8; 
input rst, clk ; 
output [n-1:0] count;
wire [n-1:0] next = rst? 0 : count+1 ; 

FLIPFLOPBEACH #(n) counting_DFF(.clk(clk),.in(next), .out(count));
endmodule 


// SIMPLE FLIPFLOP 
module FLIPFLOPBEACH(clk,in,out); //
parameter  n = 8;
input clk;
input [n-1:0]  in; 
output reg [n-1:0] out;  
 
always@(posedge clk) begin 
     out <= in; 
end
endmodule 


///MAIN CLK DIVIDER CODE 
module LAB1V2(rst,clk,constant,clk_div);
parameter n = 8;  
input clk,rst;
input [n-1:0] constant; 
output clk_div;
wire [n-1:0] COUNT_TO_COMP;
wire COMP_TO_FLOP; 
wire main = COMP_TO_FLOP | rst; 

counter #(n)COUNTER1(.clk(clk),.rst(main),.count(COUNT_TO_COMP));
EqComp #(n)COMPARE(.a(constant),.b(COUNT_TO_COMP),.eq(COMP_TO_FLOP));
flop #(1)FLOPER(.enb(COMP_TO_FLOP),.rst(0),.clk(clk),.in(~clk_div),.out(clk_div));
endmodule


//LED SHIFTER CODE 
module harmony_LED(clock, LED_WIRE);
parameter n = 10; 
input clock;
output reg[n-1:0] LED_WIRE = 1;
reg ending = 0; 

always @(posedge clock)
begin
if (ending) begin
LED_WIRE=LED_WIRE>>1;if(LED_WIRE==10'b0000000001)ending=~ending;
end 
else begin 
LED_WIRE=LED_WIRE<<1;if(LED_WIRE==10'b1000000000)ending=~ending;
end 	
end
endmodule


