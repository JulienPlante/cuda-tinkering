#include <stdio.h> 
#include <stdlib.h> 

#include <sys/mman.h>
#include <fcntl.h>
#include <sys/shm.h>
#include <sys/stat.h>


const size_t SIZE = 1 << 10; // 1 kiB of shared memory
const char* NAME = "test_shm";


int main(int argc, char* argv[])
{
	int fd = shm_open(NAME, O_RDONLY, 0666);
	if (fd < 0)
	{
		fprintf(stderr, "Failed to open shared memory %s\n", NAME);
		return EXIT_FAILURE;
	}

	int* ptr = (int*) mmap(0, SIZE, PROT_READ, MAP_SHARED, fd, 0);

	for (int i = 0; i < 100; i++)
		printf("ptr[%d] = %d\n", i, ptr[i]);
	
	shm_unlink(NAME);
	return EXIT_SUCCESS;
}
