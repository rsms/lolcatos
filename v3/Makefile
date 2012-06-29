all: boot.bin meow.bin

clean:
	-rm *.bin *.log

boot.bin: boot.s
	nasm -f bin boot.s -o boot.bin

meow.bin: meow.s
	nasm -f bin meow.s -o meow.bin
