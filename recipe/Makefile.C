OBJECTS = skpfa.o skpf10.o skbpfa.o skbpf10.o sktrf.o sktrd.o skbtrd.o

all: $(OBJECTS)
	$(AR) rvu libcpfapack.a $(OBJECTS)
	$(CC) -shared $(CFLAGS) -o libcpfapack.so $(OBJECTS) -L${PREFIX}/lib -lpfapack -llapack -lblas

clean:
	rm -f *.o
	rm -f libcpfapack.a
	rm -f libcpfapack.so

.SUFFIXES: .o .c

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

