@R1
D=M
@R2
M=0
@counter
M=D



(MAIN_LOOP)
    @counter
    D=M
    @END
    D;JEQ

    @R2
    D=M
    @R0
    D=D+M
    @R2
    M=D

    @counter
    M=M-1
    @MAIN_LOOP
    0;JMP


(END)
0;JMP    