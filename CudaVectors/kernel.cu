#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void addVectors(int* a, int* b, int* c) {
    int i = threadIdx.x;

    c[i] = a[i] + b[i];
}

int main()
{
    int a[] = { 1,2,3 };
    int b[] = { 4,5,6 };
    int c[sizeof(a) / sizeof(int)] = { 0 };

    int* cudaA = 0;
    int* cudaB = 0;
    int* cudaC = 0;

    // allocate gpu memory
    cudaMalloc(&cudaA, sizeof(a));
    cudaMalloc(&cudaB, sizeof(b));
    cudaMalloc(&cudaC, sizeof(c));

    // copy vectors to gpu memory
    cudaMemcpy(cudaA, a, sizeof(a), cudaMemcpyHostToDevice);
    cudaMemcpy(cudaB, b, sizeof(b), cudaMemcpyHostToDevice);

    // run addVectors function with grid of 1 block and pass parameters
    addVectors <<< 1, sizeof(a) / sizeof(int) >>> (cudaA, cudaB, cudaC);

    cudaMemcpy(c, cudaC, sizeof(c), cudaMemcpyDeviceToHost);

    return 0;
}
