extern ki_elojeles_egesz
extern be_elojeles_egesz
extern ki_logikai
global main
section .bss
i: resb 4
;sdgaga
s: resb 4
more: resb 1
section .text
main:
mov eax, 0
mov [s], eax
call be_elojeles_egesz
mov [more], eax
cikluseleje15:
mov eax, [more]
cmp al, 1
jne near ciklusvege15
call be_elojeles_egesz
mov [i], eax
mov eax, 100
push eax
mov eax, [i]
pop ebx
cmp eax, ebx
jb labelsmaller11
mov al, 0
jmp labelsmallerend11
labelsmaller11:
mov al, 1
labelsmallerend11:
push ax
mov eax, 10
push eax
mov eax, [i]
pop ebx
cmp eax, ebx
ja labelbigger11
mov al, 0
jmp labelbiggerend11
labelbigger11:
mov al, 1
labelbiggerend11:
pop bx
and al, bl
cmp al, 1
jne near labelegyagu13
mov eax, [i]
push eax
mov eax, [s]
pop ebx
add eax, ebx
mov [s], eax
labelegyagu13:
call be_elojeles_egesz
mov [more], eax
jmp cikluseleje15
ciklusvege15:
mov eax, [s]
push eax
call ki_elojeles_egesz
add esp, 4
ret