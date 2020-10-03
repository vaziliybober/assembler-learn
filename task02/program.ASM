; Bobrov Vasiliy 191
; Variant 6
; Elementov A, znachenie kotorih kratno vvedennomu chislu x

format PE console
entry start

include 'win32a.inc'


section '.data' data readable writable
        arr             rd 100
        resArr          rd 100
        N               dd 0
        M               dd 0
        i               dd ?
        j               dd ?
        arrI            dd ?
        x               dd ?
        resArrI         dd ?

        strAskArrSize   db 'Enter the size of the array: ', 0
        strScanInt      db '%d', 0
        strInvalidN     db 'Invalid N: %d', 10, 13, 0
        strEnterElem    db 'Enter %d) element: ', 0
        strOpenBrace    db '[ ', 0
        strCloseBrace   db ']', 10, 13, 0
        strPrintElem    db '%d, ', 0
        strEnterX       db 'Enter x: ', 0
        strInvalidX     db 'Invalid x: %d:', 10, 13, 0

        NULL = 0
        tempStack       dd ?



section '.code' code readable executable

start:
        call InputArray
        call OutputArray
        call FilterArray
        call OutputFilteredArray

finish:
        call [getch]
        push NULL
        call [ExitProcess]

InputArray:
        mov [tempStack], esp
        push strAskArrSize
        call [printf]

        push N
        push strScanInt
        call [scanf]

        mov eax, [N]
        cmp eax, 0
        jg NIsCorrect
        push [N]
        push strInvalidN
        call [printf]
        jmp finish

        NIsCorrect:
        mov [i], 0
        mov [arrI], arr

        EnterElem:
                mov ecx, [i]
                cmp ecx, [N]
                je EndInputArray

                push [i]
                push strEnterElem
                call [printf]

                push [arrI]
                push strScanInt
                call [scanf]

                inc [i]
                mov ecx, [arrI]
                add ecx, 4
                mov [arrI], ecx

                jmp EnterElem

EndInputArray:
        mov esp, [tempStack]
        ret

OutputArray:
        mov [tempStack], esp
        mov [i], 0
        mov [arrI], arr

        push strOpenBrace
        call [printf]

        PrintElem:
                mov ecx, [i]
                cmp ecx, [N]
                je EndOutputArray
                mov ecx, [arrI]
                push dword [ecx]
                push strPrintElem
                call [printf]

                inc [i]
                mov ecx, [arrI]
                add ecx, 4
                mov [arrI], ecx

                jmp PrintElem


EndOutputArray:
        push strCloseBrace
        call [printf]
        mov esp, [tempStack]
        ret

FilterArray:
        mov [tempStack], esp
        push strEnterX
        call [printf]

        push x
        push strScanInt
        call [scanf]

        mov eax, [x]
        cmp eax, 0
        jg XIsCorrect
        push [x]
        push strInvalidX
        call [printf]
        jmp finish

        XIsCorrect:
        mov [i], 0
        mov [j], 0
        mov [arrI], arr
        mov [resArrI], resArr

        Iter:
           mov ecx, [i]
           cmp ecx, [N]
           je EndFilterArray
           mov ecx, [arrI]
           mov eax, dword [ecx]
           cmp eax, 0
           jge NoAbs
           neg eax
           NoAbs:
           mov edx, 0
           idiv [x]

           cmp edx, 0
           jne DoNotInclude
           mov ecx, [arrI]
           mov eax, dword [ecx]
           mov edx, [j]
           mov [resArr + 4*edx], eax

           inc [j]

           DoNotInclude:
           inc [i]
           mov ecx, [arrI]
           add ecx, 4
           mov [arrI], ecx
           jmp Iter
EndFilterArray:
        mov esp, [tempStack]
        ret

OutputFilteredArray:
        mov [tempStack], esp
        mov [i], 0
        mov [resArrI], resArr

        push strOpenBrace
        call [printf]

        PrintElemFiltered:
                mov ecx, [i]
                cmp ecx, [j]
                je EndOutputFilteredArray
                mov ecx, [resArrI]
                push dword [ecx]
                push strPrintElem
                call [printf]

                inc [i]
                mov ecx, [resArrI]
                add ecx, 4
                mov [resArrI], ecx

                jmp PrintElemFiltered


EndOutputFilteredArray:
        push strCloseBrace
        call [printf]
        mov esp, [tempStack]
        ret








section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'