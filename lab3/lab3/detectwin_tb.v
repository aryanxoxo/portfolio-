// Testbench module, verifies DetectWinner() module outputs 
// correct win_line one-hot values (Total 21 cases tested)
module TestWin ;
	reg [8:0] x, o;
	wire [7:0] win_line;
	
	// Winning row combinations
	parameter top = 9'b000000111;
	parameter mid = 9'b000111000;
	parameter bot = 9'b111000000;
	
	// Winning column combinations
	parameter left = 9'b001001001;
	parameter centre = 9'b010010010;
	parameter right = 9'b100100100;
	
	// Winning diagonal combinations
	parameter downdiag = 9'b100010001;
	parameter updiag = 9'b001010100;
	
	parameter zero = 9'b0;
	
	
	DetectWinner dut(x, o, win_line);

	initial begin
		// Testing x/a victory(ies)
		o=zero;
		x = top;
		#5;
		$display("00000100: %b", win_line);
		
		x = mid;
		#5;
		$display("00000010: %b", win_line);
		
		x = bot;
		#5;
		$display("00000001: %b", win_line);
		
		x = left;
		#5;
		$display("00100000: %b", win_line);
		
		x = centre;
		#5;
		$display("00010000: %b", win_line);
		
		x = right;
		#5;
		$display("00001000: %b", win_line);
		
		x = downdiag;
		#5;
		$display("01000000: %b", win_line);
		
		x = updiag;
		#5;
		$display("10000000: %b", win_line);
		
		// Testing o/b victory(ies)
		x = zero;
		o = top;
		#5;
		$display("00000100: %b", win_line);
		
		o = mid;
		#5;
		$display("00000010: %b", win_line);
		
		o = bot;
		#5;
		$display("00000001: %b", win_line);
		
		o = left;
		#5;
		$display("00100000: %b", win_line);
		
		o = centre;
		#5;
		$display("00010000: %b", win_line);
		
		o = right;
		#5;
		$display("00001000: %b", win_line);
		
		o = downdiag;
		#5;
		$display("01000000: %b", win_line);
		
		o = updiag;
		#5;
		$display("10000000: %b", win_line);
		
		// Testing values where an o/b has yet to win
		o = zero;
		x = zero;
		
		repeat (5) begin
			o = o + 1;
			#5;
			$display("%b", win_line);
		end
		
		$stop;
	end
endmodule
