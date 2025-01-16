// Waiting for keyboard input
@500  // cur_word start from 500
D=A
@cur_word
M=D

(start)
@cur_num  // cur_number is 0

(waiting)
@KBD
D=M
@128
D=D-A
@new_line // if '\n' is pressed, store
D;JEQ

@characters  // if 65<=c<=70, go to character(not complete)
@numbers // if 48<=c<=57, go to number(not complete)
@waiting  // continue waiting for input
0;JMP

(new_line) // store the number
@cur_num  //RAM[cur_word] = cur_num
D=M
@cur_word
A=M
M=D
@cur_word // cur_word ++
M=M+1

(characters)  //(not complete)

(numbers)  //(not complete)

@start  // back to start of the program
0;JMP
