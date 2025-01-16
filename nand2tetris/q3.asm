(call$Hello.world)
// function Hello.world 4
// Set RAM[SP] .. RAM[SP + 3] to 0
@SP
A=M
M=0
A=A+1
M=0
A=A+1
M=0
A=A+1
M=0
// SP = SP + 4
@4
D=A
@SP
M=M+D
// push temp 0
// RAM[SP] = RAM[5]
@R5
D=M
@SP
A=M
M=D
//SP ++
@SP
M=M+1
// pop local 2
// RAM[local 2] = RAM[SP-1] 
@SP
A=M-1
D=M
@LCL
A=M+1
A=A+1
M=D
// SP--
@SP
M=M-1

