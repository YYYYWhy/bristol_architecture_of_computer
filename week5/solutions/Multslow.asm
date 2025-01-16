// RAM[2] <- 0
@R2
M=0
// While RAM[0] > 0
(loopstart)
	// Ensure RAM[0] > 0
	@R0
	D=M
	@end
	D;JLE
	// RAM[2] += RAM[1]
	@R1
	D=M
	@R2
	M=M+D
	// RAM[1]--
	@R0
	M=M-1
	// Loop
	@loopstart
	0;JMP
// Halt
(end)
@end
0;JMP