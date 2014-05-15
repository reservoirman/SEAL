#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "SEAL_Thread.h"
#include "SEAL_Lock.h"
#include "SEAL_Util.h"
#include "SEAL_Signal.h"
#include "SEAL_Array.h"

int main()
{
int a;
int b;
a = 305419896;

printf("a = %X\n", a);

SEALUtil_Swap((void *)&a, sizeof(a));

printf("a = %X\n", a);

SEALUtil_Swap((void *)&a, sizeof(a));

printf("a = %X\n", a);

return 0;

}

