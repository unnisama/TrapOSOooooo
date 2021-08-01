global loader
extern kmain
MAGIC_NUMBER equ 0x1BADB002
FLAGS        equ 0x0
CHECKSUM     equ -MAGIC_NUMBER
STACK_SIZE equ 0x20000
section .bss
align 4
kernel_stack:
	resb STACK_SIZE
section .text
align 4
	dd MAGIC_NUMBER
	dd FLAGS
	dd CHECKSUM

loader:
	mov esp, kernel_stack + STACK_SIZE
	call kmain
.loop:
	jmp .loop

