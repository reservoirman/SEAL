#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include "SEAL_Signal.h"



void SEALSignal_SetSignal(int sig, Interrupt *interrupt)
{
	interrupt->Source = sig; 
	switch (interrupt->Source)
	{
		case -1:
			//ignore all
			signal(SIGINT, SIG_IGN);
			break;
		case 0:
			//restore default to all
			signal(SIGINT, SIG_DFL);
			break;
		case SEALINT:
			signal(SIGINT, interrupt->func);

			break;
	}
}

//for use with code generation.  
//This may go away and be replaced by a direct assignment, depending if 
//additional checks may be done here
void SEALSignal_SetISR(void (*isr)(int), Interrupt *interrupt)
{
	interrupt->func = isr;
}