org   0x7c00        ; We are loaded by BIOS at 0x7C00

bits  16          ; We are still in 16 bit Real Mode

Start:

  cli         ; Clear all Interrupts
  hlt         ; halt the system

; We have to be 512 bytes. Clear the rest of the bytes with 0.
times 510 - ($-$$) db 0

; Boot Signature.
; The BIOS INT 0x19 searches for a bootable disk. How does it know if the disk
; is bootable? The boot signiture. If the 511 byte is 0xAA and the 512 byte is
; 0x55, INT 0x19 will load and execute the bootloader.
dw 0xAA55
