#the Makefile of wordcount
CC = GCC
CFLAGS ="-g" -DDEBUG -c
LIBS = -lncurses
# include the head file in the dir
INCLUDE = -I./include

all: clean install

install: wordcount

wordcount: wordcount.o getword.o addtree.o treeprint.o
	$(CC) -o $@ $? $(LIBS)

wordcount.o:
	$(CC) $(CFLAGS) -o $@ wordcount.c $(INCLUDE)

getword.o:
	$(CC) $(CFLAGS) -o $@ getword.c $(INCLUDE)

addtree.o:
	$(CC) $(CFLAGS) -o $@ addtree.c $(INCLUDE)

treeprint.o:
	$(CC) $(CFLAGS) -o $@ treeprint.c $(INCLUDE)


clean:
	-rm *.o
	-rm *.~
