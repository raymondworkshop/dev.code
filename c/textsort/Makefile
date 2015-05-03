#the Makefile of textsort
CC = GCC
CFLAGS ="-g" -DDEBUG -c
LIBS = -lncurses
# include the head file in the dir
INCLUDE = -I./include

all: clean install

install: textsort

textsort: textsort.o readlines.o qsort.o getline_.o alloc_.o
	$(CC) -o $@ $? $(LIBS)

textsort.o:
	$(CC) $(CFLAGS) -o $@ textsort.c $(INCLUDE)
readlines.o:
	$(CC) $(CFLAGS) -o $@ readlines.c $(INCLUDE)
qsort.o:
	$(CC) $(CFLAGS) -o $@ qsort.c $(INCLUDE)
getline_.o:
	$(CC) $(CFLAGS) -o $@ getline_.c $(INCLUDE)
alloc_.o:
	$(CC) $(CFLAGS) -o $@ alloc_.c $(INCLUDE)

clean:
	-rm *.o
	-rm *~
