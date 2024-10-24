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
    // Store the MSB
    // if RAM[2] < 0, MSB = 1
    @R2
    D=M;
    @positive
    D;JGT
    @msb 
    M=1
    @operate
    0;JMP 
    // else MSB = 0
    (positive)
    @msb 
    M=0
    @operate 
    0;JMP 
    // RAM[2] = RAM[2] * 2 + MSB
    (operate)
    @R2
    D=M
    M=M+D
    @msb
    D=M 
    @R2 
    M=M+D 
    @loopstart
    0;JMP
(loopend)