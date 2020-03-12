OBJECTS = skpfa.o skpf10.o skbpfa.o skbpf10.o sktrf.o sktrd.o skbtrd.o

CC = gcc
CFLAGS = -O3 -fPIC
ROOT := $(shell cd .. && pwd)

all: $(OBJECTS)
	$(AR) rvu libcpfapack.a $(OBJECTS)
	gcc -shared -fPIC -o libcpfapack.so $(OBJECTS) -L${PREFIX}/lib -lpfapack -Wl,-rpath,"$(ROOT)/c_interface:$(ROOT)/fortran" -llapack -lblas

clean:
	rm -f *.o
	rm -f libcpfapack.a
	rm -f libcpfapack.so

.SUFFIXES: .o .c

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

