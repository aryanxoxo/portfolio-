// DetectWinner
// Detects whether either ain or bin has three in a row 
// Inputs:
//   ain, bin - (9-bit) current positions of type a and b
// Out:
//   win_line - (8-bit) if A/B wins, one hot indicates along which row, col or diag
//   win_line(0) = 1 means a win in row 8 7 6 (i.e., either ain or bin has all ones in this row)
//   win_line(1) = 1 means a win in row 5 4 3
//   win_line(2) = 1 means a win in row 2 1 0
//   win_line(3) = 1 means a win in col 8 5 2
//   win_line(4) = 1 means a win in col 7 4 1
//   win_line(5) = 1 means a win in col 6 3 0
//   win_line(6) = 1 means a win along the downward diagonal 8 4 0
//   win_line(7) = 1 means a win along the upward diagonal 2 4 6

module DetectWinner( input [8:0] ain, bin, output reg [7:0] win_line );
  
  parameter win = 3'b111; // set to clean-up expressions
  
  always @(*) begin // Primary logic for module, on any I/O change checks if a 3-in-a-row exists, if so, assigns 1-hot value to win-line

	win_line = 8'b0; // used to avoid latches(default value), if win_line == 8'b0 after always block, neither player has yet to win
  
	if ((ain[8:6] | bin[8:6]) == win) // Bottom row
		win_line[0] = 1'b1;
	else if ((ain[5:3] | bin[5:3]) == win) // Middle row
		win_line[1] = 1'b1;
	else if ((ain[2:0] | bin[2:0]) == win) // Top row
		win_line[2] = 1'b1;
	else if (({ain[8], ain[5], ain[2]} | {bin[8], bin[5], bin[2]}) == win) // Right column
		win_line[3] = 1'b1;
	else if (({ain[7], ain[4], ain[1]} | {bin[7], bin[4], bin[1]}) == win) // Middle column
		win_line[4] = 1'b1;
	else if (({ain[6], ain[3], ain[0]} | {bin[6], bin[3], bin[0]}) == win) // Left column
		win_line[5] = 1'b1;
	else if (({ain[8], ain[4], ain[0]} | {bin[8], bin[4], bin[0]}) == win) // Downward diag.
		win_line[6] = 1'b1;
	else if (({ain[2], ain[4], ain[6]} | {bin[2], bin[4], bin[6]}) == win) // Upward diag
		win_line[7] = 1'b1;	
  end
endmodule
