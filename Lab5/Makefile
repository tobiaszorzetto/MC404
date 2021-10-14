gps.o : gps.s

	clang-10 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax gps.s -c -o gps.o

gps.x : gps.o

	ld.lld-10 -g gps.o -o gps.x