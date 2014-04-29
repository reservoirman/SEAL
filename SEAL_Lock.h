#ifndef __SEAL_LOCK_H__
#define __SEAL_LOCK_H__

typedef struct 
{
  void *lock;
} Lock;

void SEALLock_Create(Lock *t);

int SEALLock_Acquire(Lock *t);

int SEALLock_Release(Lock *t);

void SEALLock_Destroy(Lock *t);

#endif