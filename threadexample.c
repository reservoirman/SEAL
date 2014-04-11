#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

#define Address(x) &x

typedef struct 
{
	int priority;
	void (*func)();

	/* rather than doing it this way, 
	keep the functions global and pass 
	in the Thread struct pointer
		void (*Go)();
	void (*Join)();
	void (*Pause)();
	void (*Unpause)();
	void (*Stop)();
	*/

} Thread;

void Go(Thread *t)
{

}

void Join(Thread *t)
{

}

void Pause(Thread *t)
{

}

void Unpause(Thread *t)
{

}

void Stop(Thread *t)
{

}


Thread thread1;


int main()
{
	Stop(&thread1);
	while (1)
	{
		printf("Hello World!\n");
		sleep(1);

	}
	return 0;
}