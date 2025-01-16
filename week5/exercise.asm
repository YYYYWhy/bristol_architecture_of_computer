// set len = 2 * RAM[0]
@R0
D=M
@len
M=D
M=M+D
// cur_registor = SCREEN
// value_to_wirte = 1
@SCREEN
D=A
@cur_registor
M=D 
@value_to_wirte
M=1
@i 
M=0
//
// * for(int i = 0; i < len; i ++) Draw the i'th pixel.
(loopstart)
@i  
D=M
@len 
D=D-M
@loopend
D;JGE
    // RAM[cur_registor] = value_to_write
    @value_to_wirte
    D=M
    M=M+D
    @cur_registor
    A=M
    M=D 
    @32
    D=A
    // cur_registor *= 2
    @cur_registor
    M=M+D 
    // i += 1
    @i
    M=M+1
    // if(i%16 == 0), do something special
    @15
    D=A
    @i 
    D=M&D 
    @no_refresh
    D;JNE
        // cur_regstor += 1
        @cur_registor
        M=M+1
        // value_to_write = 1
        @value_to_wirte
        M=1
    (no_refresh)
    @loopstart
    0;JMP
(loopend)