obj_dump.s: obj_dump.c

	clang-10 -g --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax obj_dump.c -S -o obj_dump.s

obj_dump.o: obj_dump.s

	clang-10 -g --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax obj_dump.s -c -o obj_dump.o

obj_dump.x: obj_dump.o 

	ld.lld-10 -g obj_dump.o -o obj_dump.x