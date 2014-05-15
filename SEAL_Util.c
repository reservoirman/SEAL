#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "SEAL_Util.h"

void * SEALUtil_Swap(void *object, int length)
{
	int i;
	char temp;
	char *array = (char *)object;
	int arraymax = length - 1;
	for (i = 0; i < (length / 2); i++)
	{
		temp = array[i];
		array[i] = array[arraymax - i];
		array[arraymax - i] = temp;
	}

	return object;
}


void * SEALUtil_Move(void * object, void *location, int length)
{
	return memmove(location, object, (size_t)length);
}
#define SEALUtil_Length(x) sizeof(x)
