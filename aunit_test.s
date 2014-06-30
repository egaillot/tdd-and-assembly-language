.include "aunit.s"
.data
  testSuite:
  .quad _test_canDetect2DifferentValues
  .quad _test_canDetect2EqualValues

  testLength: .quad . - testSuite

.text

  .global _main

  _test_canDetect2DifferentValues:
    push $2
    push $3
    call _assertEqual
    add $16, %rsp

    push %rax
    push $42
    call _assertEqual
    add $16, %rsp
    ret

  _test_canDetect2EqualValues:
    push $3
    push $3
    call _assertEqual
    add $16, %rsp

    push %rax
    push $0
    call _assertEqual
    add $16, %rsp
    ret

  _main:
    mov testLength@GOTPCREL(%rip), %rax
    mov (%rax), %rax
    shr $3, %rax

    push %rax
    push testSuite@GOTPCREL(%rip)
    call _runTestSuite
    add $16, %rsp

    mov %rax, %rdi
    mov $0x2000001, %rax
    syscall
