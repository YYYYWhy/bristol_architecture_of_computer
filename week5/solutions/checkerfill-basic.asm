@cactive
M=0

// Infinite loop
(bigloop)
@rowparity
M=0
@row
M=0
@SCREEN
D=A
@screenloc
M=D

	// For all 0 <= row <= 255:
	(rowloop)
	@row
	D=M
	@256
	D=D-A
	@bigloop
	D;JEQ
	
	// For all 0 <= col <= 31:
	@col
	M=0
	(colloop)
		@32
		D=A
		@col
		D=D-M
		@endcolloop
		D;JEQ

		// If c is being pressed, update cactive <- 1. Otherwise, update cactive <- 0.
		@KBD
		D=M
		@67
		D=D-A
		@cispressed
		D;JEQ
		@cactive
		M=0
		@endchandle
		0;JMP
		(cispressed)
		@cactive
		M=1

		// Set colour to 0xAAAA (white pixel first) if rowparity + cactive is 1. Otherwise, set colour to 0x5555 (black pixel first).
		(endchandle)
		@rowparity
		D=M
		@cactive
		D=M+D
		D=D-1
		@white
		D;JEQ
		@21845 // 0x5555
		D=A
		@colour
		M=D
		@endcolour
		0;JMP
		(white)
		@16384 // 0x4000
		D=A
		D=A+D
		@10922 // 0x2AAA
		D = A+D // 0x8000 + 0x2AAA = 0xAAAA
		@colour
		M=D
		
		// Write RAM[screenloc+col] <- colour
		(endcolour)
		@screenloc
		D=M
		@col
		D=M+D
		@exactscreenloc
		M=D
		@colour
		D=M
		@exactscreenloc
		A=M
		M=D

		// col++ and loop
		@col
		M=M+1
		@colloop
		0;JMP
	
	// screenloc += 32, rowparity <- 1 - rowparity, row++, and loop.
	(endcolloop)
	@32
	D=A
	@screenloc
	M=M+D
	D=1
	@rowparity
	M=D-M
	@row
	M=M+1
	@rowloop
	0;JMP