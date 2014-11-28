.text

  _stringCompare:
    mov $0, %rdi
    mov 8(%rsp), %rax
    mov 16(%rsp), %rbx
    mov (%rax, %rdi, 1), %al
    mov (%rbx, %rdi, 1), %bl
    cmp %al, %bl
    jne differentChars

    sameChars:
      mov $0, %rax
      jmp end_stringCompare

    differentChars:
      mov $1, %rax

    end_stringCompare:
    ret


