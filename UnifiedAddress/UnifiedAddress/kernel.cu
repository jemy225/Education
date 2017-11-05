
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>



__global__ void addKernel(int *a,  int *b,  int *c)
{
	int i = threadIdx.x;
	c[i] = a[i] + b[i];
	printf("%d,%d,%d\r\n", a[i],b[i], c[i]);
}

int main()
{
	int arraySize = 5;
	int* a = 0;
	int* b = 0;
	int* c = 0;
	cudaMallocManaged(&a, arraySize * sizeof(int));
	cudaMallocManaged(&b, arraySize * sizeof(int));
	cudaMallocManaged(&c, arraySize * sizeof(int));
	for (int n = 0;n < arraySize;n++)
	{
		a[n] = n + 1;
		b[n] = 10 * (n + 1);
	}
	addKernel << <1, arraySize >> > (a, b, c);
	cudaDeviceSynchronize();

	printf("{1,2,3,4,5} + {10,20,30,40,50} = {%d,%d,%d,%d,%d}\n",
		c[0], c[1], c[2], c[3], c[4]);

	cudaDeviceReset();
	getchar();
	return 0;
}
