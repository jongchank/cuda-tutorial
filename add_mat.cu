#include <stdio.h>

#define X 10
#define Y 10

__global__ void add_mat_kernel(int *a, int *b, int *c)
{
    int x, y, i;

    x = blockIdx.x * blockDim.x + threadIdx.x;
    y = blockIdx.y * blockDim.y + threadIdx.y;

//    printf("%d:%d\n", x, y);

    i = y * gridDim.x * blockDim.x + x;

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
            cpu_a[i][j] = i * X + j;
            cpu_b[i][j] = -(i * X + j);
        }
    }

    for (i = 0; i < X; i++) {
        for (j = 0; j < Y; j++) {
            printf("%2d ", cpu_a[i][j]);
        }
        printf("\n");
    }

    for (i = 0; i < X; i++) {
        for (j = 0; j < Y; j++) {
            printf("%2d ", cpu_b[i][j]);
        }
        printf("\n");
    }

    cudaMalloc((void **)&gpu_a, size);
    cudaMalloc((void **)&gpu_b, size);
    cudaMalloc((void **)&gpu_c, size);

    cudaMemcpy(gpu_a, cpu_a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(gpu_b, cpu_b, size, cudaMemcpyHostToDevice);

    dim3 dimBlock(5, 2);
    dim3 dimGrid(2, 5);

    add_mat_kernel<<<dimGrid, dimBlock>>>(gpu_a, gpu_b, gpu_c);

    cudaDeviceSynchronize();

    cudaMemcpy(cpu_c, gpu_c, size, cudaMemcpyDeviceToHost);

    for (i = 0; i < X; i++) {
        for (j = 0; j < Y; j++) {
            printf("%2d ", cpu_c[i][j]);
        }
        printf("\n");
    }
    cudaFree(gpu_a);
    cudaFree(gpu_b);
    cudaFree(gpu_c);

    return 0;
}
