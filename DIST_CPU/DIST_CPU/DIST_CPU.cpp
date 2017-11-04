#include "stdafx.h"
#include "Math.h"
#include "time.h"
#include "malloc.h"
#include "stdio.h"

//������㺯��
//X�������
//R���ο���
//Return���������ο���֮��ľ���
float CalDistance(float X, float R)
{
	float result = 0;
	result = sqrt((X - R)*(X - R));
	return result;
}

//��ֲ����㺯��
//i����i���㣨ע���0��ʼ��
//N������Ŀ
//Return����i�����ֵ
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

	int  N = 100000000;//����	
	float R = 6.0f;						//�ο���
	float* D = (float*)malloc(N * sizeof(float));				//������


	for (int i = 0; i < N; i++)
	{
		float X = CalScale(i, N);
		D[i] = CalDistance(X, R);
	}
	clock_t timeend = clock();
	double protime = (timeend - timebegin);

	printf("�����ʱ��%fms", protime);
	printf("\r\nD[50]��%f", D[50]);
	scanf_s("%d", &N);
	free(D);
	scanf_s("%d", &N);
	return 0;
}

