bits  16              ; We are still in 16 bit Real Mode

org   0x7c00            ; We are loaded by BIOS at 0x7C00

start:          jmp loader          ; jump past OEM block

;*************************************************;
; OEM Parameter block
;*************************************************;

;TIMES 0Bh-$+start DB 0

bpbOEM                  db "RaOS    "       ; OS name. Must be exactally 8 bytes.
bpbBytesPerSector:      DW 512
bpbSectorsPerCluster:   DB 1
bpbReservedSectors:     DW 1
bpbNumberOfFATs:        DB 2
bpbRootEntries:         DW 224
bpbTotalSectors:        DW 2880
bpbMedia:               DB 0xF0
bpbSectorsPerFAT:       DW 9
bpbSectorsPerTrack:     DW 18
bpbHeadsPerCylinder:    DW 2
bpbHiddenSectors:       DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber:          DB 0
bsUnused:               DB 0
bsExtBootSignature:     DB 0x29
bsSerialNumber:         DD 0xa0a1a2a3
bsVolumeLabel:          DB "MOS FLOPPY "
bsFileSystem:           DB "FAT12   "

msg db  "Welcome to RaOS - the lolcat operating system", 0

;***************************************
; Prints a string
; DS=>SI: 0 terminated string
;***************************************

print:
  lodsb
  or      al, al        ; al=current character
  jz      print_end     ; null terminator found
  mov     ah, 0eh       ; get next character
  int     10h
  jmp     print
print_end:
  ret

;*************************************************;
; Bootloader Entry Point
;*************************************************;

loader:

  xor ax, ax    ; Setup segments to insure they are 0. Remember that
  mov ds, ax    ; we have ORG 0x7c00. This means all addresses are based
  mov es, ax    ; from 0x7c00:0. Because the data segments are within the same
                ; code segment, null em.

  mov si, msg   ; message to print
  call print    ; call our print function

  xor ax, ax    ; clear ax
  int 0x12      ; get the amount of KB from the BIOS

  cli     ; Clear all Interrupts
  hlt     ; halt the system

times 510 - ($-$$) db 0   ; We have to be 512 bytes. Clear the rest of the bytes with 0

dw 0xAA55     ; Boot Signiture
