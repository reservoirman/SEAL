#ifndef __SEAL_THREAD_H__
#define __SEAL_THREAD_H__

typedef struct 
{
  void *pthread;
  void *(*func)(void *);

} Thread;

void SEALThread_Create(Thread *t, void * (*function) (void * arg));

int SEALThread_Go(Thread *t);

int SEALThread_Join(Thread *t);

int SEALThread_Stop(Thread *t);

void SEALThread_Destroy(Thread *t);

#endif