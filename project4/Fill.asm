// Init screen
@SCREEN
D=A
@screenCursor
M=D

(MAIN_LOOP)
    @KBD
    D=M
    
    @FILLIN_WHITE
    D;JEQ

    @FILLIN_BLACK
    0;JMP


(FILLIN_BLACK)
    @SCREEN
    D=A
    @screenCursor
    M=D

    (BLACK_LOOP)
        @screenCursor
        D=M
        @24576
        D=D-A
        @MAIN_LOOP
        D;JEQ
        
        @screenCursor
        A=M
        M=-1
        
        @screenCursor
        M=M+1
        
        @BLACK_LOOP
        0;JMP



(FILLIN_WHITE)
    @SCREEN
    D=A
    @screenCursor
    M=D

    (WHITE_LOOP)
        @screenCursor
        D=M
        @24576
        D=D-A
        @MAIN_LOOP
        D;JEQ
        
        @screenCursor
        A=M
        M=0
        
        @screenCursor
        M=M+1
        
        @WHITE_LOOP
        0;JMP
    
