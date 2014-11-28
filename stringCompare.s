.text

  _stringCompare:
    mov $0, %rdi
    compareNextChar:
      mov 8(%rsp), %rax
      mov 16(%rsp), %rbx
      mov (%rax, %rdi, 1), %al
      mov (%rbx, %rdi, 1), %bl
      add $1, %rdi
      cmp %al, %bl
      jne differentChars

      sameChars:
        cmp $0, %al
        jne compareNextChar

        mov $0, %rax
        jmp end_stringCompare

      differentChars:
        cmp %al, %bl
        jg secondCharGreater

        firstCharGreater:
          mov $-1, %rax
          jmp end_stringCompare

        secondCharGreater:
          mov $1, %rax

    end_stringCompare:
    ret


