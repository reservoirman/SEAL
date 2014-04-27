#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include "SEAL_Thread.h"


void SEALThread_Create(Thread *t, void * (*function) (void * arg), int pri)
{
  //t->pthread = malloc(sizeof(pthread_t));
  pthread_t pp;
  t->pthread = &pp;
  t->func = function;
  t->priority = pri;

}

int SEALThread_Go(Thread *t)
{
  int success = -1;
  if (pthread_create((pthread_t *)t->pthread, NULL, t->func, (void *)&t->priority) == 0)
  {
    printf("Thread is now running!\n");
    success = 0;
  }
  return success;
}

void SEALThread_Join(Thread *t)
{

}

void SEALThread_Pause(Thread *t)
{

}

void SEALThread_Unpause(Thread *t)
{

}

void SEALThread_Stop(Thread *t)
{

}

void SEALThread_Destroy(Thread *t)
{
  free(t->pthread);
  t->pthread = NULL; 
  t->func = NULL;
  t->priority = 0;
}


