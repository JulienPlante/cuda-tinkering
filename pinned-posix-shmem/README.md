# pinned-posix-shmem

## Description
Little experiment to find out whether POSIX shared memory (`shm_open`, `shm_unlink`) can be pinned by `cudaHostRegister`.


A `writer` writes dummy data in a POSIX shared memory. It is then verified that the pinned shared memory is functional with the `reader`, that reads and prints shared memory contents to standard output.


## Usage
```
make
./writer
./reader
```

Or simply:
```
make run
```


## Results
No error is raised, and `reader` successfully reads dummy data wrote by `writer`. At least on my system (Ubuntu 18.04.2 LTS, CUDA 11.2), POSIX shared memory can be pinned using `cudaHostRegister`.
