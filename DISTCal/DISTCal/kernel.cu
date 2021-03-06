#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <malloc.h>
#include <time.h>

//距离计算函数
//X：输入点
//R：参考点
//Return：输入点与参考点之间的距离
__device__ float CalDistance(float X, float R)
{
	float result = 0;
	result = sqrt((X - R)*(X - R));
	return result;
}

//点0-10分布计算函数
//i：第i个点（注意从0开始）
//N：点数目
//Return：第i个点的值
__device__ float CalScale(int i, int N)
{
	float result = 0;
	for (int j = 0;j < 2;j++)
	{
		result += j* i*(10 - 0) / (N - 1.0);
	}
	return result;
}

//核函数
//dev_D:结果数组
//N: 点数
//R: 参考点
__global__ void DistKernel(float *dev_D, int N, float R)
{
	int i = blockDim.x*blockIdx.x + threadIdx.x;
	if (i >= N)return;
	float result;
	float scale;
	scale = CalScale(i, N);
	result = CalDistance(scale, R);
	dev_D[i] = result;
}

int main()
{
	clock_t timebegin = clock();

	int const N = 100000000;//点数
	float R = 6.0f;//参考点
	float* D  =  (float*)malloc(N*sizeof(float));//计算结果
	float* dev_D = 0;

	//GPU状态检测
	cudaError_t cudaStatus = cudaSetDevice(0);

	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
		return  -1;
	}

	cudaStatus = cudaMalloc((void**)&dev_D, N * sizeof(float));
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMalloc failed!");
		cudaFree(dev_D);
		return  -1;
	}

	//调用核函数
	DistKernel << <(N+1023)/1024, 1024 >> >(dev_D, N, R);

	cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
		cudaFree(dev_D);
		return  -1;
	}

	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
		cudaFree(dev_D);
		return  -1;
	}

	cudaStatus = cudaMemcpy(D, dev_D, N * sizeof(int), cudaMemcpyDeviceToHost);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed!");
		cudaFree(dev_D);
		return  -1;
	}

	//释放GPU资源
	cudaFree(dev_D);

	cudaStatus = cudaDeviceReset();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaDeviceReset failed!");
		return -1;
	}

	printf("D[50]=%f\r\n", D[50]);

	clock_t timeend = clock();
	double protime = (timeend - timebegin);

	printf("计算耗时：%fms", protime);
	//getchar();
	return 0;
}