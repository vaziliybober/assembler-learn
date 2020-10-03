format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        helloStr db 'Hello, world!', 0 ; db - define byte, 0 - ??

        NULL = 0 ; label become pointers at data

section '.code' code readable executable

        start:
                push helloStr ; add data to stack
                call [printf]

                call [getch]

                push NULL
                call [ExitProcess] ; return 0

section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch'