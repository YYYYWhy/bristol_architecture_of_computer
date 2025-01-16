// Right shifting by x is the same as right rotating by x and zeroing the first x bits. We first take a copy of R1 for safety.
@R1
D=M
@copy
M=D

// The following code is copy-pasted from rightrotate.asm.
// Right rotating by x is the same as left-rotating by 16 - x. We should take x % 16 first to avoid negative numbers, though.
// We can do that easily by ANDing with 0x000F.
@15
D=A
@R1
M=M&D
D=D+1
M=D-M

// This code is copy-pasted from leftrotate.asm.
@R0
D=M
@R2
M=D
(loop)
// i << 0 = i
@R1
D=M
@endrotate
D;JEQ
// Set lefthigh to 1 if the left bit of R2 is 1, or 0 otherwise.
@16384
D=A
D=A+D
@R2
D=M&D
@lefthighisone
D;JNE
@lefthigh
M=0
@endlefthigh
0;JMP
(lefthighisone)
@lefthigh
M=1
(endlefthigh)
// Replace R2 << R1 by 2*R2 << R1-1
@R2
AD=M
AD=A+D
@R2
M=D
@R1
M=M-1
// If lefthigh == 1, then the rightmost bit of R2 should now be 1, and otherwise it should stay 0.
@lefthigh
D=M
@R2
M=M+D
@loop
0;JMP

// Copy-pasted part ends. We now zero the leftmost [copy] bits.
// If copy >= 16, this means outputting zero.
(endrotate)
@copy
D=M
@16
D=D-A
@zeroout
D;JGE

// Otherwise, the easiest way is to AND R2 with 2^(16-copy) - 1. We first calculate 2^(16-copy) in total.
@copy
M=-D
@total
M=1
(maskloop)
@copy
D=M
@endmask
D;JEQ
@total
D=M
M=M+D
@copy
M=M-1
@maskloop
0;JMP

// Now store R2 <- R2 & (total - 1) and halt.
(endmask)
@total
D=M-1
@R2
M=M&D
@halt
0;JMP

(zeroout)
@R2
M=0
(halt)
@halt
0;JMP