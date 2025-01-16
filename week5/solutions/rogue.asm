// Pixel values for an @:
// 00111100 = 60
// 01100110 = 102
// 01000010 = 66
// 01011010 = 90
// 01010110 = 86
// 01101010 = 86
// 01011010 = 90
// 01100010 = 98
// 00000110 = 6
// 01111100 = 124

// Load pixel values for an @ in the left half of a column into RAM[200]--RAM[209]
@60
D=A
@200
M=D
@102
D=A
@201
M=D
@66
D=A
@202
M=D
@90
D=A
@203
M=D
@86
D=A
@204
M=D
@86
D=A
@205
M=D
@90
D=A
@206
M=D
@98
D=A
@207
M=D
@6
D=A
@208
M=D
@124
D=A
@209
M=D

// Load pixel values for an @ in the right half of a column into RAM[210]--RAM[219]
@15360
D=A
@210
M=D
@26112
D=A
@211
M=D
@16896
D=A
@212
M=D
@23040
D=A
@213
M=D
@22016
D=A
@214
M=D
@22016
D=A
@215
M=D
@23040
D=A
@216
M=D
@25088
D=A
@217
M=D
@1536
D=A
@218
M=D
@31744
D=A
@219
M=D

// Zeroes RAM[220]--RAM[229]
@10
D=M
@i
M=0
// While i > 0:
(initloop)
	@i
	D=M
	@endinit
	D;JLE
	// RAM[220+i] <- 0
	@220
	A=D+A
	M=0
	@initloop
	0;JMP
(endinit)

// Keypress <- 0. We'll set keypress to 1 when we first detect a key press, then 0 when 
// no keypress is next detected. This allows us to respond to each keypress only once.
@keypress
M=0
// atloc <- SCREEN. Atloc will hold the memory address corresponding to the top-left corner of the
// @'s grid cell. For example, atloc = SCREEN corresponds to the @ being in the top-left corner 
// of the screen.
@SCREEN
D=A
@atloc
M=D
// If the at has changed position in the update loop, newatloc will hold the new position.
// Otherwise, we maintain newatloc = atloc.
@newatloc
M=D
// leftside <- 1. Each memory address holds pixels from two grid cells. leftside will be 1 if the @ 
// is located in the left of these two cells.
@leftside
M=1

// Colour the bottom three rows of the screen black, i.e. set addresses 0x5FA0--0x5FFF to all 1s.
@24480
D=A
@i
M=D
(botrowsloop)
	// Break if i = 0x6000
	@i
	D=M
	@KBD
	D=D-A
	@initdraw
	D;JEQ 
	
	// Colour pixels at RAM[i] black
	@i
	A=M
	M=-1
	
	// i++ and loop
	@i
	M=M+1
	@botrowsloop
	0;JMP

// Draw the @'s initial position
(initdraw)
@endinitdraw
D=A
@bookmark
M=D
@200
D=A
@atstart
M=D
@updatecell
0;JMP
(endinitdraw)

// Main update loop
(mainloop)
	// If no key is being pressed
	@KBD
	D=M
	@handlekey
	D;JGT
		// Update keypress and loop
		@keypress
		M=0
		@mainloop
		0;JMP
	(handlekey)

	// If a key is being pressed, but we handled it already in a prior iteration, ignore it.
	@keypress
	D=M
	@mainloop
	D;JGT

	// If a key is being pressed, but it's not an arrow key (KBD 130--133), ignore it.
	@KBD
	D=M
	@130
	D=D-A
	@mainloop
	D;JLT
	@3
	D=D-A
	@mainloop
	D;JGT

	// Otherwise, we have a keypress we need to handle. Update keypress <- 1.
	@keypress
	M=1
	
	// We must check for collision with the screen borders and calculate a new location newatloc 
	// for the @. We also update leftside. The logic for this depends on which key is being
	// pressed.

	// Currently D = 133 - KBD. Let's keep using this value rather than re-polling just in case the key has been released.
	// Check for case 1: Down is being pressed (KBD 133).
	@nodown
	D;JLT
		// Collision occurs if atloc >= 0x5E3F (i.e. 14 rows from the bottom). If it does, no action needed.
		@24127
		D=A
		@atloc
		D=D-M
		@mainloop
		D;JLE

		// Otherwise, leave leftside unchanged and set newatloc <- atloc + 352 (11 rows).
		@atloc
		D=M
		@352
		D=A+D
		@newatloc
		M=D
		@endkeycases
		0;JMP
		
	(nodown)
	// Check for case 2: Right is being pressed (KBD 132).
	D=D+1
	@noright
	D;JLT
		// Collision occurs if (atloc % 32 == 31) and leftside = 0. If it does, no action needed.
		@31
		D=A
		@atloc
		D=D&M
		@31
		D=D-A
		@endrightcollcheck
		D;JLT
		@leftside
		D=M
		@mainloop
		D;JEQ

		(endrightcollcheck)
		// Otherwise, if leftside = 1, set leftside <- 0.
		@leftside
		D=M
		@righthardcase
		D;JEQ
		@leftside
		M=0
		@endkeycases
		0;JMP

		(righthardcase)
		// Otherwise, set leftside <- 1 and newatloc <- atloc + 1.
		@leftside
		M=1
		@atloc
		D=M
		@newatloc
		M=D+1
		@endkeycases
		0;JMP

	(noright)
	// Check for case 3: Up is being pressed (KBD 131).
	D=D+1
	@noup
	D;JLT
		// Collision occurs if atloc <= 0x401F (top row). If it does, no action needed.
		@atloc
		D=M
		@16415
		D=D-A
		@mainloop
		D;JLE

		// Otherwise, leave leftside unchanged and set newatloc <- atloc - 352 (11 rows).
		@atloc
		D=M
		@352
		D=D-A
		@newatloc
		M=D
		@endkeycases
		0;JMP

	(noup)
	// We must therefore be in case 4: Left is being pressed (KBD 130). 
		// Collision occurs if (atloc % 32 == 0) and leftside=1. If it does, no action needed.
		@31
		D=A
		@atloc
		D=D&M // Now d = atloc % 32
		@endleftcollcheck
		D;JGT
		@leftside
		D=M
		@mainloop
		D;JGT
	
		(endleftcollcheck)
		// Otherwise, if leftside=0, set leftside <- 1.
		@leftside
		D=M
		@lefthardcase
		D;JGT
		@leftside
		M=1
		@endkeycases
		0;JMP

		// Otherwise, set leftside <- 0 and newatloc <- atloc - 1.
		(lefthardcase)
		@leftside
		M=0
		@atloc
		D=M-1
		@newatloc
		M=D

	(endkeycases)
	// We now have updated values for newatloc and leftside in all cases.

	// Clear the old @ sign from the screen (at atloc).
	@atcleared
	D=A
	@bookmark
	M=D
	@220
	D=A
	@atstart
	M=D
	@updatecell // This is a "function call" that will return to atcleared when it's done
	0;JMP

	(atcleared)
	// Update atloc <- newatloc
	@newatloc
	D=M
	@atloc
	M=D

	// Draw the new @ sign on the screen.
	@mainloop
	D=A
	@bookmark
	M=D
	// Set atstart <- 210 if leftside == 0 and atstart <- 200 otherwise
	@leftside
	D=M
	@drawatonright
	D;JEQ
	@200
	D=A
	@atstart
	M=D
	@endatstartchoice
	0;JMP
	(drawatonright)
	@210
	D=A
	@atstart
	M=D
	(endatstartchoice)
	@updatecell // This is a "function call" that will return to mainloop when it's done
	0;JMP

// Updates the 16x10 block on screen whose first (top-left) memory address is at @atloc. Does not alter @atloc.
// If @atstart = 200, draws an @ on the right side of the cell.
// If @atstart = 210, draws an @ on the left side of the cell.
// If @atstart = 220, makes the cell blank.
// Then jumps to the label stored in @bookmark.
(updatecell)
// atloctemp <- atloc
@atloc
D=M
@atloctemp
M=D
// i <- 0
@i
M=0
// While i <= 9:
(drawloop)
	@i
	D=M
	@9
	D=D-A
	@enddraw
	D;JGT
	// RAM[atloctemp] <- RAM[atstart + i], i.e. copy one row of desired "sprite" to screen
	@i
	D=M
	@atstart
	A=M+D
	D=M
	@atloctemp
	A=M
	M=D
	// atloctemp += 32 (i.e. move one row down on screen)
	@32
	D=A
	@atloctemp
	M=M+D
	// i++
	@i
	M=M+1
	@drawloop
	0;JMP
(enddraw)
// Jump to @bookmark
@bookmark
A=M
0;JMP