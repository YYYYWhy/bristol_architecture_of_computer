// Set i to 0, which is the looptime
@i
M=0
// Set RAM[2] = 0, to store the result
@R2
M=0
(loopstart)
// If RAM[1] <= i, loop will end
@R1
D=M
@i
D=D-M
@loopend
D;JLE
// else add RAM[1] to RAM[2], i ++
	@R0
	D=M
	@R2
	M=M+D
	@i
	M=M+1
	@loopstart
	0;JMP
(loopend)
// Done
@loopend
0;JMP
