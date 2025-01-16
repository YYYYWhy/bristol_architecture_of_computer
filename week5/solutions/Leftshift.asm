@R0
D=M
@R2
M=D
(LOOP)
// i << 0 = i
@R1
D=M
@halt
D;JEQ
// Replace R2 << R1 by 2*R2 << R1-1
@R2
AD=M
AD=A+D
@R2
M=D
@R1
M=M-1
@LOOP
0;JMP
(halt)
@halt
0;JMP