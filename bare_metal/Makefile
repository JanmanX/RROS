CROSS_COMPILE = riscv64-unknown-elf-
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
CFLAGS = -Wall -Wextra -c -mcmodel=medany -ffreestanding
LDFLAGS = -T linker.ld -nostdlib

run: kernel.elf
	qemu-system-riscv64 -machine virt -bios none -kernel kernel.elf -serial mon:stdio


all: kernel.elf

kernel.o: kernel.c
	$(CC) $(CFLAGS) kernel.c -o kernel.o

entry.o: entry.S
	$(AS) -c entry.S -o entry.o

kernel.elf: kernel.o entry.o linker.ld
	$(LD) $(LDFLAGS) kernel.o entry.o -o kernel.elf

clean:
	rm -f *.o *.elf
