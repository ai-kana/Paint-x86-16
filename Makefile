build = build
source = src

$(build)/disc.img: $(build)/main.bin
	cp $(build)/main.bin $(build)/disc.img
	truncate -s 1440k $(build)/disc.img

$(build)/main.bin: $(source)/main.asm
	mkdir -p $(build)
	nasm $(source)/main.asm -f bin -o $(build)/main.bin
