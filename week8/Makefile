# General flags we'll always use
GENFLAGS := -Wall -Wextra -Wpedantic -std=c99 -Wvla -Wfloat-equal 

# -O3 means optimise compiled code for execution speed
OPTIM := $(GENFLAGS) -O3

# Creates a much slower executable but filled with run-time error/bounds checking etc.
# -g flag gives extra debugging information
SANITIZE := $(GENFLAGS) -g3 -fsanitize=address -fsanitize=undefined

# In the labs you might use clang, but make sure to try gcc too
# (sometimes bugs show up 'better' using one compiler than another
# CC := gcc
CC := clang

hack_parser: main.c symboltable.c token.c symboltable.h token.h 
	# $(CC) main.c symboltable.c token.c $(OPTIM) -o hack_parser 
	$(CC) main.c symboltable.c token.c -o hack_parser

hack_parser_d: main.c symboltable.c token.c symboltable.h token.h 
	$(CC) main.c symboltable.c token.c $(SANITIZE) -o hack_parser_d 

run: hack_parser 
	./hack_parser

clean:
	rm -rf hack_parser hack_parser_d