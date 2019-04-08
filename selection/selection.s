
@ give symbolic names to numeric constants
.equ SWI_PrChr, 0x00
.equ SWI_DpStr, 0x02
.equ SWI_Exit, 0x11
.equ SWI_MeAlloc, 0x12
.equ SWI_DAlloc, 0x13
.equ SWI_Open, 0x66
.equ SWI_Close, 0x68
.equ SWI_PrStr, 0x69
.equ SWI_RdStr, 0x6a
.equ SWI_PrInt, 0x6b
.equ SWI_RdInt, 0x6c
.equ SWI_Timer, 0x6d

.data
infilename: .asciz "in.txt"
outfilename: .asciz "out.txt"
seperator: .asciz " "

.align
infilehandle: .word 0
outfilehandle: .word 0


@Open File
.text
Open:
  ldr r0,=infilename
  mov r1, #0 @read mode
  swi SWI_Open  @opening File
  ldr r1,=infilehandle
  str r0,[r1]
  mov r2, #0 @count no. of int read

Read:
  ldr r0,=infilehandle
  mov r9,r0
  ldr r0,[r0]
  swi SWI_RdInt @read integer
  bcs readDone
  add r2,r2,#1 @increment no. of integer read
  cmp r2,#1
  beq alloc_mem
  @r4 stores the address where the int will be inserted
  str r0,[r4]
  add r4,r4,#4




  b Read

alloc_mem:
  mov r4,#4
  mov r5,r0 @r5 stores the total no. of elements
  mul r0,r0,r4
  swi SWI_MeAlloc
  mov r3,r0 @r3 stores the beginning of the array
  mov r4,r3
  b Read






readDone:
  @ swi SWI_Exit
  ldr r0,=infilehandle
  ldr r0,[r0]
  swi SWI_Close
  mov r6,#0
  mov r4,r3
  b sel_sort

sel_sort:
  mov r0,r3 @r0 stores start of array
  sub r1,r5,#1 @r1=n-1
  mov r2,#0 @outer loop counter
  mov r3,#0 @inner loop counter
  mov r4,r0
  mov r9,#4
  b outer_loop

outer_loop:
  cmp r2,r1
  beq program_end
  mul r7,r2,r9
  add r7,r0,r7 @r7 stores min_index
  add r3,r2,#1 @j=i+1
  add r6,r1,#1 @r6=n
  b inner_loop

inner_loop:
  cmp r3,r6
  beq swap
  mul r8,r3,r9
  add r8,r8,r0 @ar[j]
  ldr r4,[r8]
  ldr r5,[r7] @ar[min_index]
  cmp r4,r5
  movlo r7,r8
  add r3,#1
  b inner_loop

swap:
    @ mov r7,r4
    @ mov r4,r5
    @ mov r5,r7
    mul r8,r2,r9
    add r8,r8,r0
    ldr r4,[r8] @ar[i]
    ldr r5,[r7] @ar[min_index]
    str r4,[r7]
    str r5,[r8]
    add r2,#1
    b outer_loop



program_end:
  mov r4,r0
  mov r6,#0
  add r5,r1,#1
  ldr r0,=outfilename
  mov r1, #1 @write mode
  swi SWI_Open  @opening File
  ldr r1,=outfilehandle
  str r0,[r1]
  b read_from_mem




read_from_mem:
    ldr r1,[r4]
    add r4,r4,#4
    ldr r0,=outfilehandle
    ldr r0,[r0]
    @mov r0,#1
    swi SWI_PrInt
    bcs operr
    ldr r1,=seperator
    @mov r0,#1
    swi SWI_PrStr
    add r6,r6,#1
    cmp r6,r5
    blo read_from_mem
    swi SWI_Close
    swi SWI_Exit

operr:
  swi SWI_Exit
