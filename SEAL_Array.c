#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include "SEAL_Array.h"

#define map(type) for (i=0;i<length;i++){function(type array + i);}
#define C_BYTE    (unsigned char   *)
#define C_SHORT   (short           *)
#define C_USHORT  (unsigned short  *)
#define C_INT     (int             *)
#define C_UINT    (unsigned int    *)
#define C_LONG    (long            *)
#define C_ULONG   (unsigned long   *)
#define C_FLOAT   (float           *)
#define C_DOUBLE  (double          *)

void SEALArray_Map(void *array, void (*function)(void * arg), int length, TYPE type)
{
  int i = 0;
  switch (type)
  {
    case BYTE:
      map(C_BYTE)
      break;
    case SHORT:
      map(C_SHORT)
      break;
    case USHORT:
      map(C_USHORT)
      break;
    case INT:
      printf("we're an int!\n");
      map(C_INT)
      break;
    case UINT:
      map(C_UINT)
      break;    
    case LONG:
      map(C_LONG)
      break;
    case ULONG:
      map(C_ULONG)
      break;
    case FLOAT:
      map(C_FLOAT)
      break;
    case DOUBLE:
      map(C_DOUBLE)
      break;
    default:
      map()
      break;
  }

}

int SEALArray_Sort(void *array)
{

}

int SEALArray_Reverse(void **array)
{

}
