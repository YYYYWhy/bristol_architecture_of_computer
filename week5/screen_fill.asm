// The whole programe runs in a big loop
(loopstart)
    @31
    D=A
    @w  // Use w to store the width of one row
    M=D
    @24576
    D=A
    @e  // Use e to store the total number of regitstors
    M=D
    // Check the state of 'c'
    @KBD
    D=M
    @99 // 99 is 'c'
    D=D-A
    @pressed
    D;JEQ
    // If 'c' is unpressed
        (unpressed)
        @21845
        D=A
        @a  //use a to store the value of the 1st registor
        M=D
        @fill
        0;JMP
    // If 'c' is pressed
        (pressed)
        @21845
        D=-A
        D=D-1
        @a
        M=D
        @fill
        0;JMP
    (fill)
    // When filling the screen, filling all the registors in
    // the same row with a.
    // When moving to the next line, negate a
    @SCREEN
    D=A 
    @p  //use p to store the present position
    M=D
        (fillcell)
        // fill the present cell
        @a 
        D=M
        @p 
        A=M 
        M=D
        // present address ++ 
        @p
        M=M+1
        D=M
        // if moved to the next row, negate a 
        @w
        D=D&M
        @stay
        D;JNE
        @a 
        M=-M
        M=M-1
        (stay)
        // If the next position is the end position, start a 
        // new loop.
        @p
        D=M 
        @e 
        D=D-M
        @loopstart 
        D;JEQ
        // fill next cell
        @fillcell
        0;JMP
(loopend)