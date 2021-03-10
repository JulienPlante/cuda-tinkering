# PINNED-POSIX-SHMEM

Little experiment to find out whether POSIX shared memory (`shm_open`, `shm_unlink`) can be pinned by `cudaHostRegister`.


A `writer` writes dummy data in a POSIX shared memory. It is then verified that the pinned shared memory is functional with the `reader`, that reads and prints shared memory contents to standard output.

