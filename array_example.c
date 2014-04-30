#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "SEAL_Array.h"

int i = 0;

typedef struct 
{
	int hl;/* data */
} holla;


void addup(int * value)
{
	i++;
	*value = i;
}

void gangsta(void * g)
{
	holla * h = (holla *) g;
	h->hl = 23;
	printf("This is %d\n", h->hl);
}


void printvalues(int* v)
{
	printf("This is %d\n", *v);
}

void printvalues2(void *v)
{
	int *value = (int *)v;
	printf("Holla %d\n", *value);
}

int array[100];
holla whoa[234];
int main()
{
	printf("Welcome\n");
	SEALArray_Map((void *)array, (void (*)(void *))addup, 100, INT);
	SEALArray_Map((void *)array, printvalues2, 100, INT);
	SEALArray_Map((void *)whoa, gangsta, 234, OTHER);
	    int i = printf("HOLLA\n");
    printf("i = %d\n", i);

}

