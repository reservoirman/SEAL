#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "SEAL_Thread.h"
#include "SEAL_Lock.h"
#include "SEAL_Util.h"
#include "SEAL_Signal.h"
#include "SEAL_Array.h"

double buffer1;
double buffer2;
Lock outbufferLock;
Thread Thread1;
Thread Thread2;
void *Thread1___Func (void *arg)
{
while (1)
{sleep(1);
SEALLock_Acquire(&outbufferLock);
buffer1 = 2.4;
buffer2 = 4.5;
printf("Current throttle rate is %f degrees/sec, and current acceleration is %f knots/sec^2\n", buffer1, buffer2);
SEALLock_Release(&outbufferLock);
}
}

void *Thread2___Func (void *arg)
{
while (1)
{sleep(1);
SEALLock_Acquire(&outbufferLock);
buffer1 = 113.45;
buffer2 = 5.1;
printf("Current from servomotor is now %fmA, and voltage is now %fV\n", buffer1, buffer2);
SEALLock_Release(&outbufferLock);
}
}

Interrupt Intercepter;
void Intercepter____Handler (int sig)
{
printf("Ctrl+C pressed!  Exiting on next request\n");

SEALSignal_SetISR(Intercepter____Handler, &Intercepter);
SEALSignal_SetSignal(0, &Intercepter);

}

int main()
{
SEALSignal_SetISR(Intercepter____Handler, &Intercepter);
SEALSignal_SetSignal(1, &Intercepter);

SEALLock_Create(&outbufferLock);

SEALThread_Create(&Thread1, Thread1___Func);

SEALThread_Create(&Thread2, Thread2___Func);

SEALThread_Go(&Thread1);

SEALThread_Go(&Thread2);

while(1);

}

