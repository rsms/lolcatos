; Note: Here, we are executed like a normal
; COM program, but we are still in Ring 0.
; We will use this loader to set up 32 bit
; mode and basic exception handling
 
; This loaded program will be our 32 bit Kernel.
 
; We do not have the limitation of 512 bytes here,
; so we can add anything we want here!
 
org 0x0   ; offset to 0, we will set segments later
 
bits 16   ; we are still in real mode
 
; we are loaded at linear address 0x10000
 
jmp main  ; jump to main
 
;*************************************************;
; Prints a string
; DS=>SI: 0 terminated string
;************************************************;
 
print:
  lodsb   ; load next byte from string from SI to AL
  or  al, al  ; Does AL=0?
  jz  print_end ; Yep, null terminator found-bail out
  mov ah, 0eh ; Nope-Print the character
  int 10h
  jmp print ; Repeat until null terminator found
print_end:
  ret   ; we are done, so return
 
;*************************************************;
; Second Stage Loader Entry Point
;************************************************;
 
main:
  cli   ; clear interrupts
  push  cs  ; Insure DS=CS
  pop ds

  mov si, welcome_msg
  call print

  cli   ; clear interrupts to prevent triple faults
  hlt   ; hault the system
 
;*************************************************;
; Data Section
;************************************************;
 
welcome_msg db  "Loading RaOS - the lolcat operating system...",13,10,0
