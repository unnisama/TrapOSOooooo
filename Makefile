ASM=nasm
ASMFLAG=-f elf
LINKERSC=linker.ld
CDROMIMG=os.iso
CFLAGS=-target i386 -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nodefaultlibs -Wall -Wextra -Werror -c
ASMFILE = $(wildcard *.asm)
OBJFILE = $(ASMFILE:.asm=.o)
CFILE = $(wildcard *.c)
OBJFILE += $(CFILE:.c=.o)
CC=clang
RMFILE=''
all: $(CDROMIMG)
%.o: %.asm
	$(foreach var,$(ASMFILE), nasm -f elf $(var);)
%.o: %.c
	clang $(CFLAGS) $^ 
kernel.elf: $(OBJFILE)
	ld.lld -T linker.ld -melf_i386 $^ -o $@
$(CDROMIMG): kernel.elf
	mkdir -p iso/boot/grub
	cp kernel.elf iso/boot
	xorrisofs -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table -quiet -o $(CDROMIMG) iso
run:
	qemu-system-x86_64 -cdrom os.iso -nographic
runvncd:
	qemu-system-x86_64 -d cpu -D Logos.txt -cdrom os.iso
runvnc:
	qemu-system-x86_64 -cdrom os.iso
clean:
	rm *.o *.txt *.iso
