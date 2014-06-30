.data
  ok: .asciz "."
  ko: .asciz "x"

.text

  _assertEqual:
    mov 8(%rsp), %rax
    mov 16(%rsp), %rbx
    cmp %rax, %rbx
    jne _different

    _equal:
      mov $0, %rax
      jmp _end_assertEqual

    _different:
      mov $42, %rax

    _end_assertEqual:
    ret

  _displayChar:
    mov $0x2000004, %rax
    mov $1, %rdi
    mov 8(%rsp), %rsi
    mov $1, %rdx
    syscall
    ret

  _runTestSuite:
    push %rbp
    mov %rsp, %rbp
    sub $16, %rsp

    movq $0, -8(%rbp)
    movq $0, -16(%rbp)

    _runNextTest:
      mov 16(%rbp), %rax
      mov -8(%rbp), %rdi
      call *(%rax, %rdi, 8)
      cmp $0, %rax
      jne _failure

      _success:
        push ok@GOTPCREL(%rip)
        call _displayChar
        add $8, %rsp
        jmp _continue

      _failure:
        push ko@GOTPCREL(%rip)
        call _displayChar
        add $8, %rsp
        movq $42, -16(%rbp)

      _continue:
        addq $1, -8(%rbp)
        mov 24(%rbp), %rbx
        cmpq %rbx, -8(%rbp)
        jne _runNextTest

    mov -16(%rbp), %rax
    mov %rbp, %rsp
    pop %rbp
    ret
