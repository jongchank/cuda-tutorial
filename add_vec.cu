#include <stdio.h>

#define LEN 10

__global__ void add_vec_kernel(int *a, int *b, int *c)
{
    int i;
    int bi = blockIdx.x;
    int ti = threadIdx.x;

    printf("%d:%d\n", bi, ti);

    i = threadIdx.x + blockIdx.x * blockDim.x;
    c[i] = a[i] + b[i];
}

int main(void)
{
    int i;
    int size = LEN * sizeof(int);

    int cpu_a[LEN] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int cpu_b[LEN] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int cpu_c[LEN] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    int *gpu_a = NULL;
    int *gpu_b = NULL;
    int *gpu_c = NULL;

    cudaMalloc((void **)&gpu_a, size);
    cudaMalloc((void **)&gpu_b, size);
    cudaMalloc((void **)&gpu_c, size);

    cudaMemcpy(gpu_a, cpu_a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(gpu_b, cpu_b, size, cudaMemcpyHostToDevice);

    add_vec_kernel<<<2, 5>>>(gpu_a, gpu_b, gpu_c);

    cudaDeviceSynchronize();

    cudaMemcpy(cpu_c, gpu_c, size, cudaMemcpyDeviceToHost);

    for (i = 0; i < LEN; i++) {
        printf("C[%d] = %d\n", i, cpu_c[i]);
    }

    cudaFree(gpu_a);
    cudaFree(gpu_b);
    cudaFree(gpu_c);

    return 0;
}
