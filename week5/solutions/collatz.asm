// Initialise RAM[32] <- R0, curaddress <- 32.
@R0
D=M
@32
M=D
D=A
@curaddress
M=D

// While RAM[curaddress] != 1:
(mainloop)
@curaddress
A=M
D=M-1
@halt
D;JEQ
	// If RAM[curaddress] % 2 == 1:
	D=D+1
	@1
	D=D&A
	@curaddresseven
	D;JEQ
		// RAM[curaddress + 1] <- 3*RAM[curaddress] + 1
		@curaddress
		A=M
		D=M
		D=M+D
		D=M+D
		D=D+1
		@curaddress
		A=M+1
		M=D
		// curaddress++ and loop
		@curaddress
		M=M+1
		@mainloop
		0;JMP
	
	// Otherwise, RAM[curaddress] is even.
	// Calculate RAM[curaddress]/2 by shifting right one place, then store it in R2.
	(curaddresseven)
	@curaddress
	A=M
	D=M
	@R0
	M=D
	@R1
	M=1
		
	// This code is copy-pasted from rightshift.asm.
	// Right shifting by x is the same as right rotating by x and zeroing the first x bits. We first take a copy of R1 for safety.
	@R1
	D=M
	@copy
	M=D

	// Right rotating by x is the same as left-rotating by 16 - x. We should take x % 16 first to avoid negative numbers, though.
	// We can do that easily by ANDing with 0x000F.
	@15
	D=A
	@R1
	M=M&D
	D=D+1
	M=D-M

	@R0
	D=M
	@R2
	M=D
	(loop)
	// i << 0 = i
	@R1
	D=M
	@endrotate
	D;JEQ
	// Set lefthigh to 1 if the left bit of R2 is 1, or 0 otherwise.
	@16384
	D=A
	D=A+D
	@R2
	D=M&D
	@lefthighisone
	D;JNE
	@lefthigh
	M=0
	@endlefthigh
	0;JMP
	(lefthighisone)
	@lefthigh
	M=1
	(endlefthigh)
	// Replace R2 << R1 by 2*R2 << R1-1
	@R2
	AD=M
	AD=A+D
	@R2
	M=D
	@R1
	M=M-1
	// If lefthigh == 1, then the rightmost bit of R2 should now be 1, and otherwise it should stay 0.
	@lefthigh
	D=M
	@R2
	M=M+D
	@loop
	0;JMP

	// If copy >= 16, this means outputting zero.
	(endrotate)
	@copy
	D=M
	@16
	D=D-A
	@zeroout
	D;JGE

	// Otherwise, the easiest way is to AND R2 with 2^(16-copy) - 1. We first calculate 2^(16-copy) in total.
	@copy
	M=-D
	@total
	M=1
	(maskloop)
	@copy
	D=M
	@endmask
	D;JEQ
	@total
	D=M
	M=M+D
	@copy
	M=M-1
	@maskloop
	0;JMP

	// Now store R2 <- R2 & (total - 1) and end the shift.
	(endmask)
	@total
	D=M-1
	@R2
	M=M&D
	@endshift
	0;JMP

	(zeroout)
	@R2
	M=0

	// End copy-pasted code. Update RAM[curaddress + 1] <- RAM[curaddress]/2 (= R2).
	(endshift)
	@R2
	D=M
	@curaddress
	A=M+1
	M=D

	// curaddress++ and loop.
	@curaddress
	M=M+1
	@mainloop
	0;JMP
		
(halt)
@halt
0;JMP