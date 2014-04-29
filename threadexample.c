#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>


pthread_t pthr1, pthr2;

char message[] = "Hello world";
int run_now = 1;

void *thread_function (void *arg)
{
	printf("Thread_function is running.  Argument is currently %s\n", (char *)arg);
	sleep(3);
	strcpy(message, "Bye!");
	int print_count2 = 0;
	while(print_count2++ < 20)
	{
		if (run_now == 2)
		{
			printf("2");
			run_now = 1;
		}
		else
		{
			sleep(1);
		}
	}
	pthread_exit("Thank you for the CPU time!");
	
}

typedef struct 
{
	int * whoa;
}holla;

void increment(holla *back)
{
	int a = 80;
	back->whoa = &a;
}

int main()
{
	int res;
	pthread_t a_thread;
	void *thread_result;

	res = pthread_create(&a_thread, NULL, thread_function, (void *)message);
	if (res != 0)
	{
		perror("Thread creation failed");
		exit(EXIT_FAILURE);
	}

	int print_count1 = 0;

	while (print_count1++ < 20) 
	{
		if (run_now == 1)
		{
			printf("1");
			run_now = 2;
		}
		else 
		{
			sleep(1);
		}
	}

	printf("\nWaiting for thread to finish...\n");
	res = pthread_join(a_thread, &thread_result);
	if (res != 0)
	{
		perror("Thread creation failed");
		exit(EXIT_FAILURE);
	}
	printf("Thread joined, returned: %s\n", (char *)thread_result);
	printf("Argument is now %s\n", message);


	holla one;
	increment(&one);
	printf("Is it 80? %d\n", *(one.whoa));
	exit(EXIT_SUCCESS);
	return 0;
}