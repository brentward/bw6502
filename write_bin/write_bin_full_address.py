#! /usr/bin/env python3

def main():
    memory_space = bytearray([0xea] * 65536)
    memory_space[0x8000] = 0xa9
    memory_space[0x8001] = 0x42

    memory_space[0x8002] = 0x8d
    memory_space[0x8003] = 0x00
    memory_space[0x8004] = 0x60

    memory_space[0xfffc] = 0x00
    memory_space[0xfffd] = 0x80
    rom = memory_space[32768:]
    with open('rom_fa.bin', 'wb') as out_file:
        out_file.write(rom)


if __name__ == '__main__':
    main()