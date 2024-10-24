// Goal: Sum all the integers from 0 to RAM[0] and put
// the result in RAM[1].
//
// So if RAM[0] = 3, then RAM[1] should be 0+1+2+3 = 6.
// If RAM [0] = 5, then RAM [1] should be 15.

// Let i = 0.
@i
M=0
// Let RAM[1] = 0
@R1
M=0
(loopstart)
// If i - RAM[0] > 0 break out of loop
	// D <- i
	@i
	D=M
	// D <- D - RAM[0]
	@R0
	D=D-M
	// If D (= i - RAM[0]) > 0, break
	@loopend
	D;JGT
// Add i to RAM[1]
@i
D=M
@R1
M=D+M
// Add 1 to i
@i
M=M+1
// Go back to start of loop
@loopstart
0;JMP
(loopend)
// Done
@loopend
0;JMP
