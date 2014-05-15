#ifndef __SEAL_SIGNAL_H__
#define __SEAL_SIGNAL_H__

#define SEALINT 1

typedef struct 
{
void *Address;
int Source;
void (*func)(int);
} Interrupt;

void SEALSignal_SetISR(void (*isr)(int), Interrupt *interrupt);
void SEALSignal_SetSignal(int sig, Interrupt *interrupt);
#endif