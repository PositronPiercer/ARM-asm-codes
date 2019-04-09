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


@first 4 bytes contain value , next four bytes contains pointer to next node
@create the linked list
.text
  mov r0,#1000 @r0 contains the starting point of the node
  mov r1,#8

@linked list will be 8,7,6,5,4,3,2,1
create_linked_list:
  cmp r1,#0
  beq get_largest
  str r1,[r0] @store the value
  add r3,r0,#8

  str r3,[r0,#4] @store the next address
  add r0,r0,#8
  sub r1,r1,#1
  b create_linked_list

@r0 stores the largest value
@r1 stores the value of current node
@r2 stores the address of next node
@r3 stores the address of the current node
get_largest:
  sub r0,r0,#4
  mov r1,#0
  str r1,[r0] @make the last address 0
  mov r0,#1000
  mov r3,#1000
  ldr r0,[r3] @get the first value
  ldr r1,[r3]
  mov r2,r3
  ldr r2,[r3,#4] @get first value
  ldr r3,[r3,#4] @points to next node
  mov r7,#1000
  mov r5,#1000
  b loop

loop:
  @ldr r9,[r3,#4]
  cmp r3,#0
  beq greatest_found
  mov r9,r3
  ldr r1,[r9] @get value
  cmp r1,r0
  movgt r0,r1 @update greatest value
  movgt r5,r3 @update greatest address
  mov r4,r3 @stores the address of the previous node
  ldr r3,[r3,#4]
  b loop



greatest_found:
  mov r0,#2000
  @mov r5,#2400
  @str r0,[r5]  @2400 stores the starting address of heap
  mov r8,#4000 @ 4000 stores the address of the current index of the heap
  str r0,[r8]
  mov r5,#2800
  mov r6,#1000
  str r6,[r5]  @ 200 stores the starting of the linked list
  mov r6,#1
  mov r3,#500
  str r6,[r3] @500 stores the loop counter
  b sort

sort:
  mov r2,#500
  ldr r2,[r2]
  cmp r2,#9
  beq set_pointers
  b find_largest
  @r5 now has the address of the greatest node
sort_inter:
  mov r2,#4000
  ldr r2,[r2]
  str r5,[r2]
  add r2,r2,#4
  mov r8,#4000
  str r2,[r8]
  @remove the node
  mov r6,#2800
  ldr r6,[r6] @get the starting node
  cmp r5,r6
  ldr r8,[r5,#4]
  mov r6,#2800
  streq r8,[r6]  @ if node is the starting node
  strne r8,[r4,#4] @ not the starting node
  mov r2,#500
  ldr r2,[r2]
  add r2,#1
  mov r3,#500
  str r2,[r3]
  b sort

  find_largest:
    mov r0,#2800
    ldr r0,[r0]
    mov r3,r0
    mov r5,r0
    ldr r0,[r3] @get the first value
    ldr r1,[r3]
    mov r2,r3
    ldr r2,[r3,#4] @get first value
    ldr r3,[r3,#4] @points to next node
    mov r7,r0
    b loop1

  loop1:
    @ldr r9,[r3,#4]
    cmp r3,#0
    beq sort_inter
    mov r9,r3
    ldr r1,[r9] @get value
    cmp r1,r0
    movgt r0,r1 @update greatest value
    movgt r5,r3 @update greatest address
    mov r4,r3 @stores the address of the previous node
    ldr r3,[r3,#4]
    b loop1

set_pointers:
  mov r5,#2000
  mov r6,#1
  b doit
doit:
  cmp r6,#8
  beq show
  ldr r0,[r5]
  ldr r1,[r5,#4]
  str r1,[r0,#4]
  add r5,r5,#4
  add r6,r6,#1
  b doit

show:
  mov r6,#0
  str r6,[r5,#4]
  mov r5,#2000
  ldr r5,[r5] @starting pointer
  mov r0,#1
  b show_list

show_list:
  cmp r5,#0
  beq done
  ldr r1,[r5]
  swi SWI_PrInt
  ldr r5,[r5,#4]
  b show_list

done:
  swi SWI_Exit
