#include <stdio.h>
#include <unistd.h>
#include "SEAL_Signal.h"

Interrupt ouchie;

void ouch (int sig)
{
	printf("OUCH! I got signal %d\n", ouchie.Source);
	SEALSignal_SetSignal(0, &ouchie);
}



int main()
{
	SEALSignal_SetISR(ouch, &ouchie);
	SEALSignal_SetSignal(SEALINT, &ouchie);

	int holla = 2;
	while (1)
	{
		printf("Hello World!\n");
		sleep(1);

	}
	return 0;
}