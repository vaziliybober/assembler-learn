; https://www.youtube.com/watch?v=ttS0tc1igpw&list=PLH3y3SWteZd3Pwn81m_Z-iHp3imgkVUcs&index=1
; only watched how cmp and jne works
; did the rest myself
; cycled the program

format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        strA db 'Enter A: ', 0
        strB db 'Enter B: ', 0
        strOp db 'Enter operation: ', 0

        resStr db 10, 13, 'Result: %d', 10, 13, 0
        resMod db '/%d', 0

        spaceStr db ' %d', 0
        emptyStr db '%d', 0

        infinity db 'infinity', 0
        point db '.', 0

        A dd ?
        B dd ?
        C dd ?

        NULL = 0

section '.code' code readable executable

        start:
                push strA
                call [printf]

                push A
                push spaceStr
                call [scanf]

                push strB
                call [printf]

                push B
                push spaceStr
                call [scanf]

                push strOp
                call [printf]

                call [getch] ; the symbol is stored in eax

                cmp eax, 43 ; 43 is int('+'). + -> 1. not + -> 0
                jne notAdd ; jump not equals -> jumps if 0 in the flag
                    mov ecx, [A]
                    add ecx, [B]
                    push ecx
                    push resStr
                    call [printf]
                    jmp start

                notAdd:
                cmp eax, 45 ; -
                jne notSub
                    mov ecx, [A]
                    sub ecx, [B]
                    push ecx
                    push resStr
                    call [printf]
                    jmp start

                notSub:
                cmp eax, 42 ; *
                jne notMul
                    mov ecx, [A]
                    imul ecx, [B]
                    push ecx
                    push resStr
                    call [printf]
                    jmp start

                notMul:
                cmp eax, 47 ; /
                jne notDiv

                     mov eax, [A]
                        mov ecx, [B]
                        mov edx, 0
                        div ecx

                        push eax
                        push resStr
                        call [printf]
                        jmp start
                notDiv:

        finish:
                call [getch]

                push NULL
                call [ExitProcess]






section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'