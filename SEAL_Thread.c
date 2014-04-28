#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include "SEAL_Thread.h"

static unsigned char _threadID = 0;

void SEALThread_Create(Thread *t, void * (*function) (void * arg))
{
  t->pthread = malloc(sizeof(pthread_t));
  t->func = function;

}


int SEALThread_Go(Thread *t)
{
  int success = -1;
  if (pthread_create((pthread_t *)t->pthread, NULL, t->func, &_threadID) == 0)
  {
    _threadID++;
    printf("Thread %d is now running!\n", _threadID);
    success = 0;
  }
  return success;
}

int SEALThread_Join(Thread *t)
{

}


int SEALThread_Stop(Thread *t)
{
  int success = -1;
  pthread_t thread = *(pthread_t *)t->pthread;
  if (pthread_cancel(thread) == 0)
  {
    success = 0;
    free(t->pthread);  
  }
  return success;
}


