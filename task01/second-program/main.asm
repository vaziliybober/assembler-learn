; https://www.youtube.com/watch?v=V-97htBBtMI&list=PLH3y3SWteZd3Pwn81m_Z-iHp3imgkVUcs&index=3
; cycled the program
; added one more adress check
; for some reason wn output only works the first time. If i replace wn with ho,
; it works as expected

format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        formatStr db '%s', 0
        formatInt db '%d', 0

        name rd 4 ; 2 is for 8 symbols
        age rd NULL; reserve double

        wn db 'What is your name? ', 0
        ho db 'How old are you? ', 0
        hello db 'Hello, %s, %d', 0

        address db 10, 13, 'adress of hello str: %d', 0 ; 10, 13 is \n
        addressName db 10, 13, 'adress of name str: %d', 10, 13, 0 ; 10, 13 is \n

        NULL = 0


section '.code' code readable executable

        start:
                push ho ; push in stack
                call [printf]

                push name      ; second parameter
                push formatStr ; first parameter
                call [scanf]

                push ho
                call [printf]

                push age
                push formatInt
                call [scanf]

                push [age]        ; [] - adress of age
                push name
                push hello
                call [printf]

                lea eax, [hello] ; get hello adress and put in eax register
                push eax
                push address
                call [printf]

                lea eax, [name] ; get hello adress and put in eax register
                push eax
                push addressName
                call [printf]

                je start

section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'