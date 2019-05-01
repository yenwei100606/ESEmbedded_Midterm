CROSS-COMPILER = arm-none-eabi-
QEMU = ./gnu-mcu-eclipse-qemu/bin/qemu-system-gnuarmeclipse

all: clock.bin

clock.bin: main.c blink.c startup.c vector_table.s
	$(CROSS-COMPILER)gcc -Wall -std=c11 -mcpu=cortex-m4 -mthumb -nostartfiles -T stm32f4.ld main.c blink.c startup.c vector_table.s -o clock.elf
	$(CROSS-COMPILER)objcopy -O binary clock.elf clock.bin


flash:
	st-flash --reset write clock.bin 0x8000000

qemu:
      	@echo	
        @echo "Press Ctrl+A and then press X to exit QEMU"
        @echo
        $(QEMU) -M STM32F4-Discovery -nographic -gdb tcp::1234 -S -kernel main.bin
clean:
	rm -f *.o *.elf *.bin
