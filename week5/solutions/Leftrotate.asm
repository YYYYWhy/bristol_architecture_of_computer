@R0
D=M
@R2
M=D
(loop)
// i << 0 = i
@R1
D=M
@halt
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
(halt)
@halt
0;JMP