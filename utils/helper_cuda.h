#pragma once
#include <cuda.h>
#include <cuda_runtime.h>

#include <stdio.h>

#define checkCudaErrors(val) check((val), #val, __FILE__, __LINE__)

void inline check(cudaError_t result, char const *const func, const char *const file,
           int const line) {
  if (result) {
    fprintf(stderr, "CUDA error at %s:%d code=%d(%s) \"%s\" \n", file, line,
            static_cast<unsigned int>(result), cudaGetErrorName(result), func);
    exit(EXIT_FAILURE);
  }
}

