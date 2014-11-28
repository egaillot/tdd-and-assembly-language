.include "aunit.s"
.include "stringCompare.s"

.data
  emptyString1: .asciz ""
  emptyString2: .asciz ""
  a: .asciz "a"
  aa: .asciz "aa"
  ab: .asciz "ab"

  testSuite:
    .quad _test_twoEmptyStrings
    .quad _test_secondStringNotEmpty
    .quad _test_firstStringNotEmpty
    .quad _test_twoNonEmptyStrings

  testSuiteLength:
    .quad . - testSuite

.text
  .global _main

  .macro _test_stringCompare
    push $2@GOTPCREL(%rip)
    push $1@GOTPCREL(%rip)
    call _stringCompare
    pop %rbx
    pop %rbx

    push %rax
    push $0
    call _assertEqual
    pop %rbx
    pop %rbx
  .endmacro


  _test_twoEmptyStrings:
    _test_stringCompare $0, emptyString1, emptyString2
    ret

  _test_secondStringNotEmpty:
    _test_stringCompare $1, emptyString1, a
    ret

  _test_firstStringNotEmpty:
    _test_stringCompare $-1, a, emptyString2
    ret

  _test_twoNonEmptyStrings:
    _test_stringCompare $1, aa, ab
    ret

  _main:
    mov testSuiteLength@GOTPCREL(%rip), %rax
    mov (%rax), %rax
    shr $3, %rax

    push %rax
    push testSuite@GOTPCREL(%rip)
    call _runTestSuite
    add $16, %rsp

    mov %rax, %rdi
    mov $0x2000001, %rax
    syscall

