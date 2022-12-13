section .data

SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60
EXIT_SUCCESS equ 0

STDIN equ 0
STDOUT equ 1

LF equ 10
NULL equ 0
INPUTLEN equ 10
newline db LF,NULL


initialmsg db "this program shows the addition, subtraction, multiplication and division operations result between two integer numbers.",LF,NULL

firstInputMsg db "enter a number: ", NULL

secondInputMsg db "enter other number: ", NULL

addMsg db "addition: ",NULL

subMsg db "subtraction: ",NULL

multiMsg db "multiplication: ",NULL

divMsg db "division: ",NULL

addAns dq 0
subAns dq 0
multiAns dq 0
divAns dq 0
section .bss
digitSpace resd 100
digitSpacePos resd 8
numInput1 resb 1
numInput2 resb 1
num1 resb INPUTLEN+2
num2 resb INPUTLEN+2

section .text
global _start
global _stringPrint
global _numberInput
global _stringToInt
global _digitPrint

_start:

mov rdi, initialmsg
call _stringPrint

mov rdi, firstInputMsg
call _stringPrint

mov rbx,num1
mov r12,0
lea rsi, byte[numInput1]
call _numberInput

mov rdi, secondInputMsg
call _stringPrint

mov rbx, num2
mov r12,0
lea rsi, byte[numInput2]
call _numberInput

;call _stringToInt


mov rdi, addMsg
call _stringPrint

;addition
mov rax,qword[num1]
add rax,qword[num2]
mov qword[addAns],rax
call _digitPrint

mov rdi, subMsg
call _stringPrint

;subtraction
mov rax,qword[num1]
sub rax,qword[num2]
mov qword[subAns],rax
call _digitPrint

mov rdi, multiMsg
call _stringPrint

;multiplication
mov rax,qword[num1]
mul qword[num2]
mov qword[multiAns],rax
mov qword[multiAns+8],rdx
call _digitPrint

mov rdi, divMsg
call _stringPrint

;division
mov rax,qword[num1]
cqo
div qword[num2]
mov qword[divAns],rax
call _digitPrint

mov rax, SYS_EXIT
mov rdi, EXIT_SUCCESS
syscall

;--------------- FUNCTIONS----------------
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

_numberInput:
readNumber:
mov rax, SYS_READ
mov rdi,STDIN
mov rdx,1
syscall

mov al,byte[rsi]
cmp al,LF
je readDone

inc r12
cmp r12,INPUTLEN
jae readNumber

mov byte[rbx],al
inc rbx
jmp readNumber
readDone:
ret

_digitPrint:
mov rcx,digitSpace
mov rbx,LF
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