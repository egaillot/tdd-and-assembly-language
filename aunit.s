.data
  ok: .asciz "."
  ko: .asciz "X"

.text

  _assertEqual:
    mov 8(%rsp), %rax
    mov 16(%rsp), %rbx
    cmp %rax, %rbx
    jne differentValues

    equalValues:
      mov $0, %rax
      jmp end_assertEqual

    differentValues:
      mov $42, %rax

    end_assertEqual:
    ret


  _displayChar:
    mov $1, %rdi
    mov 8(%rsp), %rsi
    mov $1, %rdx
    mov $0x2000004, %rax
    syscall
    ret


  _runTestSuite:
    push %rbp
    mov %rsp, %rbp
    sub $16, %rsp

    mov $0, %rdi
    movq $0, -8(%rbp)
    movq $0, -16(%rbp)

    runNextTest:
      mov -16(%rbp), %rdi
      mov 16(%rbp), %rax
      call *(%rax, %rdi, 8)
      cmp $0, %rax
      jne fail

      success:
        push ok@GOTPCREL(%rip)
        call _displayChar
        add $8, %rsp
        jmp continue

      fail:
        push ko@GOTPCREL(%rip)
        call _displayChar
        add $8, %rsp
        movq $42, -8(%rbp)

      continue:
      addq $1, -16(%rbp)
      mov -16(%rbp), %rax
      cmp 24(%rbp), %rax
      jne runNextTest

    mov -8(%rbp), %rax
    mov %rbp, %rsp
    pop %rbp
    ret
