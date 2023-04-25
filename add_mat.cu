#include <stdio.h>

#define X 10
#define Y 10

__global__ void add_mat_kernel(int *a, int *b, int *c)
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
    int i, j;
    int size = X * Y *  sizeof(int);

    int cpu_a[X][Y];
    int cpu_b[X][Y];
    int cpu_c[X][Y];

    int *gpu_a = NULL;
    int *gpu_b = NULL;
    int *gpu_c = NULL;

    for (i = 0; i < X; i++) {
        for (j = 0; j < Y; j++) {
            cpu_a[i][j] = 1;
            cpu_b[i][j] = 2;
        }
    }

    cudaMalloc((void **)&gpu_a, size);
    cudaMalloc((void **)&gpu_b, size);
    cudaMalloc((void **)&gpu_c, size);

    cudaMemcpy(gpu_a, cpu_a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(gpu_b, cpu_b, size, cudaMemcpyHostToDevice);

    add_mat_kernel<<<20, 5>>>(gpu_a, gpu_b, gpu_c);

    cudaDeviceSynchronize();

    cudaMemcpy(cpu_c, gpu_c, size, cudaMemcpyDeviceToHost);

    for (i = 0; i < X; i++) {
        for (j = 0; j < Y; j++) {
            printf("%d ", cpu_c[i][j]);
        }
        printf("\n");
    }
    cudaFree(gpu_a);
    cudaFree(gpu_b);
    cudaFree(gpu_c);

    return 0;
}
