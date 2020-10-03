 format PE GUI 4.0

 entry start

 include 'c:\fasm\include\win32a.inc'
 include 'dwtoa.inc'
 
; -------------------------------------------------------------------------------------

 IDD_DIALOG  = 102
 IDC_EDT_1   = 1000
 IDC_EDT_2   = 1001
 IDC_EDT_3   = 1002
 IDC_BTN_ADD = 1005
 IDC_BTN_SUB = 1006
 IDC_BTN_MUL = 1007
 IDC_BTN_DIV = 1008
 IDC_BTN_CLR = 1009 
 AW_ACTIVATE equ 00020000h
 AW_CENTER   equ 00000010h
 AW_HIDE     equ 00010000h

 IDI_MAINICON equ 500
; -------------------------------------------------------------------------------------

 section '.code' code readable executable

  start:

  invoke GetModuleHandle,0
  invoke DialogBoxParam,eax,IDD_DIALOG,0,DialogProc,0

  exit:

  invoke  ExitProcess,0 

; -------------------------------------------------------------------------------------

proc DialogProc uses esi edi ebx,hwnddlg,msg,wparam,lparam



  cmp [msg],WM_INITDIALOG
  je .wminitdialog

  cmp [msg],WM_COMMAND
  je .wmcommand

  cmp [msg],WM_CLOSE
  je .wmclose

  xor eax,eax
  jmp .quit

.wminitdialog:
                
invoke LoadIcon,0,500
mov [hIcon],eax
invoke SendMessage,[hwnddlg],WM_SETICON,NULL,[hIcon]
invoke AnimateWindow,[hwnddlg],500,AW_ACTIVATE or AW_CENTER
invoke SetFocus,[hwnddlg]

invoke SendDlgItemMessage,[hwnddlg],1000,EM_LIMITTEXT,8,0
invoke SendDlgItemMessage,[hwnddlg],1001,EM_LIMITTEXT,8,0

   
jmp .done


.wmcommand:


cmp [wparam], BN_CLICKED shl 16 + IDC_BTN_ADD
je .ADD

cmp  [wparam], BN_CLICKED shl 16 + IDC_BTN_SUB
je .SUBTRACT

cmp  [wparam], BN_CLICKED shl 16 + IDC_BTN_MUL
je .MULTIPLY

cmp  [wparam], BN_CLICKED shl 16 + IDC_BTN_DIV
je .DIVIDE

cmp  [wparam], BN_CLICKED shl 16 + IDC_BTN_CLR
je .CLEAR
jmp .done

.ADD:
invoke GetDlgItemInt,[hwnddlg],1000,0,TRUE
mov ebx,eax
invoke GetDlgItemInt,[hwnddlg],1001,0,TRUE
add eax,ebx                      
invoke SetDlgItemInt,[hwnddlg],1002,eax,TRUE

jmp .done

.SUBTRACT:
invoke GetDlgItemInt,[hwnddlg],1000,0,TRUE
mov ebx,eax
invoke GetDlgItemInt,[hwnddlg],1001,0,TRUE
SUB ebx,eax                      
invoke SetDlgItemInt,[hwnddlg],1002,ebx,TRUE
jmp .done
.MULTIPLY: 

invoke GetDlgItemInt,[hwnddlg],1000,0,TRUE
mov ebx,eax
invoke GetDlgItemInt,[hwnddlg],1001,0,TRUE
mul ebx
cmp eax,200000000
jae .hatali
invoke SetDlgItemInt,[hwnddlg],1002,eax,TRUE
jmp .done 
.hatali:
invoke MessageBox,NULL,er,Caption,MB_OK+MB_ICONERROR
jmp .done

.DIVIDE:
xor edx,edx
invoke GetDlgItemInt,[hwnddlg],1000,0,TRUE
cmp eax,0
je .done
mov ebx,eax
invoke GetDlgItemInt,[hwnddlg],1001,0,TRUE
cmp eax,0
je .done

xchg ebx,eax
push ebx
div ebx
push edx
stdcall dwtoa,eax,buf1
pop edx

mov eax,edx
mov ebx,100
mul ebx
xor ebx,ebx
pop ebx
div ebx


stdcall dwtoa,eax,buf2
invoke lstrcat,buffer,buf1
invoke lstrcat,buffer,point
invoke lstrcat,buffer,buf2

invoke SetDlgItemText,[hwnddlg],1002,buffer
jmp .done


.CLEAR:
    invoke SetDlgItemText,[hwnddlg],IDC_EDT_1,clear
    invoke SetDlgItemText,[hwnddlg],IDC_EDT_2,clear
    invoke SetDlgItemText,[hwnddlg],IDC_EDT_3,clear

jmp .done

 .wmclose:
invoke AnimateWindow,[hwnddlg],500,AW_HIDE or AW_CENTER
                    invoke EndDialog,[hwnddlg],NULL

    invoke EndDialog,[hwnddlg],0





  .done:

    mov eax,1

  .quit:

  ret       

endp

; -------------------------------------------------------------------------------------

section '.idata' import data readable writeable

  library kernel,'KERNEL32.DLL',\
          user,'USER32.DLL'

  import kernel,\
         GetModuleHandle,'GetModuleHandleA',\
         lstrcat, 'lstrcat',\
         ExitProcess,'ExitProcess'

  import user,\
         DialogBoxParam,'DialogBoxParamA',\ 
         SetDlgItemText,'SetDlgItemTextA',\
         SendDlgItemMessage ,'SendDlgItemMessageW',\
         LoadIcon , 'LoadIconA',\
         SendMessage , 'SendMessageA',\
         AnimateWindow, 'AnimateWindow',\
         SetFocus , 'SetFocus',\
         GetDlgItemInt, 'GetDlgItemInt',\
         SetDlgItemInt, 'SetDlgItemInt',\
         wsprintf, 'wsprintfA',\
         MessageBox, 'MessageBoxA',\
         EndDialog,'EndDialog'

; -------------------------------------------------------------------------------------

section '.text' readable writeable

hIcon dd ?
remain dd ?
buffer db 50 dup(0)
buf1 db 20 dup (0)
buf2 db 20 dup (0)
point db ".",0
er db "Value is Long....",0
Caption db "ERROR",0
clear db "",0
; -------------------------------------------------------------------------------------

section '.rc' resource data readable



  directory  RT_DIALOG,dialogs,\
  RT_ICON, icons,\
  RT_GROUP_ICON, group_icons
  
  resource icons,\
  1,LANG_NEUTRAL,icon_data
  resource group_icons,\
  17,LANG_NEUTRAL,main_icon






  icon main_icon, icon_data, 'MAINICON.ICO'

  ;directory RT_DIALOG,dialogs

  resource dialogs,IDD_DIALOG,LANG_ENGLISH+SUBLANG_DEFAULT,main_dialog

  dialog main_dialog,\
  'FORCE',0,0,150,120,\
   0x80+0x0800+0x00020000+0x80000000+0x10000000+0x00C00000+0x00080000,0,0,0

  dialogitem 'BUTTON','FASM SIMPLE CALCULATOR ',-1,7,5,140,100,0x00000007+0x10000000,0
  dialogitem 'EDIT',"",IDC_EDT_1,12,18,48,11,0x00800000+0x2000+0x10000000+0x0002
  dialogitem 'EDIT',"",IDC_EDT_2,12,44,48,11,0x00800000+0x2000+0x10000000+0x0002
  dialogitem 'EDIT',"",IDC_EDT_3,12,70,48,11,0x00800000+0x2000+0x10000000+0x0002+0x0800
 
  dialogitem 'BUTTON',"+",IDC_BTN_ADD,72,25,16,12,0x00000000+0x10000000
  dialogitem 'BUTTON',"-",IDC_BTN_SUB,72,44,16,12,0x00000000+0x10000000
  dialogitem 'BUTTON','/',IDC_BTN_DIV,96,25,16,12,0x00000000+0x10000000
  dialogitem 'BUTTON',"X",IDC_BTN_MUL,96,44,16,12, 0x00000000+0x10000000
  dialogitem 'BUTTON',"CLEAR",IDC_BTN_CLR,80,64,26,12, 0x00000000+0x10000000


  enddialog
