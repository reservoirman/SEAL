#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "SEAL_Thread.h"
#include "SEAL_Lock.h"

Thread thread1, thread2, thread3;
Lock lock1;
int i = 0;

void *iCounter(void *arg)
{
	while (1)
	{ 
	sleep(1);
SEALLock_Acquire(&lock1);
	i++;
SEALLock_Release(&lock1);	
	}

}

void *Thread1Func (void *arg)
{
  while (1)
  {
    sleep(1);
    printf("Current output of the voltage and current sensors.\n");
  }
}



void *Thread2Func (void *arg)
{
  while (1)
  {
	sleep(1);
    printf("Current throttle rate reported.\n");
    if (i == 40)
    {	printf("Thread 2 exiting!\n");
    	return;
    }
  }

}


int main()
{
	SEALLock_Create(&lock1);
  SEALThread_Create(&thread1, Thread1Func);
  SEALThread_Create(&thread2, Thread2Func);
  SEALThread_Create(&thread3, iCounter);

  SEALThread_Go(&thread1);
  SEALThread_Go(&thread2);
  SEALThread_Go(&thread3);
  //SEALThread_Stop(&thread1);

  while (1)
  {

    //printf("Hello World!\n");
  	if (i == 10)
    {
    	printf("Stopped voltage and current sensors!\n");
    	SEALThread_Stop(&thread1);
    }

    if ( i == 20)
    {
    	printf("Reactivated voltage and current sensors!\n");
    	SEALThread_Go(&thread1);
    }

    if (i == 30)
    {
		printf("Stopped voltage and current sensors (again)!\n");
    	SEALThread_Stop(&thread1);
    	printf("Now waiting for thread2 to finish...\n");
    	SEALThread_Join(&thread2);
    }
	sleep(1);

  	SEALLock_Acquire(&lock1);
	i++;
	SEALLock_Release(&lock1);
	printf("main thread tickin' i = %d!\n", i);

  }

  SEALThread_Destroy(&thread1);
  SEALThread_Destroy(&thread2);
  SEALThread_Destroy(&thread3);
  SEALLock_Destroy(&lock1);
  return 0;
}