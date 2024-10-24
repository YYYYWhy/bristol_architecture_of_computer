// Set RAM[2] = RAM[0]
@R0
D=M
@R2
M=D
// store RAM[1] into i
@R1
D=M
@i 
M=D
// when i == 0, end the program
(loopstart)
@i 
D=M
@loopend 
D;JEQ
    // i --
    @i 
    M=M-1
    // RAM[2] = RAM[2] * 2
    (operate)
    @R2
    D=M
    M=M+D
    @loopstart
    0;JMP
(loopend)