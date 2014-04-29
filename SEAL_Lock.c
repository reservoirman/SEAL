#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include "SEAL_Lock.h"

static unsigned char _threadID = 0;

void SEALLock_Create(Lock *l)
{
  l->lock = malloc(sizeof(pthread_mutex_t));
  pthread_mutex_init(l->lock, NULL);
}

int SEALLock_Acquire(Lock *l)
{
  pthread_mutex_lock(l->lock);
}

int SEALLock_Release(Lock *l)
{
  pthread_mutex_unlock(l->lock);

}

void SEALLock_Destroy(Lock *l)
{
  pthread_mutex_destroy(l->lock);
  free(l->lock);
  l->lock = NULL;
}
