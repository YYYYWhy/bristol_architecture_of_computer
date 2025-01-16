// Bitmask = 1, RAM[2] = 0
@bitmask
M=1
@R2
M=0
// While RAM[1] > 0:
(loopstart)
	// Check RAM[1] > 0
	@R1
	D=M
	@end
	D;JLE
	// If (Bitmask & RAM[1] != 0)
		@bitmask
		D=M
		@R1
		D=D&M
		@endif
		D;JEQ
		// RAM[2] += RAM[0]
		@R0
		D=M
		@R2
		M=M+D
		// RAM[1] -= bitmask
		@bitmask
		D=M
		@R1
		M=M-D
	(endif)
	// Bitmask *= 2
	@bitmask
	D=M
	M=M+D
	// RAM[0] *= 2
	@R0
	D=M
	M=M+D
	// Loop
	@loopstart
	0;JMP
// Halt
(end)
@end
0;JMP