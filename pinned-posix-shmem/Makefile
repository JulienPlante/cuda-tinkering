CC = gcc
CUDA = nvcc

INCLUDE_DIRS = ../utils


IFLAGS = $(addprefix -I,$(INCLUDE_DIRS))
LDFLAGS = -lrt

all: reader writer


reader: reader.c
	$(CC) reader.c -o reader $(LDFLAGS) $(IFLAGS)

writer: writer.cu
	$(CUDA) writer.cu -o writer $(LDFLAGS) $(IFLAGS)


run: all
	./writer
	./reader

clean:
	rm -f writer reader


.PHONY: all run clean
