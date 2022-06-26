CC=gcc
CFLAGS=-m32 -no-pie -g

OBJ=args
SRC=args.S

all:
	gcc $(CFLAGS) -o $(OBJ) $(SRC)

clean:
	rm $(OBJ) >/dev/null 2>&1 || exit 0

.PHONY: clean

