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
// Set l = wordsize
@16
D=A
@l 
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
    // shift every bit from bit 0;
    (operate)
    @tmp // use tmp&RAM[2] to get every bit
    M=1
    @j // use j to bit number being shifted
    M=0
    (shiftloopstart)
    @j
    M=M+1
    D=M 
    @l 
    D=D-M
    @shiftloopend
    D;JEQ 
        // shift every bit
        @tmp
        D=M 
        D=D+M
        @R2
        D=D&M
        @next_zero
        D;JEQ 
            // If next bit == 1, set this bit to 1
            (next_one)
            @tmp 
            D=M 
            @R2
            M=D|M
            @tmp_add
            0;JMP
            // If next bit == 0, set this bit to 0
            (next_zero)
            @tmp
            D=-M
            D=D-1
            @R2
            M=M&D
            @tmp_add
            0;JMP
        (tmp_add)
        @tmp
        D=M
        M=M+D
        @shiftloopstart
        0;JMP
    (shiftloopend)
    // set MSB to 0
    @32767
    D=A 
    @R2 
    M=M&D
    @loopstart
    0;JMP
(loopend)