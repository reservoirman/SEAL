Lock outbufferLock;

Double buffer1;
Double buffer2;

//this thread receives speed data and calculates throttle rate and current acceleration
Thread Thread1 
{	
	While(1)
	{
		sleep(1);
		outbufferLock.Acquire();
		buffer1 = 2.4;
		buffer2 = 4.5;
		print("Current throttle rate is %f degrees/sec, and current acceleration is %f knots/sec^2\n", buffer1, buffer2);
		outbufferLock.Release();

	}
}
/* 	this thread uses the same output buffer to send out telemetric data, in this case
	the voltage and current readings of the autothrottle computer */
Thread Thread2
{
	While(1)
	{
		sleep(1);
		outbufferLock.Acquire();
		buffer1 = 113.45;
		buffer2 = 5.1;
		printf("Current from servomotor is now %fmA, and voltage is now %fV\n", buffer1, buffer2);
		outbufferLock.Release();
	}
}

Interrupt Intercepter
{
	print("Ctrl+C pressed!  Exiting on next request\n");
	Intercepter.Source = 0;
}

Int main()
{
	Intercepter.Source = 1;
	outbufferLock.Lcreate();
	Thread1.Tcreate();
	Thread2.Tcreate();
	Thread1.Go();
	Thread2.Go();
	while(1);

}