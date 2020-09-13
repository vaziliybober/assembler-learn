; https://www.youtube.com/watch?v=kdlgm4m4Tpw&list=PLH3y3SWteZd3Pwn81m_Z-iHp3imgkVUcs&index=5
; combine all operations in one program
; ask user input
; al register requires db type

format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        askA db 'Enter a: ', 0
        askB db 'Enter b: ', 0
        strShl db 'a shl 1: %d', 10, 13, 0
        strShr db 'a shr 1: %d', 10, 13, 0
        strRol db 'a rol 1: %d', 10, 13, 0
        strRor db 'a ror 1: %d', 10, 13, 0
        resStr db 'Result: %d', 0
        A dd ?
        B db ?
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

                        mov ecx, [A]
                        shl ecx, 1

                        push ecx
                        push strShl
                        call [printf]


                push askA
                call [printf]

                push A
                push formatInt
                call [scanf]

                        mov ecx, [A]
                        shr ecx, 1

                        push ecx
                        push strShr
                        call [printf]


                push askA
                call [printf]

                push B
                push formatInt
                call [scanf]

                        xor eax, eax ; one way of clearing a register
                        mov al, [B]
                        rol al, 1

                        push eax
                        push strRol
                        call [printf]

                push askA
                call [printf]

                push B
                push formatInt
                call [scanf]

                        xor eax, eax ; one way of clearing a register
                        mov al, [B]
                        ror al, 1

                        push eax
                        push strRor
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