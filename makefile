boot1_file = boot1
boot1_pos = 0
boot1_size = 1

boot2_file = boot2
boot2_pos = 1
boot2_size = 1

menu_file = menu
menu_pos = 2
menu_size = 4

kernel_file = kernel
kernel_pos = 6
kernel_size = 63


boot_disk = file=disk.img
block_size = 512
disk_size = 128


all: create_disk boot1 write_boot1 boot2 write_boot2 menu write_menu kernel write_kernel launch clean
create_disk:
	@dd if=/dev/zero of=$(boot_disk) bs=$(block_size) count=$(disk_size) status=noxfer

boot1:
	@nasm -f bin $(boot1_file).asm -o $(boot1_file).bin

boot2:
	@nasm -f bin $(boot2_file).asm -o $(boot2_file).bin

menu:
	@nasm -f bin $(menu_file).asm -o $(menu_file).bin

kernel:
	@nasm -f bin $(kernel_file).asm -o $(kernel_file).bin

write_boot1:
	@dd if=$(boot1_file).bin of=$(boot_disk) bs=$(block_size) seek=$(boot1_pos) count=$(boot1_size) conv=notrunc status=noxfer

write_boot2:
	@dd if=$(boot2_file).bin of=$(boot_disk) bs=$(block_size) seek=$(boot2_pos) count=$(boot2_size) conv=notrunc status=noxfer

write_menu:
	@dd if=$(menu_file).bin of=$(boot_disk) bs=$(block_size) seek=$(menu_pos) count=$(menu_size) conv=notrunc status=noxfer

write_kernel:
	@dd if=$(kernel_file).bin of=$(boot_disk) bs=$(block_size) seek=$(kernel_pos) count=$(kernel_size) conv=notrunc status=noxfer

launch:
	@qemu-system-i386 -drive file=$(boot_disk),format=raw,index=0,if=floppy

clean:
	@rm -f *.bin $(boot_disk) *~
