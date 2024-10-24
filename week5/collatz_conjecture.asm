// pre_pos = 32
@32 
D=A
@pre_pos
M=D 
// RAM[32] = RAM[0]
@R0
D=M 
@pre_pos
A=M 
M=D 
(loopstart)
// if RAM[pre_pos] == 1, end loop
@pre_pos
A=M 
D=M-1
@loopend 
D;JEQ 
    // tmp = ram[pre_pos]
    @pre_pos 
    A=M
    D=M 
    @tmp 
    M=D 
    // pre_pos ++
    @pre_pos
    M=M+1
    // if tmp % 2 != 0, ram[pre_pos] = tmp * 3 + 1
    @tmp 
    D=1
    D=M&D 
    @even
    D;JEQ
        (odd)
        @tmp
        D=M 
        @pre_pos 
        A=M
        M=D 
        M=M+D 
        M=M+D 
        M=M+1 
        @loopstart
        0;JMP
        // else ram[pre_pos] = tmp / 2 
        (even)
        @tmp
        D=M 
        @pre_pos 
        A=M 
        M=D 
        @result
        M=0 
        (divide_by_2)
        @get_result
        D;JEQ 
        D=D-1 
        D=D-1
        @result 
        M=M+1
        @divide_by_2
        0;JMP
        (get_result)
        @result 
        D=M 
        @pre_pos 
        A=M 
        M=D 
        @loopstart 
        0;JMP
(loopend)
