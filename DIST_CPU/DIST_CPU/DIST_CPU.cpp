#include "stdafx.h"
#include "Math.h"
#include "time.h"
#include "malloc.h"
#include "stdio.h"

//距离计算函数
//X：输入点
//R：参考点
//Return：输入点与参考点之间的距离
float CalDistance(float X, float R)
{
	float result = 0;
	result = sqrt((X - R)*(X - R));
	return result;
}

//点分布计算函数
//i：第i个点（注意从0开始）
//N：点数目
//Return：第i个点的值
float CalScale(int i, int N)
{
	float result = 0;
	for (int j = 0;j < 100;j++)
	{
	   result +=j* i*(10 - 0) / (N - 1.0);
	}

	return result;
}

int main()
{
	clock_t timebegin = clock();

	int  N = 100000000;//点数	
	float R = 6.0f;						//参考点
	float* D = (float*)malloc(N * sizeof(float));				//计算结果


	for (int i = 0; i < N; i++)
	{
		float X = CalScale(i, N);
		D[i] = CalDistance(X, R);
	}
	clock_t timeend = clock();
	double protime = (timeend - timebegin);

	printf("计算耗时：%fms", protime);
	printf("\r\nD[50]：%f", D[50]);
	scanf_s("%d", &N);
	free(D);
	scanf_s("%d", &N);
	return 0;
}

