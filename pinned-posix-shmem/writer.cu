#include <cuda.h>
#include <cuda_runtime.h>

#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h>

#include <sys/mman.h>
#include <fcntl.h>
#include <sys/shm.h>
#include <sys/stat.h>


#include <helper_cuda.h>

const size_t SIZE = 1 << 10; // 1 kiB of shared memory
const char* NAME = "test_shm";


__global__ void fill_kernel(int* arr)
{
	size_t i = blockIdx.x * blockDim.x + threadIdx.x;

	if (i < (SIZE / sizeof(int)))
		arr[i] = i;

}


int main(int argc, char* argv[])
{
	// Create shm
	int fd = shm_open(NAME, O_CREAT | O_RDWR, 0666);
	if (fd < 0)
	{
		fprintf(stderr, "Failed to open shared memory %s\n", NAME);
		return EXIT_FAILURE;
	}


	int res = ftruncate(fd, SIZE);
	if (res == -1)
	{
		fprintf(stderr, "Failed to resize shared memory %s\n", NAME);
		return EXIT_FAILURE;
	}


	// Map memory
	void* ptr = mmap(0, SIZE, PROT_WRITE, MAP_SHARED, fd, 0);
	

	// Pin this POSIX shared memory
	checkCudaErrors(cudaHostRegister(ptr, SIZE, cudaHostRegisterDefault));


	// Generate sample data from the GPU
	void* d_ptr;
	checkCudaErrors(cudaHostGetDevicePointer(&d_ptr, ptr, 0));

	const size_t nThreads = 256;
	const size_t nBlocks = (SIZE / sizeof(int) + nThreads - 1) / nThreads;
	fill_kernel<<<nThreads, nBlocks>>>((int*) d_ptr);
	checkCudaErrors(cudaDeviceSynchronize());
	
	printf("%lu bytes written to shm %s\n", SIZE, NAME);

	checkCudaErrors(cudaHostUnregister(ptr));

	return EXIT_SUCCESS;
}
