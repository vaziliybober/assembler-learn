proc dwtoa, dwValue, lpBuffer

pushad    
xor     ecx,ecx
mov     eax, [dwValue]
mov     edi, [lpBuffer]
mov     ebx,10 

count:
xor edx,edx
div ebx
add edx,30h
push edx
inc ecx
or eax,eax

jnz count

check:
pop  edx
mov [edi],edx
inc edi

loop check

popad
ret
   
endp