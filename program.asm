section .data

SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60
EXIT_SUCCESS equ 0

STDIN equ 0
STDOUT equ 1

LF equ 10
NULL equ 0
newline db LF,NULL


initialmsg db "this program shows the addition, subtraction, multiplication and division operations result between two integers",LF,NULL

plus db "+", NULL
minus db "-", NULL
multiplication db "*", NULL
division db "/", NULL
equal db "=", NULL

addMsg db "addition:",LF,NULL
subMsg db "subtraction:",LF,NULL
multiMsg db "multiplication:",LF,NULL
divMsg db "division:",LF,NULL

num1 dq 1235
num2 dq 568
addAns dq 0
subAns dq 0
multiAns dq 0
divAns dq 0

section .bss
digitSpace resd 100
digitSpacePos resd 8

section .text
global _start
global _stringPrint
global _digitPrint

_start:

mov rdi, initialmsg
call _stringPrint

mov rdi, newline
call _stringPrint

;################################################
;Math operations

;addition
mov rdi, addMsg
call _stringPrint
mov rax, qword[num1]
call _digitPrint
mov rdi, plus
call _stringPrint
mov rax, qword[num2]
call _digitPrint
mov rax,qword[num1]
add rax,qword[num2]
mov qword[addAns],rax
mov rdi, equal
call _stringPrint
mov rax, qword[addAns]
call _digitPrint

mov rdi, newline
call _stringPrint

;subtraction
mov rdi, subMsg
call _stringPrint
mov rax, qword[num1]
call _digitPrint
mov rdi, minus
call _stringPrint
mov rax, qword[num2]
call _digitPrint
mov rax,qword[num1]
sub rax,qword[num2]
mov qword[subAns],rax
mov rdi, equal
call _stringPrint
mov rax, qword[subAns]
call _digitPrint

mov rdi, newline
call _stringPrint

;multiplication
mov rdi, multiMsg
call _stringPrint
mov rax, qword[num1]
call _digitPrint
mov rdi, multiplication
call _stringPrint
mov rax, qword[num2]
call _digitPrint
mov rax,qword[num1]
imul qword[num2]
mov qword[multiAns],rax
mov qword[multiAns+8],rdx
mov rdi, equal
call _stringPrint 
mov rax, qword[multiAns]
call _digitPrint

mov rdi, newline
call _stringPrint

;division
mov rdi, divMsg
call _stringPrint
mov rax, qword[num1]
call _digitPrint
mov rdi, division
call _stringPrint
mov rax, qword[num2]
call _digitPrint
mov rax,qword[num1]
cqo
div qword[num2]
mov qword[divAns],rax
mov rdi, equal
call _stringPrint 
mov rax, qword[divAns]
call _digitPrint

;################################################
;Exit program

mov rax, SYS_EXIT
mov rdi, EXIT_SUCCESS
syscall

;-------------------FUNCTIONS--------------------
;################################################

_stringPrint:
push rbx

;****************************
;Count characters in string.

mov rbx,rdi
mov rdx, 0

strCountLoop:
cmp byte[rbx],NULL
je strCountDone
inc rdx
inc rbx
jmp strCountLoop

strCountDone:
cmp rdx,0
je prtDone

;****************************
;Call OS to output string.
mov eax, SYS_WRITE
mov rsi, rdi 
mov rdi, STDOUT 
syscall

prtDone:
pop rbx
ret

;################################################
_digitPrint:
mov rcx,digitSpace
mov [rcx],rbx
inc rcx
mov [digitSpacePos],rcx

_digitPrintLoop:
mov rdx, 0
mov rbx, 10
div rbx
push rax
add rdx,48

mov rcx, [digitSpacePos]
mov [rcx],dl
inc rcx
mov [digitSpacePos], rcx

pop rax
cmp rax,0
jne _digitPrintLoop

_digitPrintLoop2:
mov rcx,[digitSpacePos]

mov rax,SYS_WRITE
mov rdi,STDOUT
mov rsi,rcx
mov rdx,1
syscall

mov rcx, [digitSpacePos]
dec rcx
mov [digitSpacePos],rcx

cmp rcx,digitSpace
jge _digitPrintLoop2
ret