; https://www.youtube.com/watch?v=gzDiLwIWcCY&list=PLH3y3SWteZd3Pwn81m_Z-iHp3imgkVUcs&index=4
; combine all operations
; add user input to each operarion

format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        askA db 'Enter a: ', 0
        askB db 'Enter b: ', 0
        strAdd db 'a + b: %d', 10, 13, 0
        strSub db 'a - b: %d', 10, 13, 0
        strMul db 'a * b: %d', 10, 13, 0
        strDiv db 'a / b: %d', 10, 13, 0
        resStr db 'Result: %d', 0
        A dd ?
        B dd ?
        C dd ?

        formatStr db '%s', 0
        formatInt db '%d', 0

        NULL = 0

section '.code' code readable executable

        start:
                push askA
                call [printf]

                push A
                push formatInt
                call [scanf]

                push askB
                call [printf]

                push B
                push formatInt
                call [scanf]

                        mov ecx, [A]
                        add ecx, [B]

                        push ecx
                        push strAdd
                        call [printf]

                push askA
                call [printf]

                push A
                push formatInt
                call [scanf]

                push askB
                call [printf]

                push B
                push formatInt
                call [scanf]

                        mov ecx, [A]
                        sub ecx, [B]

                        push ecx
                        push strSub
                        call [printf]

                push askA
                call [printf]

                push A
                push formatInt
                call [scanf]

                push askB
                call [printf]

                push B
                push formatInt
                call [scanf]

                        mov ecx, [A]
                        imul ecx, [B]

                        push ecx
                        push strMul
                        call [printf]

                push askA
                call [printf]

                push A
                push formatInt
                call [scanf]

                push askB
                call [printf]

                push B
                push formatInt
                call [scanf]

                        mov eax, [A]
                        mov ecx, [B]
                        mov edx, 0
                        div ecx

                        push eax
                        push strDiv
                        call [printf]


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