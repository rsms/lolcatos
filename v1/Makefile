all: boot.bin

clean:
	-rm *.bin *.log

boot.bin: boot.s
	nasm -f bin boot.s -o boot.bin
