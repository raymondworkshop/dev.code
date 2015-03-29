#This is the Makefile of calc
CC = gcc
CFLAGS = -DDEBUG -c
LIBS = -lncurses
# include the head file in the dir
INCLUDE = -I./include

#prerequisites (clean, install) - are the standard in which the target (all) should be rebuild
all: clean install

install: calc

#$@ is the current target; $? is the depend
calc: calc.o stack.o getop.o getch.o
	$(CC) -o $@ $? $(LIBS)

calc.o:
	$(CC) $(CFLAGS) -o $@ calc.c $(INCLUDE)

stack.o:
	$(CC) $(CFLAGS) -o $@ stack.c $(INCLUDE)

getop.o:
	$(CC) $(CFLAGS) -o $@ getop.c $(INCLUDE)

getch.o:
	$(CC) $(CFLAGS) -o $@ getch.c $(INCLUDE)

clean: 
	-rm *.o
	-rm *~
