; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=-popcnt | FileCheck %s --check-prefixes=X86,X86-NOPOPCNT
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=-popcnt | FileCheck %s --check-prefixes=X64,X64-NOPOPCNT
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+popcnt | FileCheck %s --check-prefixes=X86,X86-POPCNT
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+popcnt | FileCheck %s --check-prefixes=X64,X64-POPCNT

define i4 @parity_4(i4 %x) {
; X86-LABEL: parity_4:
; X86:       # %bb.0:
; X86-NEXT:    testb $15, {{[0-9]+}}(%esp)
; X86-NEXT:    setnp %al
; X86-NEXT:    retl
;
; X64-LABEL: parity_4:
; X64:       # %bb.0:
; X64-NEXT:    testb $15, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    retq
  %1 = tail call i4 @llvm.ctpop.i4(i4 %x)
  %2 = and i4 %1, 1
  ret i4 %2
}

define i8 @parity_8(i8 %x) {
; X86-LABEL: parity_8:
; X86:       # %bb.0:
; X86-NEXT:    cmpb $0, {{[0-9]+}}(%esp)
; X86-NEXT:    setnp %al
; X86-NEXT:    retl
;
; X64-LABEL: parity_8:
; X64:       # %bb.0:
; X64-NEXT:    testb %dil, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    retq
  %1 = tail call i8 @llvm.ctpop.i8(i8 %x)
  %2 = and i8 %1, 1
  ret i8 %2
}

define i16 @parity_16(i16 %x) {
; X86-NOPOPCNT-LABEL: parity_16:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_16:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movl %edi, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %ch, %cl
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_16:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    popcntl %eax, %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_16:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    movzwl %di, %eax
; X64-POPCNT-NEXT:    popcntl %eax, %eax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-POPCNT-NEXT:    retq
  %1 = tail call i16 @llvm.ctpop.i16(i16 %x)
  %2 = and i16 %1, 1
  ret i16 %2
}

define i16 @parity_16_load(i16* %x) {
; X86-NOPOPCNT-LABEL: parity_16_load:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movzwl (%eax), %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_16_load:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movzwl (%rdi), %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %ch, %cl
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_16_load:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    movzwl (%eax), %eax
; X86-POPCNT-NEXT:    popcntl %eax, %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_16_load:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    movzwl (%rdi), %eax
; X64-POPCNT-NEXT:    popcntl %eax, %eax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-POPCNT-NEXT:    retq
  %1 = load i16, i16* %x
  %2 = tail call i16 @llvm.ctpop.i16(i16 %1)
  %3 = and i16 %2, 1
  ret i16 %3
}

define i17 @parity_17(i17 %x) {
; X86-NOPOPCNT-LABEL: parity_17:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NOPOPCNT-NEXT:    movl %ecx, %eax
; X86-NOPOPCNT-NEXT:    andl $131071, %eax # imm = 0x1FFFF
; X86-NOPOPCNT-NEXT:    movl %eax, %edx
; X86-NOPOPCNT-NEXT:    shrl $16, %edx
; X86-NOPOPCNT-NEXT:    xorl %eax, %edx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %dl, %ch
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_17:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movl %edi, %eax
; X64-NOPOPCNT-NEXT:    andl $131071, %eax # imm = 0x1FFFF
; X64-NOPOPCNT-NEXT:    movl %eax, %ecx
; X64-NOPOPCNT-NEXT:    shrl $16, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X64-NOPOPCNT-NEXT:    shrl $8, %edi
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %cl, %dil
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_17:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    movl $131071, %eax # imm = 0x1FFFF
; X86-POPCNT-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    popcntl %eax, %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_17:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    andl $131071, %edi # imm = 0x1FFFF
; X64-POPCNT-NEXT:    popcntl %edi, %eax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    retq
  %1 = tail call i17 @llvm.ctpop.i17(i17 %x)
  %2 = and i17 %1, 1
  ret i17 %2
}

define i32 @parity_32(i32 %x) {
; X86-NOPOPCNT-LABEL: parity_32:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    shrl $16, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_32:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movl %edi, %ecx
; X64-NOPOPCNT-NEXT:    shrl $16, %ecx
; X64-NOPOPCNT-NEXT:    xorl %edi, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %ch, %cl
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_32:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    popcntl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_32:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntl %edi, %eax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    retq
  %1 = tail call i32 @llvm.ctpop.i32(i32 %x)
  %2 = and i32 %1, 1
  ret i32 %2
}

define i64 @parity_64(i64 %x) {
; X86-NOPOPCNT-LABEL: parity_64:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    shrl $16, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    xorl %edx, %edx
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_64:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movq %rdi, %rax
; X64-NOPOPCNT-NEXT:    shrq $32, %rax
; X64-NOPOPCNT-NEXT:    xorl %edi, %eax
; X64-NOPOPCNT-NEXT:    movl %eax, %ecx
; X64-NOPOPCNT-NEXT:    shrl $16, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %ch, %cl
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_64:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    popcntl %eax, %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    xorl %edx, %edx
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_64:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntq %rdi, %rax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    retq
  %1 = tail call i64 @llvm.ctpop.i64(i64 %x)
  %2 = and i64 %1, 1
  ret i64 %2
}

define i32 @parity_64_trunc(i64 %x) {
; X86-NOPOPCNT-LABEL: parity_64_trunc:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    shrl $16, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_64_trunc:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movq %rdi, %rax
; X64-NOPOPCNT-NEXT:    shrq $32, %rax
; X64-NOPOPCNT-NEXT:    xorl %edi, %eax
; X64-NOPOPCNT-NEXT:    movl %eax, %ecx
; X64-NOPOPCNT-NEXT:    shrl $16, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %ch, %cl
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_64_trunc:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    popcntl %eax, %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_64_trunc:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntq %rdi, %rax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    # kill: def $eax killed $eax killed $rax
; X64-POPCNT-NEXT:    retq
  %1 = tail call i64 @llvm.ctpop.i64(i64 %x)
  %2 = trunc i64 %1 to i32
  %3 = and i32 %2, 1
  ret i32 %3
}

define i8 @parity_32_trunc(i32 %x) {
; X86-NOPOPCNT-LABEL: parity_32_trunc:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    shrl $16, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_32_trunc:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movl %edi, %eax
; X64-NOPOPCNT-NEXT:    shrl $16, %eax
; X64-NOPOPCNT-NEXT:    xorl %edi, %eax
; X64-NOPOPCNT-NEXT:    xorb %ah, %al
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_32_trunc:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    popcntl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    # kill: def $al killed $al killed $eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_32_trunc:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntl %edi, %eax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    # kill: def $al killed $al killed $eax
; X64-POPCNT-NEXT:    retq
  %1 = tail call i32 @llvm.ctpop.i32(i32 %x)
  %2 = trunc i32 %1 to i8
  %3 = and i8 %2, 1
  ret i8 %3
}

define i16 @parity_16_zexti8(i8 %x) {
; X86-LABEL: parity_16_zexti8:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpb $0, {{[0-9]+}}(%esp)
; X86-NEXT:    setnp %al
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: parity_16_zexti8:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb %dil, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %a = zext i8 %x to i16
  %b = tail call i16 @llvm.ctpop.i16(i16 %a)
  %c = and i16 %b, 1
  ret i16 %c
}

define i16 @parity_16_mask255(i16 %x) {
; X86-LABEL: parity_16_mask255:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpb $0, {{[0-9]+}}(%esp)
; X86-NEXT:    setnp %al
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: parity_16_mask255:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb %dil, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %a = and i16 %x, 255
  %b = tail call i16 @llvm.ctpop.i16(i16 %a)
  %c = and i16 %b, 1
  ret i16 %c
}

define i16 @parity_16_mask15(i16 %x) {
; X86-LABEL: parity_16_mask15:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testb $15, %cl
; X86-NEXT:    setnp %al
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: parity_16_mask15:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb $15, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %a = and i16 %x, 15
  %b = tail call i16 @llvm.ctpop.i16(i16 %a)
  %c = and i16 %b, 1
  ret i16 %c
}

define i16 @parity_16_shift(i16 %0) {
; X86-NOPOPCNT-LABEL: parity_16_shift:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    addl %eax, %eax
; X86-NOPOPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_16_shift:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movl %edi, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %ch, %cl
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    addl %eax, %eax
; X64-NOPOPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_16_shift:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    popcntl %eax, %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    addl %eax, %eax
; X86-POPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_16_shift:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    movzwl %di, %eax
; X64-POPCNT-NEXT:    popcntl %eax, %eax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    addl %eax, %eax
; X64-POPCNT-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-POPCNT-NEXT:    retq
  %2 = tail call i16 @llvm.ctpop.i16(i16 %0)
  %3 = shl nuw nsw i16 %2, 1
  %4 = and i16 %3, 2
  ret i16 %4
}

define i32 @parity_32_zexti8(i8 %x) {
; X86-LABEL: parity_32_zexti8:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpb $0, {{[0-9]+}}(%esp)
; X86-NEXT:    setnp %al
; X86-NEXT:    retl
;
; X64-LABEL: parity_32_zexti8:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb %dil, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    retq
  %a = zext i8 %x to i32
  %b = tail call i32 @llvm.ctpop.i32(i32 %a)
  %c = and i32 %b, 1
  ret i32 %c
}

define i32 @parity_32_mask255(i32 %x) {
; X86-LABEL: parity_32_mask255:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpb $0, {{[0-9]+}}(%esp)
; X86-NEXT:    setnp %al
; X86-NEXT:    retl
;
; X64-LABEL: parity_32_mask255:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb %dil, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    retq
  %a = and i32 %x, 255
  %b = tail call i32 @llvm.ctpop.i32(i32 %a)
  %c = and i32 %b, 1
  ret i32 %c
}

define i32 @parity_32_mask15(i32 %x) {
; X86-LABEL: parity_32_mask15:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testb $15, {{[0-9]+}}(%esp)
; X86-NEXT:    setnp %al
; X86-NEXT:    retl
;
; X64-LABEL: parity_32_mask15:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb $15, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    retq
  %a = and i32 %x, 15
  %b = tail call i32 @llvm.ctpop.i32(i32 %a)
  %c = and i32 %b, 1
  ret i32 %c
}

define i32 @parity_32_shift(i32 %0) {
; X86-NOPOPCNT-LABEL: parity_32_shift:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    shrl $16, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    addl %eax, %eax
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_32_shift:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movl %edi, %ecx
; X64-NOPOPCNT-NEXT:    shrl $16, %ecx
; X64-NOPOPCNT-NEXT:    xorl %edi, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %ch, %cl
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    addl %eax, %eax
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_32_shift:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    popcntl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    addl %eax, %eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_32_shift:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntl %edi, %eax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    addl %eax, %eax
; X64-POPCNT-NEXT:    retq
  %2 = tail call i32 @llvm.ctpop.i32(i32 %0)
  %3 = shl nuw nsw i32 %2, 1
  %4 = and i32 %3, 2
  ret i32 %4
}

define i64 @parity_64_zexti8(i8 %x) {
; X86-LABEL: parity_64_zexti8:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpb $0, {{[0-9]+}}(%esp)
; X86-NEXT:    setnp %al
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    retl
;
; X64-LABEL: parity_64_zexti8:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb %dil, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    retq
  %a = zext i8 %x to i64
  %b = tail call i64 @llvm.ctpop.i64(i64 %a)
  %c = and i64 %b, 1
  ret i64 %c
}

define i64 @parity_64_mask255(i64 %x) {
; X86-LABEL: parity_64_mask255:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpb $0, {{[0-9]+}}(%esp)
; X86-NEXT:    setnp %al
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    retl
;
; X64-LABEL: parity_64_mask255:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb %dil, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    retq
  %a = and i64 %x, 255
  %b = tail call i64 @llvm.ctpop.i64(i64 %a)
  %c = and i64 %b, 1
  ret i64 %c
}

define i64 @parity_64_mask15(i64 %x) {
; X86-LABEL: parity_64_mask15:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testb $15, {{[0-9]+}}(%esp)
; X86-NEXT:    setnp %al
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    retl
;
; X64-LABEL: parity_64_mask15:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb $15, %dil
; X64-NEXT:    setnp %al
; X64-NEXT:    retq
  %a = and i64 %x, 15
  %b = tail call i64 @llvm.ctpop.i64(i64 %a)
  %c = and i64 %b, 1
  ret i64 %c
}

define i64 @parity_64_shift(i64 %0) {
; X86-NOPOPCNT-LABEL: parity_64_shift:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    shrl $16, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    addl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorl %edx, %edx
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_64_shift:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movq %rdi, %rax
; X64-NOPOPCNT-NEXT:    shrq $32, %rax
; X64-NOPOPCNT-NEXT:    xorl %edi, %eax
; X64-NOPOPCNT-NEXT:    movl %eax, %ecx
; X64-NOPOPCNT-NEXT:    shrl $16, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %ch, %cl
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    addl %eax, %eax
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_64_shift:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    popcntl %eax, %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    addl %eax, %eax
; X86-POPCNT-NEXT:    xorl %edx, %edx
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_64_shift:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntq %rdi, %rax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    addl %eax, %eax
; X64-POPCNT-NEXT:    retq
  %2 = tail call i64 @llvm.ctpop.i64(i64 %0)
  %3 = shl nuw nsw i64 %2, 1
  %4 = and i64 %3, 2
  ret i64 %4
}

declare i4 @llvm.ctpop.i4(i4 %x)
declare i8 @llvm.ctpop.i8(i8 %x)
declare i16 @llvm.ctpop.i16(i16 %x)
declare i17 @llvm.ctpop.i17(i17 %x)
declare i32 @llvm.ctpop.i32(i32 %x)
declare i64 @llvm.ctpop.i64(i64 %x)
