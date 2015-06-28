#the Makefile of wordcount
CC = GCC
CFLAGS ="-g" -DDEBUG -c
LIBS = -lncurses
# include the head file in the dir
INCLUDE = -I./include

all: clean install

install: wordcount

wordcount:  getword.o binsearch.o wordcount.o
	$(CC) -o $@ $? $(LIBS)

wordcount.o:
	$(CC) $(CFLAGS) -o $@ wordcount.c $(INCLUDE)

binsearch.o:
	$(CC) $(CFLAGS) -o $@ binsearch.c $(INCLUDE)

getword.o:
	$(CC) $(CFLAGS) -o $@ getword.c $(INCLUDE)

clean:
	-rm *.o
	-rm *.~
