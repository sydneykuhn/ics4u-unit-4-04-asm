; ----------------------------------------------;
; This program uses a loop to output numbers.   ;
; For x86 only.                                 ;
; ----------------------------------------------;

section .bss
  someNumber: RESD 1                     ; 4 bytes

section .data
  ; constants here
  newLine: db 10                       ; UNICODE 10 is new line character
  done: db 10, "Done.", 10             ; string to print
  doneLen: equ $-done                  ; length of string

section .text
  global _start                        ; entry point for linker

  _start:                              ; start here
    mov r8, 1                          ; move the integer 0 into r8
    mov r9, 0                          ; move the integer 9 into r9
    mov r10, 1                         ; n2
    mov r11, 0                         ; nth

    IncrementLabel:
      ; doing
      inc r8
      push r9
      call PrintSingleDigitInt     ; call our print single digit function

      ; adding
      mov r11, r9
      add r11, r10

      ; update values
      mov r9, r10
      mov r10, r11

      add rsp, 4                   ; pop but throw away the value
      cmp r8, 8-1                  ; compare r8 and ascii 9
      jle IncrementLabel           ; jump if <= goto "LoopLable"

      ; write done to screen
      mov rax, 1                  ; system call for write
      mov rdi, 1                  ; file handle 1 is stdout
      mov rsi, done               ; address of string to output
      mov rdx, doneLen            ; number of bytes
      syscall                     ; invoke operating system to do the write

      mov rax, 60                 ; system call for exit
      mov rdi, 0                  ; exit code 0
      syscall                     ; invoke operating system to exit

PrintSingleDigitInt:
  ; function
  pop r14                     ; pop the return address to r9
  pop r15                     ; pop the "parameter" we placed on the stack
  add r15, 48                 ; add the ascii offset
  push r15                    ; place it back onto the stack

  ; write value on the stack to STDOUT
  mov rax, 1                  ; system call for write
  mov rdi, 1                  ; file handle 1 is stdout
  mov rsi, rsp                ; the string to write popped from the top of the stack
  mov rdx, 1                  ; number of bytes
  syscall                     ; invoke operating system to do the write

  ; print a new line
  mov rax, 1                  ; system call for write
  mov rdi, 1                  ; file handle 1 is stdout
  mov rsi, newLine            ; address of string to output
  mov rdx, 1                  ; number of bytes
  syscall                     ; invoke operating system to do the write

  push r14                    ; put the return address back on the stack to get back
  ret                         ; return