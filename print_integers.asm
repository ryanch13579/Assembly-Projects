section .bss
    digitSpace resb 100
    digitSpacePos resb 8

section .text
    global _start

_start:
    mov rax, 123        ; Number to print
    call _printRAX

    ; Exit syscall
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; status 0
    syscall

_printRAX:
    mov rcx, digitSpace ; RCX = pointer to buffer
    mov [digitSpacePos], rcx

_printRAXLoop:
    xor rdx, rdx        ; Clear remainder
    mov rbx, 10
    div rbx             ; RAX / 10, remainder -> RDX

    add dl, '0'         ; Convert remainder to ASCII

    ; Save ASCII digit to buffer
    mov rcx, [digitSpacePos]
    mov [rcx], dl
    inc rcx
    mov [digitSpacePos], rcx

    cmp rax, 0
    jne _printRAXLoop

_printRAXLoop2:
    mov rcx, [digitSpacePos]
    dec rcx
    mov [digitSpacePos], rcx

    ; Print character
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; stdout
    mov rsi, rcx        ; buffer
    mov rdx, 1          ; write 1 byte
    syscall

    cmp rcx, digitSpace
    jg _printRAXLoop2   ; Print until start of buffer

    ret
