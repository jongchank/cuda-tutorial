#include <stdio.h>

__global__ void hello_cuda()
{
    printf("Hello from GPU (%d, %d)\n", blockIdx.x, threadIdx.x);
}

int main(void)
{
    printf("Hello from CPU\n");

    hello_cuda<<<2, 3>>>();

    cudaDeviceSynchronize();

    return 0;
}
