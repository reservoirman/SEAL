#ifndef __SEAL_THREAD_H__
#define __SEAL_THREAD_H__

typedef struct 
{
  int priority;
  void * pthread;
  void *(*func)(void *);

} Thread;

void SEALThread_Create(Thread *t, void * (*function) (void * arg), int priority);

int SEALThread_Go(Thread *t);

void SEALThread_Join(Thread *t);

void SEALThread_Pause(Thread *t);

void SEALThread_Unpause(Thread *t);

void SEALThread_Stop(Thread *t);

#endif