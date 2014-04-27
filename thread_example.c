#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "SEAL_Thread.h"

Thread thread1, thread2;

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
  }

}


int main()
{
  SEALThread_Create(&thread1, Thread1Func, 1);
  SEALThread_Create(&thread2, Thread2Func, 2);

  SEALThread_Go(&thread1);
  SEALThread_Go(&thread2);
  SEALThread_Stop(&thread1);

  while (1)
  {
    printf("Hello World!\n");
    sleep(1);

  }
  return 0;
}