#include <signal.h>
#include <stdio.h>
#include <unistd.h>

#define Address(x) &x

typedef struct 
{
void *Address;
int Source;
void (*func)(int);
} Interrupt;


Interrupt ouchie;


void ouch (int sig)
{
	printf("OUCH! I got signal %d\n", ouchie.Source);
	signal(sig, SIG_DFL);
	ouchie.Source = 0;

}



int main()
{
	ouchie.func = ouch;
	ouchie.Address = &ouchie;
	ouchie.Source = SIGINT;
	signal(ouchie.Source, ouchie.func);
	int holla = 2;
	while (1)
	{
		printf("Hello World!\n");
		sleep(1);

	}
	return 0;
}