// for(row = 0; row < 256; row ++)
@SCREEN
D=A
@base_address
M=D  //base_address is used to store the first address of cur row
@row
M=0
(row_while_start)
@row
D=M
@256
D=A-D
@row_loop_end
D;JLE
   // for(col = 0; col <= row; col ++)
   @col
   M=0
   @ope // ope is used for bit wise or
   M=1
   @offset // offset is used to get the working word
   M=0
   (col_loop_start)
   @col
   D=M
   @row
   D=M-D
   @col_loop_end
   D;JLT
      // set piexl to 1
      @base_address
      D=M
      @offset
      D=D+M
      @cur_word
      M=D // cur word address is base_address+offset
      @ope
      D=M
      @cur_word
      A=M
      M=M|D // set.
      @ope
      D=M
      @next_word
      D;JLT
      @16384
      D=D-A
      @higest_bit
      D;JEQ
      (double) // else ope *= 2
      @ope
      D=M
      M=M+D
      @ope_end
      0;JMP
      (higest_bit) // if ope == 0100000000000000, ope = -32768
      @32767
      D=A
      @ope
      M=-D
      @ope_end
      0;JMP
      (next_word) // if ope < 0, ope = 1, offset ++
      @ope
      M=1
      @offset
      M=M+1
      @ope_end
      0;JMP
      (ope_end)
   @col
   M=M+1
   @col_loop_start
   0;JMP
   (col_loop_end)
@row
M=M+1
@32
D=A
@base_address
M=M+D   // base_address += 32
@row_while_start
0;JMP
(row_loop_end)
(halt)
@halt
0;JMP
