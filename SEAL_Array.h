#ifndef __SEAL_ARRAY_H__
#define __SEAL_ARRAY_H__

typedef enum  
{
	BYTE, SHORT, USHORT, INT, UINT, LONG, ULONG, FLOAT, DOUBLE, OTHER
} TYPE;


void SEALArray_Map(void *array, void (*function)(void *arg), int length, TYPE type);

int SEALArray_Sort(void *array);

int SEALArray_Reverse(void **array);

void * SEALArray_Min(void **array);

void * SEALArray_Max(void **array);

#endif