.include "aunit.s"
.data
  testSuite:
    .quad _test_canDetectDifferentValues
    .quad _test_canDetectEqualValues
  testSuiteLength:
    .quad . - testSuite

.text

  .global _main

  _test_canDetectDifferentValues:
  push $67
  push $25
  call _assertEqual
  add $16, %rsp

  push %rax
  push $42
  call _assertEqual
  add $16, %rsp

  ret

  _test_canDetectEqualValues:
  push $25
  push $25
  call _assertEqual
  add $16, %rsp

  push %rax
  push $0
  call _assertEqual
  add $16, %rsp

  ret

  _main:
    mov testSuiteLength@GOTPCREL(%rip), %rax
    mov (%rax), %rax
    shr $3, %rax

    push %rax
    push testSuite@GOTPCREL(%rip)
    call _runTestSuite
    add $8, %rsp

    mov %rax, %rdi
    mov $0x2000001, %rax
    syscall
