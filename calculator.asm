section .bss
    num1 resb 2
    num2 resb 2
    op resb 2
    result resb 4

section .text
    global _start

_start:
    ; Ask for first number
    mov rax, 1              ; sys_write
    mov rdi, 1
    mov rsi, msg1
    mov rdx, msg1_len
    syscall

    ; Read num1
    mov rax, 0              ; sys_read
    mov rdi, 0
    mov rsi, num1
    mov rdx, 2
    syscall

    ; Ask for second number
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, msg2_len
    syscall

    ; Read num2
    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 2
    syscall

    ; Ask for operation
    mov rax, 1
    mov rdi, 1
    mov rsi, msg3
    mov rdx, msg3_len
    syscall

    ; Read op
    mov rax, 0
    mov rdi, 0
    mov rsi, op
    mov rdx, 2
    syscall

    ; Convert num1 and num2 from ASCII to integer
    movzx rax, byte [num1]
    sub rax, '0'
    mov rbx, rax

    movzx rax, byte [num2]
    sub rax, '0'
    mov rcx, rax

    ; Perform operation
    mov al, [op]
    cmp al, '+'
    je do_add
    cmp al, '-'
    je do_sub
    cmp al, '*'
    je do_mul
    cmp al, '/'
    je do_div
    jmp done

do_add:
    add rbx, rcx
    jmp print_result

do_sub:
    sub rbx, rcx
    jmp print_result

do_mul:
    imul rbx, rcx
    jmp print_result

do_div:
    xor rdx, rdx
    div rcx
    jmp print_result

print_result:
    add rbx, '0'       ; convert to ASCII (works only for small results < 10)
    mov [result], bl

    ; Show "Result: "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg4
    mov rdx, msg4_len
    syscall

    ; Show result
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 1
    syscall

done:
    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

section .data
    msg1 db "Enter first number: ", 0
    msg1_len equ $ - msg1

    msg2 db "Enter second number: ", 0
    msg2_len equ $ - msg2

    msg3 db "Enter operation (+ - * /): ", 0
    msg3_len equ $ - msg3

    msg4 db 10, "Result: ", 0
    msg4_len equ $ - msg4
